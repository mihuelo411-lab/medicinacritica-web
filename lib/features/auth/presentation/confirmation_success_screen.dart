import 'package:flutter/material.dart';

class ConfirmationSuccessScreen extends StatelessWidget {
  const ConfirmationSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle_outline, size: 80, color: Colors.green),
              const SizedBox(height: 24),
              Text(
                '¡Cuenta Confirmada!',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Tu correo ha sido verificado correctamente.\n'
                'Ahora debes esperar a que un administrador apruebe tu acceso.\n'
                'Te notificaremos por correo cuando estés listo para ingresar.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to root (Login) typically
                    Navigator.of(context).pushReplacementNamed('/');
                  },
                  child: const Text('Volver al Inicio'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
