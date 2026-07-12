import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
  bool _verClave = false;

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
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 44),
            decoration: const BoxDecoration(
              color: TemaApp.verdeBosque,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(36),
                bottomRight: Radius.circular(36),
              ),
            ),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Navigator.canPop(context)
                      ? IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.arrow_back,
                              color: Colors.white),
                          onPressed: () => Navigator.of(context).pop(),
                        )
                      : const SizedBox(height: 24),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.pets, size: 48, color: Colors.white),
                ),
                const SizedBox(height: 16),
                const Text(
                  'VetConnect',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Bienvenido de vuelta',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.8)),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 500.ms).slideY(
                begin: -0.15,
                end: 0,
                curve: Curves.easeOut,
              ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _userCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Usuario',
                      prefixIcon: Icon(Icons.person_outline),
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Ingresa tu usuario'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passCtrl,
                    obscureText: !_verClave,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _verClave ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () => setState(() => _verClave = !_verClave),
                      ),
                      border: const OutlineInputBorder(),
                    ),
                    validator: (v) => (v == null || v.isEmpty)
                        ? 'Ingresa tu contraseña'
                        : null,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: estado.cargando ? null : _entrar,
                      child: estado.cargando
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
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: TemaApp.verdeMedio.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Usuarios de prueba:\nadmin1 · doctor1 · cliente1\nClave: VetConnect2026',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 150.ms, duration: 500.ms).slideY(
                  begin: 0.1,
                  end: 0,
                ),
          ),
          // Fila de mascotitas al pie, de lado a lado.
          Image.asset(
            'assets/images/vetconnect_login.png',
            width: double.infinity,
            fit: BoxFit.fitWidth,
            alignment: Alignment.bottomCenter,
          ).animate().fadeIn(delay: 350.ms, duration: 600.ms).slideY(
                begin: 0.25,
                end: 0,
                curve: Curves.easeOut,
              ),
        ],
      ),
    );
  }
}
