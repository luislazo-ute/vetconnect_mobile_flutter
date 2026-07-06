/// Entidad de dominio: un servicio veterinario. Dart puro, sin Flutter ni JSON.
class Servicio {
  final int id;
  final String nombre;
  final String descripcion;
  final double precio;          // ya como número (el DTO lo convierte)
  final int duracionMinutos;    // camelCase, limpio
  final bool isActive;

  const Servicio({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.duracionMinutos,
    required this.isActive,
  });

  /// Precio formateado para mostrar, ej. "$25.00". La lógica de presentación
  /// va en getters de la entidad (convención del profe).
  String get precioFormateado => '\$${precio.toStringAsFixed(2)}';
}
