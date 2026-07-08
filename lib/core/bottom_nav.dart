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
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (i) {
          final activo = i == indiceActual;
          final item = items[i];

          return GestureDetector(
            onTap: () => alSeleccionar(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color:
                    activo
                        ? TemaApp.verdeBosque
                        : TemaApp.verdeBosque.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(
                    item.icono,
                    size: 22,
                    color: activo ? Colors.white : TemaApp.verdeBosque,
                  ),
                  if (activo) ...[
                    const SizedBox(width: 8),
                    Text(
                      item.etiqueta,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
