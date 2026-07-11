import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/compra_providers.dart';

class PantallaCompraDetalle extends ConsumerWidget {
  final int compraId;
  const PantallaCompraDetalle({super.key, required this.compraId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(compraDetalleProvider(compraId));
    final textos = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text('Compra #$compraId')),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('No se pudo cargar la compra.'),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () => ref.invalidate(compraDetalleProvider(compraId)),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
        data: (compra) => ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(compra.proveedorNombre,
                style: textos.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _Campo('Fecha', compra.fechaCompra.split('T').first),
            const SizedBox(height: 8),
            _Campo('N° factura',
                compra.numeroFactura.isEmpty ? 'Sin número' : compra.numeroFactura),
            const SizedBox(height: 8),
            _Campo('Estado', compra.estadoDisplay),
            const SizedBox(height: 8),
            _Campo('Total', compra.totalFormateado),
            const SizedBox(height: 24),
            Text('Productos',
                style: textos.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (compra.detalles.isEmpty)
              const Text('Sin líneas registradas.')
            else
              ...compra.detalles.map(
                (d) => Card(
                  child: ListTile(
                    title: Text(d.productoNombre),
                    subtitle: Text(
                      '${d.cantidad} x \$${d.precioUnitario.toStringAsFixed(2)}',
                    ),
                    trailing: Text(
                      '\$${d.subtotal.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Campo extends StatelessWidget {
  final String etiqueta;
  final String valor;
  const _Campo(this.etiqueta, this.valor);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110,
          child: Text(etiqueta,
              style: TextStyle(
                fontSize: 13,
                color: cs.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              )),
        ),
        Expanded(child: Text(valor, style: const TextStyle(fontSize: 15))),
      ],
    );
  }
}
