import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
import 'pantalla_compras.dart';
import 'pantalla_facturas.dart';
import 'pantalla_productos.dart';
import 'pantalla_proveedores.dart';
import 'pantalla_servicios_admin.dart';
import 'pantalla_vacunas.dart';
import 'pantalla_hospitalizaciones.dart';
import 'pantalla_recetas.dart';
import 'pantalla_habitaciones.dart';
import 'pantalla_notificaciones.dart';

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
            'Clínica',
            style: textos.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(
                Icons.vaccines_outlined,
                color: TemaApp.verdeBosque,
              ),
              title: const Text('Vacunas'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const PantallaVacunas()),
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(
                Icons.local_hospital_outlined,
                color: TemaApp.verdeBosque,
              ),
              title: const Text('Hospitalizaciones'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const PantallaHospitalizaciones(),
                ),
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(
                Icons.medication_outlined,
                color: TemaApp.verdeBosque,
              ),
              title: const Text('Recetas'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const PantallaRecetas()),
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(
                Icons.meeting_room_outlined,
                color: TemaApp.verdeBosque,
              ),
              title: const Text('Habitaciones'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const PantallaHabitaciones()),
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(
                Icons.notifications_outlined,
                color: TemaApp.verdeBosque,
              ),
              title: const Text('Notificaciones'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const PantallaNotificaciones(),
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
          Card(
            child: ListTile(
              leading: const Icon(Icons.receipt_long_outlined,
                  color: TemaApp.verdeBosque),
              title: const Text('Facturas'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const PantallaFacturas()),
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.local_shipping_outlined,
                  color: TemaApp.verdeBosque),
              title: const Text('Proveedores'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const PantallaProveedores()),
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.shopping_cart_outlined,
                  color: TemaApp.verdeBosque),
              title: const Text('Compras'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const PantallaCompras()),
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

    final inicial =
        (usuario?.username ?? '?').substring(0, 1).toUpperCase();

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
            decoration: BoxDecoration(
              color: TemaApp.verdeBosque,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 44,
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  child: Text(
                    inicial,
                    style: const TextStyle(
                      fontSize: 34,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  usuario?.username ?? '',
                  style: textos.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  usuario?.email ?? '',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.85)),
                ),
                const SizedBox(height: 14),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    (usuario?.rol.name ?? '').toUpperCase(),
                    style: const TextStyle(
                      color: TemaApp.verdeBosque,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.08, end: 0),
          const SizedBox(height: 20),
          Card(
            child: ListTile(
              leading: const Icon(Icons.email_outlined,
                  color: TemaApp.verdeBosque),
              title: const Text('Correo'),
              subtitle: Text(usuario?.email ?? '—'),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.badge_outlined,
                  color: TemaApp.verdeBosque),
              title: const Text('Rol'),
              subtitle: Text(usuario?.rol.name ?? '—'),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(backgroundColor: Colors.red.shade400),
              onPressed:
                  () => ref.read(authNotifierProvider.notifier).cerrarSesion(),
              icon: const Icon(Icons.logout),
              label: const Text('Cerrar sesión'),
            ),
          ),
        ],
      ),
    );
  }
}
