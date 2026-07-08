import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    );
  }
}
