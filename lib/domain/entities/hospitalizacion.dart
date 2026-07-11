class Hospitalizacion {
  final int id;
  final int mascota;
  final String mascotaNombre;
  final int habitacion;
  final String habitacionCodigo;
  final String veterinarioNombre;
  final String fechaIngreso;
  final String? fechaAlta;
  final String motivo;
  final String? diagnostico;
  final String? tratamiento;
  final bool isActive;

  const Hospitalizacion({
    required this.id,
    required this.mascota,
    required this.mascotaNombre,
    required this.habitacion,
    required this.habitacionCodigo,
    this.veterinarioNombre = '',
    required this.fechaIngreso,
    this.fechaAlta,
    required this.motivo,
    this.diagnostico,
    this.tratamiento,
    this.isActive = true,
  });

  bool get activo => fechaAlta == null || fechaAlta!.isEmpty;

  String get estado => activo ? 'hospitalizado' : 'alta';

  String get estadoDisplay => activo ? 'Hospitalizado' : 'Dado de alta';
}
