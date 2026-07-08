class Servicio {
  final int id;
  final String nombre;
  final String descripcion;
  final double precio;
  final int duracionMinutos;
  final bool isActive;

  const Servicio({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.duracionMinutos,
    required this.isActive,
  });

  String get precioFormateado => '\$${precio.toStringAsFixed(2)}';
}
