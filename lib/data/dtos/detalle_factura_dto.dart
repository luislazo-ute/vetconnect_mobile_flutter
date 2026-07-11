import '../../domain/entities/detalle_factura.dart';

class DetalleFacturaDto {
  final int id;
  final int servicio;
  final String servicioNombre;
  final int cantidad;
  final String precioUnitario;
  final String subtotal;

  const DetalleFacturaDto({
    required this.id,
    required this.servicio,
    required this.servicioNombre,
    required this.cantidad,
    required this.precioUnitario,
    required this.subtotal,
  });

  factory DetalleFacturaDto.fromJson(Map<String, dynamic> json) {
    return DetalleFacturaDto(
      id: json['id'] as int,
      servicio: json['servicio'] as int,
      servicioNombre: json['servicio_nombre'] as String? ?? '',
      cantidad: json['cantidad'] as int,
      precioUnitario: json['precio_unitario'].toString(),
      subtotal: json['subtotal'].toString(),
    );
  }

  DetalleFactura toDomain() {
    return DetalleFactura(
      id: id,
      servicio: servicio,
      servicioNombre: servicioNombre,
      cantidad: cantidad,
      precioUnitario: double.tryParse(precioUnitario) ?? 0,
      subtotal: double.tryParse(subtotal) ?? 0,
    );
  }
}
