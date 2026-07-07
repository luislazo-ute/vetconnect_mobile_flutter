// Tests unitarios de dominio (sin plugins ni red).
import 'package:flutter_test/flutter_test.dart';

import 'package:vetconnect_app/domain/entities/rol.dart';
import 'package:vetconnect_app/domain/entities/usuario.dart';

void main() {
  test('Rol.desdeApi mapea los strings del backend', () {
    expect(Rol.desdeApi('ADMIN'), Rol.admin);
    expect(Rol.desdeApi('DOCTOR'), Rol.doctor);
    expect(Rol.desdeApi('USUARIO'), Rol.usuario);
    expect(Rol.desdeApi('cualquier_otro'), Rol.usuario); // fallback
  });

  test('Los getters de rol de Usuario funcionan', () {
    const admin = Usuario(
      id: 1, username: 'admin1', email: 'a@vet.com', isStaff: true, rol: Rol.admin,
    );
    expect(admin.esAdmin, true);
    expect(admin.esDoctor, false);
    expect(admin.esUsuario, false);
  });
}
