import 'package:flutter/material.dart';

/// Home público (temporal). En los próximos pasos añadiremos el saludo,
/// las secciones y los listados de servicios/veterinarios desde la API.
class PantallaHome extends StatelessWidget {
  const PantallaHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VetConnect'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.pets, size: 64, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              'Home público',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text('Aquí irán los servicios y el equipo.'),
          ],
        ),
      ),
    );
  }
}
