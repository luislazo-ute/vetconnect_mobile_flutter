import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/tema.dart';
import 'core/rutas.dart';

/// Punto de entrada de la app (como el if __name__ == '__main__' de Python).
void main() {
  // ProviderScope guarda el estado de todos los providers de Riverpod.
  runApp(const ProviderScope(child: VetConnectApp()));
}

/// Widget raíz. Es ConsumerWidget para poder leer el routerProvider (que
/// depende de la sesión).
class VetConnectApp extends ConsumerWidget {
  const VetConnectApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: 'VetConnect',
      debugShowCheckedModeBanner: false,
      theme: TemaApp.tema,
      routerConfig: router,
    );
  }
}
