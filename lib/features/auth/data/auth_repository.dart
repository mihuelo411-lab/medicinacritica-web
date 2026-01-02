import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/profile.dart';

class AuthRepository {
  AuthRepository({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;
  final SupabaseClient _client;

  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;
  Session? get currentSession => _client.auth.currentSession;

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) {
    return _client.auth.signInWithPassword(email: email, password: password);
  }

  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullName,
    required String dni,
    required String cmp,
    String requestedRole = 'medico',
    bool bootstrap = false,
  }) async {
    // 1. Crear el usuario en Auth (Supabase).
    // El TRIGGER 'on_auth_user_created' se encargará de crear:
    // - La fila en 'public.profiles' (con base en la metadata)
    // - La fila en 'public.pending_users'
    final response = await _client.auth.signUp(
      email: email,
      password: password,
      data: {
        'full_name': fullName,
        'dni': dni,
        'requested_role': requestedRole,
        'cmp': cmp,
        // Metadata adicional para que el Trigger sepa si es bootstrap (opcional, 
        // pero mejor manejamos bootstrap explícitamente abajo para seguridad).
      },
    );

    final user = response.user;
    
    // 2. Si es Bootstrap (Primer Admin), actualizamos su perfil para aprobarlo inmediatamente.
    // Esto es seguro porque el usuario YA existe (signUp exitoso).
    if (user != null && bootstrap) {
      // Esperar un momento breve por si el trigger tiene un retraso mínimo (raro en transacciones, 
      // pero útil si el trigger es "after commit" o similar).
      // En Postgres triggers, es sincrónico, así que debería estar listo.
      
      const adminRole = 'admin';
      
      // Actualizar Profile -> Admin y Aprobado
      await _client.from('profiles').update({
        'role': adminRole,
        'approved_at': DateTime.now().toIso8601String(),
        'approved_by': user.id, // Auto-aprobado
      }).eq('user_id', user.id);

      // Eliminar de pending_users (ya que es admin aprobado)
      await _client.from('pending_users').delete().eq('user_id', user.id);
    }
    
    return response;
  }

  Future<void> signOut() => _client.auth.signOut();

  Future<UserProfile?> fetchProfile(String userId) async {
    final data = await _client
        .from('profiles')
        .select()
        .eq('user_id', userId)
        .maybeSingle();
    if (data == null) return null;
    return UserProfile.fromMap(data);
  }

  Future<UserProfile> ensureProfileForUser(User user) async {
    final existing = await fetchProfile(user.id);
    if (existing != null) return existing;
    final name =
        user.userMetadata?['full_name'] ??
        user.userMetadata?['name'] ??
        user.userMetadata?['fullName'] ??
        user.email;
    final dni = user.userMetadata?['dni']?.toString();
    final cmp = user.userMetadata?['cmp']?.toString();
    final requestedRole =
        user.userMetadata?['requested_role']?.toString() ?? 'medico';
    final Map<String, dynamic> payload = {
      'user_id': user.id,
      'full_name': name?.toString(),
      'dni': dni,
      'cmp': cmp,
      'role': requestedRole,
      'approved_at': null,
    };
    await _sendWithCmpFallback(
      (body) => _client.from('profiles').insert(body),
      payload,
    );
    await _sendWithCmpFallback(
      (body) => _client.from('pending_users').upsert(body),
      {
        'user_id': user.id,
        'full_name': name,
        'dni': dni,
        'cmp': cmp,
        'email': user.email,
        'requested_role': requestedRole,
      },
    );
    return (await fetchProfile(user.id)) ?? UserProfile.fromMap(payload);
  }

  Future<List<Map<String, dynamic>>> fetchPendingUsers() async {
    final data = await _client
        .from('pending_users')
        .select()
        .order('created_at');
    return List<Map<String, dynamic>>.from(data);
  }

  Future<bool> hasAnyProfile() async {
    final data = await _client.from('profiles').select('user_id').limit(1);
    return data.isNotEmpty;
  }

  Future<List<UserProfile>> fetchApprovedProfiles() async {
    final data = await _client.from('profiles').select().order('created_at');
    return List<Map<String, dynamic>>.from(
      data,
    ).map(UserProfile.fromMap).toList();
  }

  Future<void> approveUser({
    required String userId,
    required String role,
    required String approvedBy,
  }) async {
    await _client
        .from('profiles')
        .update({
          'role': role,
          'approved_at': DateTime.now().toIso8601String(),
          'approved_by': approvedBy,
        })
        .eq('user_id', userId);
    await _client.from('pending_users').delete().eq('user_id', userId);
  }

  Future<void> rejectUser(String userId) async {
    await _client.from('pending_users').delete().eq('user_id', userId);
  }

  Future<Map<String, dynamic>> exportDatabaseDump({
    List<String>? tables,
  }) async {
    Future<List<Map<String, dynamic>>> fetchTable(String name) async {
      final result = await _client.from(name).select();
      return List<Map<String, dynamic>>.from(result);
    }

    final requested = tables?.toSet() ??
        {
          'patients',
          'admissions',
          'evolutions',
          'indication_sheets',
          'epicrisis_notes',
          'performed_procedures',
        };

    final Map<String, dynamic> payload = {
      'generated_at': DateTime.now().toIso8601String(),
    };

    Future<void> maybeAdd(String table) async {
      if (requested.contains(table)) {
        payload[table] = await fetchTable(table);
      }
    }

    await maybeAdd('patients');
    await maybeAdd('admissions');
    await maybeAdd('evolutions');
    await maybeAdd('indication_sheets');
    await maybeAdd('epicrisis_notes');
    await maybeAdd('performed_procedures');

    return payload;
  }

  Future<void> signInWithProvider(OAuthProvider provider) {
    return _client.auth.signInWithOAuth(provider);
  }

  Future<T> _sendWithCmpFallback<T>(
    Future<T> Function(Map<String, dynamic>) sender,
    Map<String, dynamic> payload,
  ) {
    return _retryOnForeignKeyDelay(() async {
      try {
        return await sender(payload);
      } on PostgrestException catch (error) {
        if (_isMissingCmpColumn(error) && payload.containsKey('cmp')) {
          final fallback = Map<String, dynamic>.from(payload)..remove('cmp');
          return sender(fallback);
        }
        rethrow;
      }
    });
  }

  Future<T> _retryOnForeignKeyDelay<T>(
    Future<T> Function() operation, {
    int attempts = 6,
    Duration initialDelay = const Duration(milliseconds: 300),
  }) async {
    var delay = initialDelay;
    PostgrestException? lastError;
    for (var attempt = 0; attempt < attempts; attempt++) {
      try {
        return await operation();
      } on PostgrestException catch (error) {
        if (!_isProfilesForeignKeyError(error) || attempt == attempts - 1) {
          rethrow;
        }
        lastError = error;
      }
      await Future.delayed(delay);
      delay *= 2;
      if (delay > const Duration(seconds: 4)) {
        delay = const Duration(seconds: 4);
      }
    }
    throw lastError ??
        PostgrestException(message: 'Unknown error', code: 'unknown');
  }

  bool _isMissingCmpColumn(PostgrestException error) {
    return error.code == 'PGRST204' && error.message.contains("'cmp'");
  }

  bool _isProfilesForeignKeyError(PostgrestException error) {
    if (error.code != '23503') return false;
    final message = error.message.toLowerCase();
    return message.contains('profiles_user_id_fkey') ||
        message.contains('pending_users_user_id_fkey');
  }
}
