class Habitacion {
  final int id;
  final String codigo;
  final String tipo;
  final String precioDia;
  final String estado;
  final int capacidad;
  final String observaciones;
  final bool isActive;

  const Habitacion({
    required this.id,
    required this.codigo,
    required this.tipo,
    required this.precioDia,
    required this.estado,
    required this.capacidad,
    this.observaciones = '',
    this.isActive = true,
  });

  bool get disponible => estado == 'disponible';

  String get estadoDisplay {
    switch (estado) {
      case 'ocupada':
        return 'Ocupada';
      case 'mantenimiento':
        return 'Mantenimiento';
      default:
        return 'Disponible';
    }
  }

  String get tipoDisplay =>
      tipo.isEmpty ? 'General' : '${tipo[0].toUpperCase()}${tipo.substring(1)}';
}
