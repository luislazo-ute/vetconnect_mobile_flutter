import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/galeria_repository_impl.dart';
import '../../domain/entities/galeria_foto.dart';
import '../../domain/repositories/i_galeria_repository.dart';
import '../../domain/usecases/crear_foto_uc.dart';
import '../../domain/usecases/obtener_galeria_uc.dart';
import 'cliente_autenticado_provider.dart';

final galeriaRepositoryProvider = Provider<IGaleriaRepository>((ref) {
  return GaleriaRepositoryImpl(ref.watch(clienteAutenticadoProvider));
});

final obtenerGaleriaUcProvider = Provider(
  (ref) => ObtenerGaleriaUc(ref.watch(galeriaRepositoryProvider)),
);
final crearFotoUcProvider = Provider(
  (ref) => CrearFotoUc(ref.watch(galeriaRepositoryProvider)),
);

final galeriaProvider = FutureProvider<List<GaleriaFoto>>((ref) {
  return ref.watch(obtenerGaleriaUcProvider)();
});
