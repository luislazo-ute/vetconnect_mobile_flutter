import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../notifiers/auth_notifier.dart';

/// Dashboard privado (temporal). En el Módulo 7 tendrá el menú por rol
/// y el bottom nav. Por ahora solo saluda y permite cerrar sesión.
class PantallaDashboard extends ConsumerWidget {
  const PantallaDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usuario = ref.watch(authNotifierProvider).usuario;
    final textos = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
        actions: [
          IconButton(
            tooltip: 'Cerrar sesión',
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authNotifierProvider.notifier).cerrarSesion(),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.pets, size: 64),
            const SizedBox(height: 16),
            Text('Hola, ${usuario?.username ?? ''}',
                style: textos.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            // usuario?.rol.name → el nombre del enum: "admin"/"doctor"/"usuario".
            Text('Rol: ${usuario?.rol.name ?? ''}', style: textos.bodyLarge),
          ],
        ),
      ),
    );
  }
}
