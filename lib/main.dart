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

/// Pantalla temporal solo para comprobar que el tema se aplica.
/// La reemplazaremos por la bienvenida real en el Módulo 2.
class PantallaInicio extends StatelessWidget {
  const PantallaInicio({super.key});

  @override
  Widget build(BuildContext context) {
    // Scaffold = el lienzo básico de una pantalla (appbar, body, etc.).
    return Scaffold(
      appBar: AppBar(
        title: const Text('VetConnect'),
      ),
      body: Center(
        // Column apila sus hijos verticalmente.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.pets, size: 80, color: TemaApp.verdeBosque),
            const SizedBox(height: 16),
            // Theme.of(context) lee el tema activo; aquí tomamos un estilo de texto.
            Text(
              'Hola, VetConnect',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Tu clínica veterinaria de confianza',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            // FilledButton toma el estilo píldora + verde de tu tema.
            FilledButton(
              onPressed: () {},
              child: const Text('Comenzar'),
            ),
          ],
        ),
      ),
    );
  }
}
