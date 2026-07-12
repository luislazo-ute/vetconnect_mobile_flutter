import 'package:flutter/material.dart';

import 'tema.dart';

class ItemNav {
  final IconData icono;
  final String etiqueta;
  const ItemNav({required this.icono, required this.etiqueta});
}

class BottomNavFlotante extends StatelessWidget {
  final int indiceActual;
  final List<ItemNav> items;
  final ValueChanged<int> alSeleccionar;

  const BottomNavFlotante({
    super.key,
    required this.indiceActual,
    required this.items,
    required this.alSeleccionar,
  });

  @override
  Widget build(BuildContext context) {
    final apagado = TemaApp.verdeBosque.withValues(alpha: 0.5);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      // Cada pestaña ocupa el mismo ancho y el nombre va DEBAJO del icono,
      // asi siempre se leen las 5 etiquetas completas.
      child: Row(
        children: List.generate(items.length, (i) {
          final activo = i == indiceActual;
          final item = items[i];

          return Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => alSeleccionar(i),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: activo
                          ? TemaApp.verdeBosque
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      item.icono,
                      size: 21,
                      color: activo ? Colors.white : apagado,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.etiqueta,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: activo ? FontWeight.w700 : FontWeight.w500,
                      color: activo ? TemaApp.verdeBosque : apagado,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
