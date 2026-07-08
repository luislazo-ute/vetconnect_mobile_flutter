import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/tema.dart';
import '../../notifiers/auth_notifier.dart';

class PantallaLogin extends ConsumerStatefulWidget {
  const PantallaLogin({super.key});

  @override
  ConsumerState<PantallaLogin> createState() => _PantallaLoginState();
}

class _PantallaLoginState extends ConsumerState<PantallaLogin> {
  final _formKey = GlobalKey<FormState>();
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  @override
  void dispose() {
    _userCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _entrar() {
    if (_formKey.currentState!.validate()) {
      ref
          .read(authNotifierProvider.notifier)
          .iniciarSesion(_userCtrl.text.trim(), _passCtrl.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final estado = ref.watch(authNotifierProvider);

    ref.listen(authNotifierProvider, (previo, actual) {
      if (actual.error != null && actual.error != previo?.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(actual.error!), backgroundColor: Colors.red),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar sesión')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 20),
            const Icon(Icons.pets, size: 72, color: TemaApp.verdeBosque),
            const SizedBox(height: 24),
            TextFormField(
              controller: _userCtrl,
              decoration: const InputDecoration(
                labelText: 'Usuario',
                border: OutlineInputBorder(),
              ),
              validator:
                  (v) =>
                      (v == null || v.trim().isEmpty)
                          ? 'Ingresa tu usuario'
                          : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passCtrl,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Contraseña',
                border: OutlineInputBorder(),
              ),
              validator:
                  (v) =>
                      (v == null || v.isEmpty) ? 'Ingresa tu contraseña' : null,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: estado.cargando ? null : _entrar,
              child:
                  estado.cargando
                      ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                      : const Text('Entrar'),
            ),
            const SizedBox(height: 16),
            const Text(
              'Prueba: admin1 / doctor1 / cliente1 — clave VetConnect2026',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
