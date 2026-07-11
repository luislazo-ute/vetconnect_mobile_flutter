class Pago {
  final int id;
  final double monto;
  final String fechaPago;
  final String metodoPago;
  final String referencia;

  const Pago({
    required this.id,
    required this.monto,
    required this.fechaPago,
    required this.metodoPago,
    required this.referencia,
  });

  String get montoFormateado => '\$${monto.toStringAsFixed(2)}';

  String get metodoDisplay {
    switch (metodoPago) {
      case 'tarjeta':
        return 'Tarjeta';
      case 'transferencia':
        return 'Transferencia';
      case 'otro':
        return 'Otro';
      default:
        return 'Efectivo';
    }
  }
}
