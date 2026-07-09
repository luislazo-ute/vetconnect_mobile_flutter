import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/bottom_nav.dart';
import '../../../core/colecciones_mongo.dart';
import '../../../core/tema.dart';
import '../../../domain/entities/rol.dart';
import '../../notifiers/auth_notifier.dart';
import 'pantalla_citas.dart';
import 'pantalla_clientes_admin.dart';
import 'pantalla_coleccion_mongo.dart';
import 'pantalla_galeria.dart';
import 'pantalla_historiales.dart';
import 'pantalla_mascotas.dart';
import 'pantalla_veterinarios_admin.dart';
import 'pantalla_categorias.dart';
import 'pantalla_productos.dart';
import 'pantalla_servicios_admin.dart';

class PantallaDashboard extends ConsumerStatefulWidget {
  const PantallaDashboard({super.key});

  @override
  ConsumerState<PantallaDashboard> createState() => _PantallaDashboardState();
}

class _PantallaDashboardState extends ConsumerState<PantallaDashboard> {
  int _indice = 0;

  static const _paginas = [
    _TabInicio(),
    PantallaMascotas(),
    PantallaCitas(),
    _TabFacturacion(),
    _TabPerfil(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _paginas[_indice],
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
                  ItemNav(icono: Icons.receipt_long_outlined, etiqueta: 'Facturación'),
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

class _TabInicio extends ConsumerWidget {
  const _TabInicio();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usuario = ref.watch(authNotifierProvider).usuario;
    final textos = Theme.of(context).textTheme;

    return SafeArea(
      child: ListView(
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
                  const Icon(
                    Icons.verified_user_outlined,
                    color: TemaApp.verdeBosque,
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Text(_descripcionRol(usuario?.rol))),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(
                Icons.photo_library_outlined,
                color: TemaApp.verdeBosque,
              ),
              title: const Text('Galería de mascotas'),
              trailing: const Icon(Icons.chevron_right),
              onTap:
                  () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const PantallaGaleria()),
                  ),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(
                Icons.description_outlined,
                color: TemaApp.verdeBosque,
              ),
              title: const Text('Historiales médicos'),
              trailing: const Icon(Icons.chevron_right),
              onTap:
                  () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const PantallaHistoriales(),
                    ),
                  ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Datos clínicos (MongoDB)',
            style: textos.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...coleccionesMongo.map(
            (col) => Card(
              child: ListTile(
                leading: Icon(col.icono, color: TemaApp.verdeBosque),
                title: Text(col.titulo),
                trailing: const Icon(Icons.chevron_right),
                onTap:
                    () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => PantallaColeccionMongo(config: col),
                      ),
                    ),
              ),
            ),
          ),

          if (usuario?.rol == Rol.admin) ...[
            const SizedBox(height: 20),
            Text(
              'Gestión (admin)',
              style: textos.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.medical_information_outlined,
                  color: TemaApp.verdeBosque,
                ),
                title: const Text('Veterinarios'),
                trailing: const Icon(Icons.chevron_right),
                onTap:
                    () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const PantallaVeterinariosAdmin(),
                      ),
                    ),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.groups_outlined,
                  color: TemaApp.verdeBosque,
                ),
                title: const Text('Clientes'),
                trailing: const Icon(Icons.chevron_right),
                onTap:
                    () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const PantallaClientesAdmin(),
                      ),
                    ),
              ),
            ),
          ],
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

// ── Tab Facturación (Kevin Diaz) ──────────────────────────────────────────────
class _TabFacturacion extends ConsumerWidget {
  const _TabFacturacion();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textos = Theme.of(context).textTheme;
    final usuario = ref.watch(authNotifierProvider).usuario;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        children: [
          Text(
            'Facturación',
            style: textos.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Card(
            child: ListTile(
              leading:
                  const Icon(Icons.inventory_2_outlined, color: TemaApp.verdeBosque),
              title: const Text('Productos'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const PantallaProductos()),
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading:
                  const Icon(Icons.category_outlined, color: TemaApp.verdeBosque),
              title: const Text('Categorías de producto'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const PantallaCategorias()),
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.medical_services_outlined,
                  color: TemaApp.verdeBosque),
              title: const Text('Servicios'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const PantallaServiciosAdmin()),
              ),
            ),
          ),
          if (usuario?.rol == Rol.admin) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: TemaApp.verdeBosque.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.admin_panel_settings_outlined,
                      color: TemaApp.verdeBosque, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Eres admin: puedes crear, editar y eliminar en Facturación.',
                      style: TextStyle(color: TemaApp.verdeBosque, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
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
              style: textos.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Center(child: Text(usuario?.email ?? '', style: textos.bodyMedium)),
          const SizedBox(height: 32),
          FilledButton.icon(
            onPressed:
                () => ref.read(authNotifierProvider.notifier).cerrarSesion(),
            icon: const Icon(Icons.logout),
            label: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );
  }
}
