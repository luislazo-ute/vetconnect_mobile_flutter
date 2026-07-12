import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errores.dart';
import '../../providers/cliente_providers.dart';

/// Alta de un cliente nuevo.
///
/// En el backend `Cliente.user` es obligatorio, asi que hay que crear primero
/// la cuenta de usuario y luego el perfil de cliente apuntando a ella.
class PantallaClienteFormulario extends ConsumerStatefulWidget {
  const PantallaClienteFormulario({super.key});

  @override
  ConsumerState<PantallaClienteFormulario> createState() => _FormState();
}

class _FormState extends ConsumerState<PantallaClienteFormulario> {
  final _formKey = GlobalKey<FormState>();
  final _usuarioCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _claveCtrl = TextEditingController();
  final _telefonoCtrl = TextEditingController();
  final _direccionCtrl = TextEditingController();
  bool _verClave = false;
  bool _guardando = false;

  @override
  void dispose() {
    _usuarioCtrl.dispose();
    _emailCtrl.dispose();
    _claveCtrl.dispose();
    _telefonoCtrl.dispose();
    _direccionCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _guardando = true);

    final messenger = ScaffoldMessenger.of(context);
    try {
      // 1. La cuenta de usuario.
      final usuarioId = await ref.read(crearUsuarioUcProvider)({
        'username': _usuarioCtrl.text.trim(),
        'email': _emailCtrl.text.trim(),
        'password': _claveCtrl.text,
        'is_staff': false,
      });

      // 2. El perfil de cliente, vinculado a esa cuenta.
      await ref.read(crearClienteUcProvider)({
        'user': usuarioId,
        'telefono': _telefonoCtrl.text.trim(),
        'direccion': _direccionCtrl.text.trim(),
      });

      ref.invalidate(clientesProvider);
      if (mounted) {
        Navigator.of(context).pop();
        messenger.showSnackBar(
          const SnackBar(content: Text('Cliente creado')),
        );
      }
    } on ExcepcionApi catch (e) {
      if (mounted) setState(() => _guardando = false);
      messenger.showSnackBar(
        SnackBar(content: Text(e.mensaje), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Nuevo cliente')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text('Cuenta de acceso',
                style: textos.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 12),
            TextFormField(
              controller: _usuarioCtrl,
              decoration: const InputDecoration(
                labelText: 'Usuario',
                prefixIcon: Icon(Icons.person_outline),
                border: OutlineInputBorder(),
              ),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'El usuario es obligatorio'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'El email es obligatorio';
                if (!v.contains('@')) return 'Email inválido';
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _claveCtrl,
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
              validator: (v) {
                if (v == null || v.isEmpty) return 'La contraseña es obligatoria';
                if (v.length < 8) return 'Mínimo 8 caracteres';
                return null;
              },
            ),
            const SizedBox(height: 28),
            Text('Datos del cliente',
                style: textos.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 12),
            TextFormField(
              controller: _telefonoCtrl,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Teléfono',
                prefixIcon: Icon(Icons.phone_outlined),
                border: OutlineInputBorder(),
              ),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'El teléfono es obligatorio'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _direccionCtrl,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Dirección',
                prefixIcon: Icon(Icons.home_outlined),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 28),
            FilledButton(
              onPressed: _guardando ? null : _guardar,
              child: _guardando
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Crear cliente'),
            ),
          ],
        ),
      ),
    );
  }
}
