import 'detalle_factura.dart';
import 'pago.dart';

class Factura {
  final int id;
  final int cliente;
  final String clienteUsername;
  final String fecha;
  final double total;
  final bool pagada;
  final List<DetalleFactura> detalles;
  final List<Pago> pagos;

  const Factura({
    required this.id,
    required this.cliente,
    required this.clienteUsername,
    required this.fecha,
    required this.total,
    required this.pagada,
    this.detalles = const [],
    this.pagos = const [],
  });

  String get totalFormateado => '\$${total.toStringAsFixed(2)}';
}
