import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/bottom_nav.dart';
import '../../../core/tema.dart';
import '../../../domain/entities/rol.dart';
import '../../notifiers/auth_notifier.dart';
import 'pantalla_citas.dart';
import 'pantalla_mascotas.dart';

/// Dashboard privado con bottom nav flotante y contenido según el rol.
class PantallaDashboard extends ConsumerStatefulWidget {
  const PantallaDashboard({super.key});

  @override
  ConsumerState<PantallaDashboard> createState() => _PantallaDashboardState();
}

class _PantallaDashboardState extends ConsumerState<PantallaDashboard> {
  // Índice de la pestaña activa (estado local de UI → setState está bien).
  int _indice = 0;

  static const _paginas = [
    _TabInicio(),
    PantallaMascotas(),
    PantallaCitas(),
    _TabPerfil(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // La página activa.
          _paginas[_indice],
          // El nav flotando sobre el contenido, abajo.
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: BottomNavFlotante(
                indiceActual: _indice,
                alSeleccionar: (i) => setState(() => _indice = i),
                items: const [
                  ItemNav(icono: Icons.home_outlined, etiqueta: 'Inicio'),
                  ItemNav(icono: Icons.pets_outlined, etiqueta: 'Pacientes'),
                  ItemNav(icono: Icons.event_outlined, etiqueta: 'Citas'),
                  ItemNav(icono: Icons.person_outline, etiqueta: 'Perfil'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// --- Pestaña Inicio: saludo + qué puede hacer según su rol. ---
class _TabInicio extends ConsumerWidget {
  const _TabInicio();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usuario = ref.watch(authNotifierProvider).usuario;
    final textos = Theme.of(context).textTheme;

    return SafeArea(
      child: ListView(
        // El padding inferior (100) deja aire para el nav flotante.
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        children: [
          Text('Hola,', style: textos.bodyLarge?.copyWith(color: Colors.grey)),
          Text(
            usuario?.username ?? '',
            style: textos.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _ChipRol(rol: usuario?.rol),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.verified_user_outlined, color: TemaApp.verdeBosque),
                  const SizedBox(width: 12),
                  Expanded(child: Text(_descripcionRol(usuario?.rol))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _descripcionRol(Rol? rol) => switch (rol) {
        Rol.admin =>
          'Acceso total: puedes crear, editar y eliminar en todo el sistema.',
        Rol.doctor =>
          'Puedes cambiar el estado de las citas y crear/editar historiales médicos.',
        Rol.usuario =>
          'Puedes agendar citas y consultar la información de la clínica.',
        null => 'Sin sesión.',
      };
}

/// Chip de color con el nombre del rol.
class _ChipRol extends StatelessWidget {
  final Rol? rol;
  const _ChipRol({required this.rol});

  @override
  Widget build(BuildContext context) {
    final (texto, color) = switch (rol) {
      Rol.admin => ('ADMIN', TemaApp.verdeBosque),
      Rol.doctor => ('DOCTOR', Colors.blue.shade700),
      Rol.usuario => ('USUARIO', TemaApp.verdeMedio),
      null => ('—', Colors.grey),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        texto,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}

/// --- Pestaña Perfil: datos del usuario + cerrar sesión. ---
class _TabPerfil extends ConsumerWidget {
  const _TabPerfil();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usuario = ref.watch(authNotifierProvider).usuario;
    final textos = Theme.of(context).textTheme;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        children: [
          const SizedBox(height: 20),
          const Center(
            child: CircleAvatar(
              radius: 48,
              backgroundColor: TemaApp.verdeMedio,
              child: Icon(Icons.person, size: 48, color: Colors.white),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              usuario?.username ?? '',
              style: textos.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Center(child: Text(usuario?.email ?? '', style: textos.bodyMedium)),
          const SizedBox(height: 32),
          FilledButton.icon(
            onPressed: () =>
                ref.read(authNotifierProvider.notifier).cerrarSesion(),
            icon: const Icon(Icons.logout),
            label: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );
  }
}
