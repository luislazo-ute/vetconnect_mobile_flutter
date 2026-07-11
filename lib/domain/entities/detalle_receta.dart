class DetalleReceta {
  final int id;
  final int receta;
  final String medicamento;
  final String dosis;
  final String frecuencia;
  final String? duracion;
  final String? observaciones;

  const DetalleReceta({
    required this.id,
    required this.receta,
    required this.medicamento,
    required this.dosis,
    required this.frecuencia,
    this.duracion,
    this.observaciones,
  });
}
