import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../core/fondo_huellas.dart';
import '../../../core/tema.dart';

class PantallaHome extends StatelessWidget {
  const PantallaHome({super.key});

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bienvenido a',
                      style: textos.bodyMedium?.copyWith(color: Colors.grey),
                    ),
                    Text(
                      'VetConnect 🐾',
                      style: textos.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    _iconoCircular(
                      Icons.person_outline,
                      () => context.pushNamed('login'),
                    ),
                    const SizedBox(width: 8),
                    _iconoCircular(
                      Icons.mail_outline,
                      () => context.pushNamed('contacto'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(painter: FondoHuellas(opacidad: 0.08)),
                  ),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: const BoxDecoration(color: TemaApp.verdeBosque),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cuidamos a tu\nmascota',
                          style: textos.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Servicios veterinarios de confianza.',
                          style: textos.bodyMedium?.copyWith(
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                        const SizedBox(height: 16),
                        FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: TemaApp.verdeBosque,
                          ),
                          onPressed: () => context.pushNamed('servicios'),
                          child: const Text(
                            'Ver servicios',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),
            const SizedBox(height: 24),

            Text(
              'Explora',
              style: textos.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _acceso(context, Icons.medical_services_outlined, 'Servicios',
                    'servicios'),
                const SizedBox(width: 12),
                _acceso(context, Icons.groups_outlined, 'Equipo', 'equipo'),
                const SizedBox(width: 12),
                _acceso(context, Icons.mail_outline, 'Contacto', 'contacto'),
              ],
            ).animate().fadeIn(delay: 150.ms, duration: 400.ms).slideY(
                  begin: 0.15,
                  end: 0,
                ),
          ],
        ),
      ),
    );
  }

  Widget _iconoCircular(IconData icono, VoidCallback onTap) {
    return Material(
      color: TemaApp.verdeBosque.withValues(alpha: 0.08),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icono, color: TemaApp.verdeBosque),
        ),
      ),
    );
  }

  Widget _acceso(
      BuildContext context, IconData icono, String label, String ruta) {
    return Expanded(
      child: GestureDetector(
        onTap: () => context.pushNamed(ruta),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(icono, color: TemaApp.verdeBosque, size: 28),
              const SizedBox(height: 8),
              Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}
