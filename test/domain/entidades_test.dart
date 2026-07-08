// Tests de entidades de dominio (Dart puro, sin red ni Flutter).
import 'package:flutter_test/flutter_test.dart';

import 'package:vetconnect_app/domain/entities/cita.dart';
import 'package:vetconnect_app/domain/entities/mascota.dart';
import 'package:vetconnect_app/domain/entities/rol.dart';
import 'package:vetconnect_app/domain/entities/servicio.dart';
import 'package:vetconnect_app/domain/entities/usuario.dart';

void main() {
  group('Rol', () {
    test('desdeApi mapea los strings del backend', () {
      expect(Rol.desdeApi('ADMIN'), Rol.admin);
      expect(Rol.desdeApi('DOCTOR'), Rol.doctor);
      expect(Rol.desdeApi('USUARIO'), Rol.usuario);
      expect(Rol.desdeApi('desconocido'), Rol.usuario); // fallback
    });
  });

  group('Usuario', () {
    test('getters de rol', () {
      const doctor = Usuario(
          id: 1, username: 'd', email: 'd@v.com', isStaff: false, rol: Rol.doctor);
      expect(doctor.esDoctor, true);
      expect(doctor.esAdmin, false);
      expect(doctor.esUsuario, false);
    });
  });

  group('Servicio', () {
    test('precioFormateado', () {
      const s = Servicio(
          id: 1, nombre: 'Consulta', descripcion: '', precio: 25,
          duracionMinutos: 30, isActive: true);
      expect(s.precioFormateado, r'$25.00');
    });
  });

  group('Mascota', () {
    test('pesoTexto con y sin peso', () {
      const conPeso = Mascota(
          id: 1, nombre: 'Firu', especie: 'perro', especieDisplay: 'Perro',
          raza: 'Lab', fechaNacimiento: null, peso: 18.5, cliente: 1,
          clienteNombre: 'c', isActive: true);
      expect(conPeso.pesoTexto, '18.50 kg');

      const sinPeso = Mascota(
          id: 2, nombre: 'Michi', especie: 'gato', especieDisplay: 'Gato',
          raza: '', fechaNacimiento: null, peso: null, cliente: 1,
          clienteNombre: 'c', isActive: true);
      expect(sinPeso.pesoTexto, 'N/D');
    });
  });

  group('Cita', () {
    test('fechaCorta y horaCorta', () {
      const c = Cita(
          id: 1, mascota: 1, mascotaNombre: 'Rocky', veterinario: 1,
          veterinarioNombre: 'Dr', fecha: '2026-07-09T23:14:52Z',
          hora: '23:14:52', motivo: 'x', estado: 'pendiente',
          estadoDisplay: 'Pendiente');
      expect(c.fechaCorta, '2026-07-09');
      expect(c.horaCorta, '23:14');
    });
  });
}
