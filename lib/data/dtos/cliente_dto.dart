import '../../domain/entities/cliente.dart';

class ClienteDto {
  final int id;
  final String username;
  final String telefono;

  const ClienteDto({
    required this.id,
    required this.username,
    required this.telefono,
  });

  factory ClienteDto.fromJson(Map<String, dynamic> json) {
    return ClienteDto(
      id: json['id'] as int,
      username: json['username'] as String? ?? '',
      telefono: json['telefono'] as String? ?? '',
    );
  }

  Cliente toDomain() =>
      Cliente(id: id, username: username, telefono: telefono);
}
