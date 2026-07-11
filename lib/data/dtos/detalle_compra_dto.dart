import '../../domain/entities/detalle_compra.dart';

class DetalleCompraDto {
  final int id;
  final int producto;
  final String productoNombre;
  final int cantidad;
  final String precioUnitario;
  final String subtotal;

  const DetalleCompraDto({
    required this.id,
    required this.producto,
    required this.productoNombre,
    required this.cantidad,
    required this.precioUnitario,
    required this.subtotal,
  });

  factory DetalleCompraDto.fromJson(Map<String, dynamic> json) {
    return DetalleCompraDto(
      id: json['id'] as int,
      producto: json['producto'] as int,
      productoNombre: json['producto_nombre'] as String? ?? '',
      cantidad: json['cantidad'] as int,
      precioUnitario: json['precio_unitario'].toString(),
      subtotal: json['subtotal'].toString(),
    );
  }

  DetalleCompra toDomain() {
    return DetalleCompra(
      id: id,
      producto: producto,
      productoNombre: productoNombre,
      cantidad: cantidad,
      precioUnitario: double.tryParse(precioUnitario) ?? 0,
      subtotal: double.tryParse(subtotal) ?? 0,
    );
  }
}
