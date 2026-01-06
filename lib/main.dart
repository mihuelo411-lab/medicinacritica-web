import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/auth_gate.dart';
import 'features/auth/presentation/confirmation_success_screen.dart';
import 'core/database/database.dart';
import 'features/patients/data/patient_repository.dart';
import 'features/exams/data/exam_repository.dart';
import 'core/constants/supabase_credentials.dart';
import 'core/services/supabase_service.dart';
import 'core/services/sync_service.dart';

// Simple Service Locator (Global for now, replace with GetIt/Riverpod later)
late AppDatabase appDatabase;
late PatientRepository patientRepository;
ExamRepository? _examRepository;
bool _supabaseInitialized = false;
bool _databaseInitialized = false;
bool _patientRepoInitialized = false;
bool _localCacheCleared = false;
ExamRepository get examRepository =>
    _examRepository ??= LocalExamRepository(appDatabase);
Future<void>? _initialSyncTask;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const UciSystemApp());
}

class UciSystemApp extends StatefulWidget {
  const UciSystemApp({super.key});

  @override
  State<UciSystemApp> createState() => _UciSystemAppState();
}

class _UciSystemAppState extends State<UciSystemApp> {
  late Future<void> _bootstrapFuture;

  @override
  void initState() {
    super.initState();
    _bootstrapFuture = _bootstrap();
  }

  Future<void> _bootstrap() async {
    if (!_supabaseInitialized) {
      await SupabaseService().initialize(
        url: SupabaseCredentials.url,
        anonKey: SupabaseCredentials.anonKey,
      );
      _supabaseInitialized = true;
    }
    if (!_databaseInitialized) {
      appDatabase = AppDatabase();
      _databaseInitialized = true;
    }
    if (!_localCacheCleared) {
      await appDatabase.clearAllData();
      _localCacheCleared = true;
    }
    if (!_patientRepoInitialized) {
      patientRepository = LocalPatientRepository(appDatabase);
      _patientRepoInitialized = true;
    }
    _initialSyncTask ??= _runInitialSync();
  }

  Future<void> _runInitialSync() async {
    try {
      await SyncService(appDatabase, SupabaseService()).syncAll();
    } catch (error, stackTrace) {
      debugPrint('Initial sync failed: $error');
      debugPrint('$stackTrace');
    }
  }

  void _retryBootstrap() {
    setState(() {
      _bootstrapFuture = _bootstrap();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UCI System',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: FutureBuilder<void>(
        future: _bootstrapFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const _SplashScreen();
          }
          if (snapshot.hasError) {
            return _BootstrapErrorView(
              error: snapshot.error,
              onRetry: _retryBootstrap,
            );
          }
          return const AuthGate();
        },
      ),
      routes: {
        '/confirmation-success': (context) => const ConfirmationSuccessScreen(),
      },
    );
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            CircularProgressIndicator(),
            SizedBox(height: 12),
            Text('Inicializando datos...'),
          ],
        ),
      ),
    );
  }
}

class _BootstrapErrorView extends StatelessWidget {
  final Object? error;
  final VoidCallback onRetry;
  const _BootstrapErrorView({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.warning_amber_rounded, size: 48, color: Colors.redAccent),
              const SizedBox(height: 16),
              const Text('No se pudo sincronizar con Supabase.', textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text(
                '$error',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
