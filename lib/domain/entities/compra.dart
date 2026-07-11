import 'detalle_compra.dart';

class Compra {
  final int id;
  final int proveedor;
  final String proveedorNombre;
  final String fechaCompra;
  final String numeroFactura;
  final double total;
  final String estado;
  final List<DetalleCompra> detalles;

  const Compra({
    required this.id,
    required this.proveedor,
    required this.proveedorNombre,
    required this.fechaCompra,
    required this.numeroFactura,
    required this.total,
    required this.estado,
    this.detalles = const [],
  });

  String get totalFormateado => '\$${total.toStringAsFixed(2)}';

  String get estadoDisplay {
    switch (estado) {
      case 'completada':
        return 'Completada';
      case 'cancelada':
        return 'Cancelada';
      default:
        return 'Pendiente';
    }
  }
}
