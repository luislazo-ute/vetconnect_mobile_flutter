class Habitacion {
  final int id;
  final String nombre;
  final int numero;
  final String tipo;
  final String tipoDisplay;
  final int capacidad;
  final String precioDia;
  final bool disponible;
  final bool isActive;

  const Habitacion({
    required this.id,
    required this.nombre,
    required this.numero,
    required this.tipo,
    required this.tipoDisplay,
    required this.capacidad,
    required this.precioDia,
    this.disponible = true,
    this.isActive = true,
  });
}
