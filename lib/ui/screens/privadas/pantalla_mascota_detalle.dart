import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/imagenes.dart';
import '../../../core/tema.dart';
import '../../../domain/entities/mascota.dart';
import 'pantalla_galeria.dart';

class PantallaMascotaDetalle extends StatefulWidget {
  final Mascota mascota;
  const PantallaMascotaDetalle({super.key, required this.mascota});

  @override
  State<PantallaMascotaDetalle> createState() => _State();
}

class _State extends State<PantallaMascotaDetalle> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final m = widget.mascota;
    final textos = Theme.of(context).textTheme;

    return Scaffold(
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.zero,
            children: [
              Hero(
                tag: 'mascota-${m.id}',
                child: CachedNetworkImage(
                  imageUrl: imagenPorEspecie(m.especie),
                  height: 320,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (c, u) => Container(
                    height: 320,
                    color: TemaApp.verdeMedio.withValues(alpha: 0.2),
                  ),
                  errorWidget: (c, u, e) => Container(
                    height: 320,
                    color: TemaApp.verdeMedio.withValues(alpha: 0.2),
                    child: const Icon(Icons.pets, size: 80, color: Colors.white),
                  ),
                ),
              ),
              Transform.translate(
                offset: const Offset(0, -28),
                child: Container(
                  decoration: const BoxDecoration(
                    color: TemaApp.fondo,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                  ),
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _pill('Datos', 0),
                          const SizedBox(width: 8),
                          _pill('Salud', 1),
                          const SizedBox(width: 8),
                          _pill('Galería', 2),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        m.nombre,
                        style: textos.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${m.especieDisplay}${m.raza.isNotEmpty ? ' · ${m.raza}' : ''}',
                        style: textos.bodyLarge?.copyWith(color: Colors.grey),
                      ),
                      const SizedBox(height: 20),
                      _contenido(m, textos),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 12,
            child: CircleAvatar(
              backgroundColor: Colors.black.withValues(alpha: 0.35),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _contenido(Mascota m, TextTheme textos) {
    switch (_tab) {
      case 1:
        return Row(
          children: [
            Icon(
              m.isActive ? Icons.check_circle : Icons.cancel,
              color: m.isActive ? TemaApp.verdeBosque : Colors.red,
            ),
            const SizedBox(width: 8),
            Text(m.isActive ? 'Paciente activo' : 'Paciente inactivo'),
          ],
        );
      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Fotos de la galería (MongoDB).'),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const PantallaGaleria()),
              ),
              icon: const Icon(Icons.photo_library_outlined),
              label: const Text('Abrir galería'),
            ),
          ],
        );
      default:
        return Row(
          children: [
            _dato('Especie', m.especieDisplay),
            _dato('Raza', m.raza.isEmpty ? 'N/D' : m.raza),
            _dato('Peso', m.pesoTexto),
          ],
        );
    }
  }

  Widget _pill(String texto, int i) {
    final activo = _tab == i;
    return GestureDetector(
      onTap: () => setState(() => _tab = i),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
        decoration: BoxDecoration(
          color: activo ? TemaApp.verdeBosque : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
            ),
          ],
        ),
        child: Text(
          texto,
          style: TextStyle(
            color: activo ? Colors.white : TemaApp.texto,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _dato(String etiqueta, String valor) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8),
          ],
        ),
        child: Column(
          children: [
            Text(
              etiqueta,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              valor,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
