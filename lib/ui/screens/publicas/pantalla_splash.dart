import 'package:flutter/material.dart';

import '../../../core/tema.dart';

/// Pantalla de carga inicial, mientras se verifica si hay sesión guardada.
class PantallaSplash extends StatelessWidget {
  const PantallaSplash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TemaApp.verdeBosque,
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.pets, size: 80, color: Colors.white),
            SizedBox(height: 24),
            CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
