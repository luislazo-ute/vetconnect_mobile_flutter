import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errores.dart';
import '../../../domain/entities/veterinario.dart';
import '../../notifiers/veterinarios_notifier.dart';
import '../../providers/cliente_providers.dart';
import '../../providers/veterinario_providers.dart';

class PantallaVeterinarioFormulario extends ConsumerStatefulWidget {
  final Veterinario? veterinario;
  const PantallaVeterinarioFormulario({super.key, this.veterinario});

  @override
  ConsumerState<PantallaVeterinarioFormulario> createState() => _State();
}

class _State extends ConsumerState<PantallaVeterinarioFormulario> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nombre;
  late final TextEditingController _especialidad;
  late final TextEditingController _telefono;
  late final TextEditingController _email;
  late final TextEditingController _horario;
  final _usuarioCtrl = TextEditingController();
  final _claveCtrl = TextEditingController();
  bool _crearCuenta = false;
  bool _guardando = false;

  bool get _esEdicion => widget.veterinario != null;

  @override
  void initState() {
    super.initState();
    final v = widget.veterinario;
    _nombre = TextEditingController(text: v?.nombre ?? '');
    _especialidad = TextEditingController(text: v?.especialidad ?? '');
    _telefono = TextEditingController(text: v?.telefono ?? '');
    _email = TextEditingController(text: v?.email ?? '');
    _horario = TextEditingController(text: v?.horarioAtencion ?? '');
  }

  @override
  void dispose() {
    _nombre.dispose();
    _especialidad.dispose();
    _telefono.dispose();
    _email.dispose();
    _horario.dispose();
    _usuarioCtrl.dispose();
    _claveCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _guardando = true);
    final datos = <String, dynamic>{
      'nombre': _nombre.text.trim(),
      'especialidad': _especialidad.text.trim(),
      'telefono': _telefono.text.trim(),
      'email': _email.text.trim(),
      'horario_atencion': _horario.text.trim(),
    };
    final messenger = ScaffoldMessenger.of(context);
    try {
      // Vincular una cuenta es lo que convierte al veterinario en un
      // usuario con rol DOCTOR (el backend deriva el rol de ese vinculo).
      if (!_esEdicion && _crearCuenta) {
        datos['user'] = await ref.read(crearUsuarioUcProvider)({
          'username': _usuarioCtrl.text.trim(),
          'email': _email.text.trim(),
          'password': _claveCtrl.text,
          'is_staff': false,
        });
      }

      if (_esEdicion) {
        await ref.read(actualizarVeterinarioUcProvider)(
          widget.veterinario!.id,
          datos,
        );
      } else {
        await ref.read(crearVeterinarioUcProvider)(datos);
      }
      ref.read(veterinariosNotifierProvider.notifier).cargar();
      if (mounted) {
        Navigator.of(context).pop();
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              _esEdicion ? 'Veterinario actualizado' : 'Veterinario creado',
            ),
          ),
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
    return Scaffold(
      appBar: AppBar(
        title: Text(_esEdicion ? 'Editar veterinario' : 'Nuevo veterinario'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _campo(_nombre, 'Nombre', obligatorio: true),
            _campo(_especialidad, 'Especialidad', obligatorio: true),
            _campo(_telefono, 'Teléfono'),
            _campo(
              _email,
              'Email',
              tipo: TextInputType.emailAddress,
              validador:
                  (v) =>
                      (v != null && v.isNotEmpty && !v.contains('@'))
                          ? 'Email inválido'
                          : null,
            ),
            _campo(_horario, 'Horario de atención'),
            if (!_esEdicion) ...[
              const Divider(height: 28),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Crear cuenta de acceso'),
                subtitle: const Text(
                  'Le da login y el rol DOCTOR. Sin cuenta, el veterinario solo '
                  'aparece en el listado del equipo.',
                  style: TextStyle(fontSize: 12),
                ),
                value: _crearCuenta,
                onChanged: (v) => setState(() => _crearCuenta = v),
              ),
              if (_crearCuenta) ...[
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
                  controller: _claveCtrl,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Contraseña',
                    prefixIcon: Icon(Icons.lock_outline),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'La contraseña es obligatoria';
                    }
                    if (v.length < 8) return 'Mínimo 8 caracteres';
                    return null;
                  },
                ),
              ],
            ],
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _guardando ? null : _guardar,
              child:
                  _guardando
                      ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                      : Text(
                        _esEdicion ? 'Guardar cambios' : 'Crear veterinario',
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _campo(
    TextEditingController ctrl,
    String label, {
    bool obligatorio = false,
    TextInputType? tipo,
    String? Function(String?)? validador,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: ctrl,
        keyboardType: tipo,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator:
            validador ??
            (obligatorio
                ? (v) =>
                    (v == null || v.trim().isEmpty)
                        ? '$label obligatorio'
                        : null
                : null),
      ),
    );
  }
}
