class DetalleFactura {
  final int id;
  final int servicio;
  final String servicioNombre;
  final int cantidad;
  final double precioUnitario;
  final double subtotal;

  const DetalleFactura({
    required this.id,
    required this.servicio,
    required this.servicioNombre,
    required this.cantidad,
    required this.precioUnitario,
    required this.subtotal,
  });
}
