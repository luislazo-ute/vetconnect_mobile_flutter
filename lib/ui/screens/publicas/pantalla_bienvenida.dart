import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../core/fondo_huellas.dart';
import '../../../core/tema.dart';

class PantallaBienvenida extends StatelessWidget {
  const PantallaBienvenida({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TemaApp.verdeBosque,
      body: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: FondoHuellas())),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Spacer(),
                  Image.asset(
                    'assets/images/vetconnect_bulldog.png',
                    height: 340,
                    fit: BoxFit.contain,
                  ).animate().fadeIn(duration: 600.ms).scale(
                        begin: const Offset(0.92, 0.92),
                        end: const Offset(1, 1),
                        curve: Curves.easeOut,
                      ),
                  const Spacer(),
                  const Text(
                    'Todo lo que tu\nmascota necesita',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      height: 1.15,
                    ),
                  ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),
                  const SizedBox(height: 12),
                  Text(
                    'Cuidado veterinario de confianza,\nen la palma de tu mano.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 15,
                    ),
                  ).animate().fadeIn(delay: 300.ms),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: TemaApp.verdeBosque,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () => context.goNamed('home'),
                      child: const Text(
                        'Comenzar',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.3, end: 0),
                  const SizedBox(height: 4),
                  TextButton(
                    onPressed: () => context.pushNamed('login'),
                    child: Text(
                      'Ya tengo cuenta',
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.85)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
