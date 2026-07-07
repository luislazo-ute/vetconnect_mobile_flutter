import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../data/cliente_autenticado.dart';
import 'auth_providers.dart';
import 'http_provider.dart';

/// Cliente HTTP autenticado (Bearer + refresh en 401).
/// Lo usarán TODOS los repositorios privados (mascotas, citas, etc.).
final clienteAutenticadoProvider = Provider<http.Client>((ref) {
  final inner = ref.watch(httpClientProvider);           // cliente base
  final almacenamiento = ref.watch(almacenamientoTokensProvider);
  final refrescar = ref.watch(refrescarTokenUcProvider);
  // COMPLETAR: arma el ClienteAutenticado con esos 3.
  // Pista: return ClienteAutenticado(inner, almacenamiento, refrescar);
  return ClienteAutenticado(inner, almacenamiento, refrescar);
});
