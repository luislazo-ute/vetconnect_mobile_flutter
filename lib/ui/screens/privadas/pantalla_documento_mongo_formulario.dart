import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/colecciones_mongo.dart';
import '../../../core/errores.dart';
import '../../providers/mongo_providers.dart';

class PantallaDocumentoMongoFormulario extends ConsumerStatefulWidget {
  final ColeccionMongo config;
  const PantallaDocumentoMongoFormulario({super.key, required this.config});

  @override
  ConsumerState<PantallaDocumentoMongoFormulario> createState() => _State();
}

class _State extends ConsumerState<PantallaDocumentoMongoFormulario> {
  final _formKey = GlobalKey<FormState>();
  late final Map<String, TextEditingController> _ctrls;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    _ctrls = {
      for (final c in widget.config.campos) c.clave: TextEditingController(),
    };
  }

  @override
  void dispose() {
    for (final c in _ctrls.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _guardando = true);

    final datos = <String, dynamic>{};
    for (final campo in widget.config.campos) {
      final txt = _ctrls[campo.clave]!.text.trim();
      datos[campo.clave] = campo.numero ? num.tryParse(txt) : txt;
    }

    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref
          .read(mongoRepositoryProvider)
          .crear(widget.config.coleccion, datos);
      ref.invalidate(documentosMongoProvider(widget.config.coleccion));
      if (mounted) {
        Navigator.of(context).pop();
        messenger.showSnackBar(
          const SnackBar(content: Text('Registro creado')),
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
      appBar: AppBar(title: Text('Nuevo: ${widget.config.titulo}')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            for (final campo in widget.config.campos) ...[
              TextFormField(
                controller: _ctrls[campo.clave],
                keyboardType:
                    campo.numero ? TextInputType.number : TextInputType.text,
                decoration: InputDecoration(
                  labelText: campo.etiqueta,
                  border: const OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Campo obligatorio';
                  if (campo.numero && num.tryParse(v.trim()) == null) {
                    return 'Debe ser un número';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
            ],
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
                      : const Text('Crear'),
            ),
          ],
        ),
      ),
    );
  }
}
