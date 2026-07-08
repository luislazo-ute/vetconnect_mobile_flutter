import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/mongo_repository_impl.dart';
import '../../domain/entities/documento_mongo.dart';
import '../../domain/repositories/i_mongo_repository.dart';
import 'cliente_autenticado_provider.dart';

final mongoRepositoryProvider = Provider<IMongoRepository>((ref) {
  return MongoRepositoryImpl(ref.watch(clienteAutenticadoProvider));
});

final documentosMongoProvider =
    FutureProvider.family<List<DocumentoMongo>, String>((ref, coleccion) {
      return ref.watch(mongoRepositoryProvider).obtener(coleccion);
    });
