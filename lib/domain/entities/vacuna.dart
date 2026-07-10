class Vacuna {
  final int id;
  final int mascota;
  final String mascotaNombre;
  final String nombreVacuna;
  final String fechaAplicacion;
  final String? fechaProximaDosis;
  final String? lote;
  final String? dosis;
  final String? observaciones;
  final bool isActive;

  const Vacuna({
    required this.id,
    required this.mascota,
    required this.mascotaNombre,
    required this.nombreVacuna,
    required this.fechaAplicacion,
    this.fechaProximaDosis,
    this.lote,
    this.dosis,
    this.observaciones,
    this.isActive = true,
  });
}
