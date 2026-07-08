import 'package:flutter/material.dart';

class PantallaContacto extends StatefulWidget {
  const PantallaContacto({super.key});

  @override
  State<PantallaContacto> createState() => _PantallaContactoState();
}

class _PantallaContactoState extends State<PantallaContacto> {
  final _formKey = GlobalKey<FormState>();
  final _nombreCtrl = TextEditingController();
  final _correoCtrl = TextEditingController();
  final _mensajeCtrl = TextEditingController();

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _correoCtrl.dispose();
    _mensajeCtrl.dispose();
    super.dispose();
  }

  void _enviar() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Mensaje enviado! Te contactaremos pronto.'),
        ),
      );
      _formKey.currentState!.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contacto')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                '¿Tienes dudas? Escríbenos y te respondemos.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _nombreCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                ),
                validator: (valor) {
                  if (valor == null || valor.trim().isEmpty) {
                    return 'El nombre es obligatorio';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _correoCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Correo',
                  border: OutlineInputBorder(),
                ),
                validator: (valor) {
                  if (valor == null || valor.trim().isEmpty) {
                    return 'El correo es obligatorio';
                  }
                  if (!valor.contains('@')) {
                    return 'Correo inválido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _mensajeCtrl,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Mensaje',
                  border: OutlineInputBorder(),
                ),
                validator: (valor) {
                  if (valor == null || valor.trim().isEmpty) {
                    return 'Escribe un mensaje';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              FilledButton(onPressed: _enviar, child: const Text('Enviar')),
            ],
          ),
        ),
      ),
    );
  }
}
