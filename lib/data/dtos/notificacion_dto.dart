import '../../domain/entities/notificacion.dart';

class NotificacionDto {
  final int id;
  final String titulo;
  final String mensaje;
  final bool leida;
  final String fechaCreacion;

  const NotificacionDto({
    required this.id,
    required this.titulo,
    required this.mensaje,
    required this.leida,
    required this.fechaCreacion,
  });

  factory NotificacionDto.fromJson(Map<String, dynamic> json) {
    return NotificacionDto(
      id: json['id'] as int,
      titulo: json['titulo'] as String,
      mensaje: json['mensaje'] as String,
      leida: json['leida'] as bool? ?? false,
      fechaCreacion: json['fecha_creacion'] as String,
    );
  }

  Notificacion toDomain() {
    return Notificacion(
      id: id,
      titulo: titulo,
      mensaje: mensaje,
      leida: leida,
      fechaCreacion: fechaCreacion,
    );
  }
}
