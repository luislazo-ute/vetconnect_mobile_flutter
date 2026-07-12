import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/fondo_huellas.dart';
import 'core/tema.dart';
import 'core/rutas.dart';

void main() {
  runApp(const ProviderScope(child: VetConnectApp()));
}

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
      // Fondo común de toda la app: huellitas verde oscuro translúcidas,
      // para que las pantallas no se vean planas y blancas.
      builder: (context, child) => Stack(
        children: [
          Positioned.fill(
            child: ColoredBox(
              color: TemaApp.fondo,
              child: CustomPaint(
                painter: FondoHuellas(
                  color: TemaApp.verdeBosque,
                  opacidad: 0.05,
                  cantidad: 26,
                ),
              ),
            ),
          ),
          if (child != null) child,
        ],
      ),
    );
  }
}
