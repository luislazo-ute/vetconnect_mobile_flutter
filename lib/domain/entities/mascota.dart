class Mascota {
  final int id;
  final String nombre;
  final String especie;
  final String especieDisplay;
  final String raza;
  final String? fechaNacimiento;
  final double? peso;
  final int cliente;
  final String clienteNombre;
  final bool isActive;

  const Mascota({
    required this.id,
    required this.nombre,
    required this.especie,
    required this.especieDisplay,
    required this.raza,
    required this.fechaNacimiento,
    required this.peso,
    required this.cliente,
    required this.clienteNombre,
    required this.isActive,
  });

  String get pesoTexto =>
      peso != null ? '${peso!.toStringAsFixed(2)} kg' : 'N/D';
}
