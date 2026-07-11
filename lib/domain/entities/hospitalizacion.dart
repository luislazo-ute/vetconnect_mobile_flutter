class Hospitalizacion {
  final int id;
  final int mascota;
  final String mascotaNombre;
  final int habitacion;
  final String habitacionNombre;
  final String fechaIngreso;
  final String? fechaAlta;
  final String motivo;
  final String? diagnostico;
  final String estado;
  final String estadoDisplay;
  final String? observaciones;
  final bool isActive;

  const Hospitalizacion({
    required this.id,
    required this.mascota,
    required this.mascotaNombre,
    required this.habitacion,
    required this.habitacionNombre,
    required this.fechaIngreso,
    this.fechaAlta,
    required this.motivo,
    this.diagnostico,
    required this.estado,
    required this.estadoDisplay,
    this.observaciones,
    this.isActive = true,
  });
}
