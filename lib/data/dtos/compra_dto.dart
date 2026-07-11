import '../../domain/entities/compra.dart';

class CompraDto {
  final int id;
  final int proveedor;
  final String proveedorNombre;
  final String fechaCompra;
  final String numeroFactura;
  final String total;
  final String estado;

  const CompraDto({
    required this.id,
    required this.proveedor,
    required this.proveedorNombre,
    required this.fechaCompra,
    required this.numeroFactura,
    required this.total,
    required this.estado,
  });

  factory CompraDto.fromJson(Map<String, dynamic> json) {
    return CompraDto(
      id: json['id'] as int,
      proveedor: json['proveedor'] as int,
      proveedorNombre: json['proveedor_nombre'] as String? ?? '',
      fechaCompra: json['fecha_compra'] as String? ?? '',
      numeroFactura: json['numero_factura'] as String? ?? '',
      total: json['total'].toString(),
      estado: json['estado'] as String? ?? 'pendiente',
    );
  }

  Compra toDomain() {
    return Compra(
      id: id,
      proveedor: proveedor,
      proveedorNombre: proveedorNombre,
      fechaCompra: fechaCompra,
      numeroFactura: numeroFactura,
      total: double.tryParse(total) ?? 0,
      estado: estado,
    );
  }
}
