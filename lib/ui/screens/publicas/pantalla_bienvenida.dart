import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/tema.dart';

/// Pantalla pública de bienvenida (onboarding). Sin login.
class PantallaBienvenida extends StatelessWidget {
  const PantallaBienvenida({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TemaApp.verdeBosque, // fondo verde bosque
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              // Imagen grande de mascota (por ahora un ícono de huella).
              const Icon(Icons.pets, size: 140, color: Colors.white),
              const Spacer(),
              // Titular blanco en negrita.
              Text(
                'Bienvenido a VetConnect',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              // Subtítulo en blanco translúcido.
              Text(
                'El cuidado de tu mascota, en tus manos',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white70,
                    ),
              ),
              const SizedBox(height: 32),
              // Botón píldora "Comenzar": ocupa todo el ancho y navega al home.
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,           // blanco para contrastar
                    foregroundColor: TemaApp.verdeBosque,    // texto verde
                  ),
                  onPressed: () => context.goNamed('home'),
                  child: const Text('Comenzar'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
