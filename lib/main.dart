import 'package:flutter/material.dart';

import 'core/tema.dart';
import 'core/rutas.dart';

/// Punto de entrada de la app (como el if __name__ == '__main__' de Python).
void main() {
  runApp(const VetConnectApp());
}

/// Widget raíz: envuelve toda la aplicación.
/// Es StatelessWidget porque por sí mismo no cambia de estado.
class VetConnectApp extends StatelessWidget {
  const VetConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'VetConnect',
      debugShowCheckedModeBanner: false,
      theme: TemaApp.tema,
      routerConfig: routerApp,
    );
  }
}
