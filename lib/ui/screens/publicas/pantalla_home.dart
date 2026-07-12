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
            const SizedBox(height: 24),

            // El gatito se asoma por encima de la tarjeta, agarrado del borde.
            Stack(
              clipBehavior: Clip.none,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 62),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child:
                              CustomPaint(painter: FondoHuellas(opacidad: 0.10)),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                          decoration:
                              const BoxDecoration(color: TemaApp.verdeBosque),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Cuidamos a tu mascota',
                                style: textos.titleLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Servicios veterinarios de confianza para tu mejor amigo.',
                                style: textos.bodyMedium?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.85),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Image.asset(
                      'assets/images/gato_curioso.png',
                      height: 100,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            )
                .animate()
                .fadeIn(duration: 400.ms)
                .slideY(begin: 0.1, end: 0),
            const SizedBox(height: 28),

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
            const SizedBox(height: 28),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: TemaApp.verdeMedio.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: TemaApp.verdeBosque,
                    child: Icon(Icons.pets, color: Colors.white),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '¿Ya eres cliente?',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Inicia sesión para agendar citas y ver tus mascotas.',
                          style: textos.bodySmall?.copyWith(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: () => context.pushNamed('login'),
                    child: const Text('Entrar'),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 300.ms, duration: 400.ms),
          ],
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
