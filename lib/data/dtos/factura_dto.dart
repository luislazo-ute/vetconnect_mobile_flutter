import '../../domain/entities/factura.dart';

class FacturaDto {
  final int id;
  final int cliente;
  final String clienteUsername;
  final String fecha;
  final String total;
  final bool pagada;

  const FacturaDto({
    required this.id,
    required this.cliente,
    required this.clienteUsername,
    required this.fecha,
    required this.total,
    required this.pagada,
  });

  factory FacturaDto.fromJson(Map<String, dynamic> json) {
    return FacturaDto(
      id: json['id'] as int,
      cliente: json['cliente'] as int,
      clienteUsername: json['cliente_username'] as String? ?? '',
      fecha: json['fecha'] as String? ?? '',
      total: json['total'].toString(),
      pagada: json['pagada'] as bool? ?? false,
    );
  }

  Factura toDomain() {
    return Factura(
      id: id,
      cliente: cliente,
      clienteUsername: clienteUsername,
      fecha: fecha,
      total: double.tryParse(total) ?? 0,
      pagada: pagada,
    );
  }
}
