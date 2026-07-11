import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/factura_repository_impl.dart';
import '../../domain/entities/factura.dart';
import '../../domain/repositories/i_factura_repository.dart';
import '../../domain/usecases/crear_factura_uc.dart';
import '../../domain/usecases/eliminar_factura_uc.dart';
import '../../domain/usecases/obtener_factura_uc.dart';
import '../../domain/usecases/obtener_facturas_uc.dart';
import '../../domain/usecases/registrar_pago_uc.dart';
import 'cliente_autenticado_provider.dart';

final facturaRepositoryProvider = Provider<IFacturaRepository>((ref) {
  return FacturaRepositoryImpl(ref.watch(clienteAutenticadoProvider));
});

final obtenerFacturasUcProvider = Provider<ObtenerFacturasUc>((ref) {
  return ObtenerFacturasUc(ref.watch(facturaRepositoryProvider));
});

final obtenerFacturaUcProvider = Provider<ObtenerFacturaUc>((ref) {
  return ObtenerFacturaUc(ref.watch(facturaRepositoryProvider));
});

final crearFacturaUcProvider = Provider<CrearFacturaUc>((ref) {
  return CrearFacturaUc(ref.watch(facturaRepositoryProvider));
});

final registrarPagoUcProvider = Provider<RegistrarPagoUc>((ref) {
  return RegistrarPagoUc(ref.watch(facturaRepositoryProvider));
});

final eliminarFacturaUcProvider = Provider<EliminarFacturaUc>((ref) {
  return EliminarFacturaUc(ref.watch(facturaRepositoryProvider));
});

final facturaDetalleProvider = FutureProvider.family<Factura, int>((ref, id) {
  return ref.watch(obtenerFacturaUcProvider)(id);
});
