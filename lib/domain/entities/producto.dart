class Producto {
  final int id;
  final String nombre;
  final String descripcion;
  final double precio;
  final int stock;
  final int categoria;
  final String categoriaNombre;
  final bool isActive;

  const Producto({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.stock,
    required this.categoria,
    required this.categoriaNombre,
    required this.isActive,
  });

  String get precioFormateado => '\$${precio.toStringAsFixed(2)}';
}
