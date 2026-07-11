class DetalleCompra {
  final int id;
  final int producto;
  final String productoNombre;
  final int cantidad;
  final double precioUnitario;
  final double subtotal;

  const DetalleCompra({
    required this.id,
    required this.producto,
    required this.productoNombre,
    required this.cantidad,
    required this.precioUnitario,
    required this.subtotal,
  });
}
