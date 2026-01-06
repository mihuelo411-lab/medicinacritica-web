import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../admin/presentation/admin_panel_screen.dart';
import '../../dashboard/presentation/uci_monitor_screen.dart';
import '../data/auth_repository.dart';
import '../domain/current_user.dart';
import '../domain/profile.dart';
import 'login_screen.dart';
import 'pending_approval_screen.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final AuthRepository _repository = AuthRepository();
  StreamSubscription<AuthState>? _subscription;
  Session? _session;
  UserProfile? _profile;
  bool _loadingProfile = false;
  bool? _hasProfiles;
  Timer? _inactivityTimer;
  String? _sessionMessage;

  static const Duration _sessionTimeout = Duration(minutes: 15);

  @override
  void initState() {
    super.initState();
    _checkExistingProfiles();
    _session = _repository.currentSession;
    final user = _session?.user;
    if (user != null) {
      _loadProfile(user);
      _resetInactivityTimer();
    }
    _subscription = _repository.authStateChanges.listen((event) {
      final authUser = event.session?.user;
      setState(() {
        _session = event.session;
        if (authUser != null) {
          _sessionMessage = null;
        } else {
          _profile = null;
        }
      });
      if (authUser != null) {
        _resetInactivityTimer();
        _loadProfile(authUser);
      } else {
        _cancelInactivityTimer();
        CurrentUserStore.set(null);
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _inactivityTimer?.cancel();
    super.dispose();
  }

  Future<void> _checkExistingProfiles() async {
    final hasProfiles = await _repository.hasAnyProfile();
    if (mounted) {
      setState(() {
        _hasProfiles = hasProfiles;
      });
    }
  }

  Future<void> _loadProfile(User user) async {
    setState(() {
      _loadingProfile = true;
    });
    final profile = await _repository.ensureProfileForUser(user);
    if (mounted) {
      setState(() {
        _profile = profile;
        _loadingProfile = false;
      });
      CurrentUserStore.set(profile);
    }
  }

  void _resetInactivityTimer() {
    _inactivityTimer?.cancel();
    if (_session != null) {
      _inactivityTimer = Timer(_sessionTimeout, _handleSessionTimeout);
    }
  }

  void _cancelInactivityTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = null;
  }

  void _handleUserInteraction([PointerEvent? _]) {
    if (_session != null) {
      _resetInactivityTimer();
    }
  }

  Future<void> _handleSessionTimeout() async {
    if (!mounted || _session == null) return;
    await _handleSignOut(
      infoMessage:
          'Tu sesión se cerró por inactividad. Inicia sesión nuevamente para continuar.',
    );
  }

  Future<void> _handleSignOut({String? infoMessage}) async {
    _cancelInactivityTimer();
    await _repository.signOut();
    CurrentUserStore.set(null);
    if (!mounted) return;
    setState(() {
      _profile = null;
      _sessionMessage = infoMessage;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (_session == null) {
      if (_hasProfiles == null) {
        child = const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      } else {
        child = LoginScreen(
          repository: _repository,
          isBootstrapMode: !_hasProfiles!,
          infoMessage: _sessionMessage,
          onBootstrapComplete: () {
            setState(() => _hasProfiles = true);
          },
        );
      }
    } else if (_session?.user.emailConfirmedAt == null) {
      child = PendingApprovalScreen(
        title: 'Confirma tu correo',
        message:
            'Revisa tu bandeja de entrada y confirma tu email para continuar.',
        onSignOut: _handleSignOut,
      );
    } else if (_loadingProfile || _profile == null) {
      child = const Scaffold(body: Center(child: CircularProgressIndicator()));
    } else if (!_profile!.isApproved) {
      child = PendingApprovalScreen(
        title: 'En espera de aprobación',
        message: 'Tu cuenta está pendiente de aprobación por un administrador.',
        onSignOut: _handleSignOut,
      );
    } else {
      child = UciMonitorScreen(
        showAdminControls: _profile!.isAdmin,
        onAdminPanelRequested: _profile!.isAdmin
            ? () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => AdminPanelScreen(
                      profile: _profile!,
                      repository: _repository,
                      onSignOut: _handleSignOut,
                    ),
                  ),
                );
              }
            : null,
        onSignOut: _handleSignOut,
      );
    }

    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: _handleUserInteraction,
      onPointerSignal: _handleUserInteraction,
      child: child,
    );
  }
}
