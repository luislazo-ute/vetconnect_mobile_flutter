import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/tema.dart';

/// Home público estilo Whisk: saludo, tarjeta resumen y secciones.
class PantallaHome extends StatelessWidget {
  const PantallaHome({super.key});

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme; // atajo para los estilos de texto

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // === Encabezado: saludo + campana ===
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Bienvenido a',
                        style: textos.bodyMedium?.copyWith(color: Colors.grey)),
                    Text('VetConnect',
                        style: textos.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
                IconButton(
                  // Temporal: la campana abre Contacto (luego será notificaciones).
                  // push = apila la pantalla y deja volver con la flecha atrás.
                  onPressed: () => context.pushNamed('contacto'),
                  icon: const Icon(Icons.notifications_outlined),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // === Tarjeta resumen (hero) verde bosque ===
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: TemaApp.verdeBosque,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Cuidamos a tu mascota 🐾',
                      style: textos.titleLarge?.copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Servicios veterinarios de confianza para tu mejor amigo.',
                      style: textos.bodyMedium?.copyWith(color: Colors.white70)),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // === Sección: Servicios ===
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Servicios',
                    style: textos.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                TextButton(onPressed: () {}, child: const Text('Ver más')),
              ],
            ),
            // Relleno temporal (hasta conectar la API).
            const Card(
              child: ListTile(
                leading: Icon(Icons.medical_services_outlined),
                title: Text('Pronto: servicios desde la API'),
              ),
            ),
            const SizedBox(height: 20),

            // === Sección: Nuestro equipo ===
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Nuestro equipo',
                    style: textos.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                TextButton(onPressed: () {}, child: const Text('Ver más')),
              ],
            ),
            const Card(
              child: ListTile(
                leading: Icon(Icons.person_outline),
                title: Text('Pronto: veterinarios desde la API'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
