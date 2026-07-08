import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../data/cliente_autenticado.dart';
import 'auth_providers.dart';
import 'http_provider.dart';

final clienteAutenticadoProvider = Provider<http.Client>((ref) {
  final inner = ref.watch(httpClientProvider);
  final almacenamiento = ref.watch(almacenamientoTokensProvider);
  final refrescar = ref.watch(refrescarTokenUcProvider);
  return ClienteAutenticado(inner, almacenamiento, refrescar);
});
