import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../admin/presentation/admin_panel_screen.dart';
import '../../dashboard/presentation/uci_monitor_screen.dart';
import '../../../core/constants/supabase_credentials.dart';
import '../data/auth_repository.dart';
import '../domain/profile.dart';

class LoginScreen extends StatefulWidget {
  final AuthRepository repository;
  final bool isBootstrapMode;
  final VoidCallback? onBootstrapComplete;
  final String? infoMessage;
  const LoginScreen({
    super.key,
    required this.repository,
    this.isBootstrapMode = false,
    this.onBootstrapComplete,
    this.infoMessage,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginFormKey = GlobalKey<FormState>();
  final _registerFormKey = GlobalKey<FormState>();
  final _loginEmailCtl = TextEditingController();
  final _loginPasswordCtl = TextEditingController();
  final _regEmailCtl = TextEditingController();
  final _regPasswordCtl = TextEditingController();
  final _regNameCtl = TextEditingController();
  final _regDniCtl = TextEditingController();
  final _regCmpCtl = TextEditingController();
  late bool _isRegister;
  String _regRole = 'medico';
  bool _loading = false;
  String? _error;
  bool _oauthInFlight = false;
  Timer? _emailCooldownTimer;
  DateTime? _emailCooldownUntil;

  @override
  void dispose() {
    _emailCooldownTimer?.cancel();
    _loginEmailCtl.dispose();
    _loginPasswordCtl.dispose();
    _regEmailCtl.dispose();
    _regPasswordCtl.dispose();
    _regNameCtl.dispose();
    _regDniCtl.dispose();
    _regCmpCtl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _isRegister = widget.isBootstrapMode;
    _regRole = 'medico';
  }

  bool get _isEmailCooldownActive {
    if (_emailCooldownUntil == null) return false;
    return DateTime.now().isBefore(_emailCooldownUntil!);
  }

  int get _emailCooldownRemainingSeconds {
    if (!_isEmailCooldownActive) return 0;
    final remaining = _emailCooldownUntil!.difference(DateTime.now());
    return remaining.isNegative ? 0 : remaining.inSeconds + 1;
  }

  void _startEmailCooldown([Duration duration = const Duration(seconds: 31)]) {
    _emailCooldownUntil = DateTime.now().add(duration);
    _emailCooldownTimer?.cancel();
    _emailCooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_isEmailCooldownActive) {
        setState(() {});
      } else {
        timer.cancel();
        setState(() {
          _emailCooldownUntil = null;
        });
      }
    });
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _handleLogin() async {
    if (!_loginFormKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await widget.repository.signIn(
        email: _loginEmailCtl.text.trim(),
        password: _loginPasswordCtl.text.trim(),
      );
    } catch (e) {
      setState(() {
        _error = 'No se pudo iniciar sesión: $e';
      });
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _handleRegister() async {
    if (!_registerFormKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await widget.repository.signUp(
        email: _regEmailCtl.text.trim(),
        password: _regPasswordCtl.text.trim(),
        fullName: _regNameCtl.text.trim(),
        dni: _regDniCtl.text.trim(),
        cmp: _regCmpCtl.text.trim(),
        requestedRole: widget.isBootstrapMode ? 'admin' : _regRole,
        bootstrap: widget.isBootstrapMode,
      );
      if (!mounted) return;
      if (widget.isBootstrapMode) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Administrador creado. Inicia sesión con tus credenciales.',
            ),
          ),
        );
        widget.onBootstrapComplete?.call();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Revisa tu correo para confirmar la cuenta.'),
          ),
        );
      }
      setState(() {
        _isRegister = false;
        _loginEmailCtl.text = _regEmailCtl.text.trim();
        _regRole = 'medico';
        _regCmpCtl.clear();
      });
    } catch (e) {
      var message = 'No se pudo crear la cuenta: $e';
      if (e is AuthApiException) {
        final bool isRateLimitCode = e.code == 'over_email_send_rate_limit';
        final bool isRateLimitStatus = e.statusCode?.toString() == '429';
        if (isRateLimitCode || isRateLimitStatus) {
          _startEmailCooldown();
          final seconds = _emailCooldownRemainingSeconds;
          message =
              'Por seguridad, Supabase solo permite reenviar el correo cada 31 segundos. Intenta nuevamente en ${seconds > 0 ? seconds : 31} s.';
        }
      }
      setState(() {
        _error = message;
      });
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _handleOAuthLogin(OAuthProvider provider) async {
    if (widget.isBootstrapMode) return;
    setState(() {
      _oauthInFlight = true;
      _error = null;
    });
    try {
      await widget.repository.signInWithProvider(provider);
    } catch (e) {
      setState(() {
        _error = 'No se pudo continuar con el proveedor seleccionado: $e';
      });
    } finally {
      if (mounted) {
        setState(() => _oauthInFlight = false);
      }
    }
  }

  void _skipToAdminPanel() {
    final profile = UserProfile(
      userId: 'dev-admin-shortcut',
      role: 'admin',
      fullName: 'Admin (DEV)',
      approvedAt: DateTime.now(),
    );
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => UciMonitorScreen(
          showAdminControls: true,
          onAdminPanelRequested: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => AdminPanelScreen(
                  profile: profile,
                  repository: widget.repository,
                  onSignOut: () async {
                    await widget.repository.signOut();
                    if (context.mounted) Navigator.of(context).pop();
                  },
                ),
              ),
            );
          },
          onSignOut: () async {
            await widget.repository.signOut();
            if (context.mounted) Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _isRegister ? 'Crear cuenta' : 'Iniciar sesión',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 16),
                        if (widget.infoMessage != null) ...[
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.orange.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              widget.infoMessage!,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.orange.shade800),
                            ),
                          ),
                        ],
                        if (widget.isBootstrapMode)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.indigo.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Primer arranque: crea al administrador maestro.\nEsta cuenta tendrá acceso total y aprobará al resto.',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        if (_error != null) ...[
                          Text(
                            _error!,
                            style: const TextStyle(color: Colors.red),
                          ),
                          const SizedBox(height: 12),
                        ],
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          child: _isRegister
                              ? _buildRegisterForm()
                              : _buildLoginForm(),
                        ),
                        const SizedBox(height: 16),
                        if (!widget.isBootstrapMode && SupabaseCredentials.enableGoogleOAuth)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Column(
                              children: [
                                const Divider(),
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton.icon(
                                    onPressed: _oauthInFlight
                                        ? null
                                        : () => _handleOAuthLogin(
                                            OAuthProvider.google,
                                          ),
                                    icon: const Icon(Icons.account_circle),
                                    label: Text(
                                      _oauthInFlight
                                          ? 'Abriendo Google...'
                                          : 'Continuar con Google',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _isRegister = !_isRegister;
                              _error = null;
                            });
                          },
                          child: Text(
                            _isRegister
                                ? '¿Ya tienes cuenta? Inicia sesión'
                                : '¿Nuevo usuario? Regístrate',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (widget.isBootstrapMode)
            SafeArea(
              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Tooltip(
                    message: 'Atajo temporal mientras desarrollas el flujo',
                    child: ElevatedButton.icon(
                      onPressed: _skipToAdminPanel,
                      icon: const Icon(Icons.flash_on, size: 16),
                      label: const Text('Entrar como Admin'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange.shade400,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _loginFormKey,
      child: Column(
        children: [
          TextFormField(
            controller: _loginEmailCtl,
            decoration: const InputDecoration(labelText: 'Correo'),
            keyboardType: TextInputType.emailAddress,
            validator: (value) =>
                (value == null || value.isEmpty) ? 'Ingresa tu correo' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _loginPasswordCtl,
            decoration: const InputDecoration(labelText: 'Contraseña'),
            obscureText: true,
            validator: (value) => (value == null || value.length < 6)
                ? 'Ingresa tu contraseña'
                : null,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _loading ? null : _handleLogin,
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text('Ingresar'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterForm() {
    return Form(
      key: _registerFormKey,
      child: Column(
        children: [
          TextFormField(
            controller: _regNameCtl,
            decoration: const InputDecoration(labelText: 'Nombre completo'),
            validator: (value) =>
                (value == null || value.isEmpty) ? 'Ingresa tu nombre' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _regDniCtl,
            decoration: const InputDecoration(labelText: 'DNI'),
            validator: (value) =>
                (value == null || value.isEmpty) ? 'Ingresa tu DNI' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _regCmpCtl,
            decoration: const InputDecoration(labelText: 'CMP'),
            validator: (value) =>
                (value == null || value.isEmpty) ? 'Ingresa tu CMP' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _regEmailCtl,
            decoration: const InputDecoration(labelText: 'Correo'),
            keyboardType: TextInputType.emailAddress,
            validator: (value) =>
                (value == null || value.isEmpty) ? 'Ingresa tu correo' : null,
          ),
          if (!widget.isBootstrapMode) ...[
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _regRole,
              decoration: const InputDecoration(labelText: 'Rol solicitado'),
              items: const [
                DropdownMenuItem(value: 'medico', child: Text('Médico')),
                DropdownMenuItem(value: 'residente', child: Text('Residente')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _regRole = value);
                }
              },
            ),
          ],
          const SizedBox(height: 12),
          TextFormField(
            controller: _regPasswordCtl,
            decoration: const InputDecoration(labelText: 'Contraseña'),
            obscureText: true,
            validator: (value) => (value == null || value.length < 8)
                ? 'Mínimo 8 caracteres'
                : null,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: (_loading || _isEmailCooldownActive)
                  ? null
                  : _handleRegister,
              child: _loading
                  ? const CircularProgressIndicator()
                  : Text(
                      _isEmailCooldownActive
                          ? 'Espera ${_emailCooldownRemainingSeconds}s'
                          : 'Registrarme',
                    ),
            ),
          ),
          if (_isEmailCooldownActive) ...[
            const SizedBox(height: 8),
            Text(
              'Supabase requiere esperar antes de reenviar el correo. Intenta nuevamente en ${_emailCooldownRemainingSeconds}s.',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.orange.shade700),
            ),
          ],
        ],
      ),
    );
  }
}
