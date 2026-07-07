import 'package:flutter/material.dart';

import '../../../core/tema.dart';
import '../../../domain/entities/veterinario.dart';

/// Detalle de un veterinario. Recibe la entidad completa por navegación.
class PantallaVeterinarioDetalle extends StatelessWidget {
  final Veterinario veterinario;

  const PantallaVeterinarioDetalle({super.key, required this.veterinario});

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final vet = veterinario;

    return Scaffold(
      appBar: AppBar(title: Text(vet.nombre)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Avatar grande con Hero (misma tag que en la lista → animación).
          Center(
            child: Hero(
              tag: 'vet-${vet.id}',
              child: CircleAvatar(
                radius: 56,
                backgroundColor: TemaApp.verdeMedio,
                child: Text(
                  vet.nombre.isNotEmpty ? vet.nombre[0] : '?',
                  style: const TextStyle(fontSize: 40, color: Colors.white),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              vet.nombre,
              style: textos.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Center(
            child: Text(
              vet.especialidad,
              style: textos.bodyLarge?.copyWith(color: Colors.grey),
            ),
          ),
          const SizedBox(height: 24),

          // Tiles de datos.
          _Tile(icono: Icons.schedule, etiqueta: 'Horario', valor: vet.horarioAtencion),
          _Tile(icono: Icons.phone, etiqueta: 'Teléfono', valor: vet.telefono),
          _Tile(icono: Icons.email_outlined, etiqueta: 'Correo', valor: vet.email),
        ],
      ),
    );
  }
}

/// Fila de dato reutilizable (ícono + etiqueta + valor).
class _Tile extends StatelessWidget {
  final IconData icono;
  final String etiqueta;
  final String valor;

  const _Tile({required this.icono, required this.etiqueta, required this.valor});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icono, color: Theme.of(context).colorScheme.primary),
        title: Text(etiqueta),
        subtitle: Text(valor.isEmpty ? '—' : valor),
      ),
    );
  }
}
