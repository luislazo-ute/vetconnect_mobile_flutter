import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

/// Provider del cliente HTTP.
/// Riverpod lo crea UNA vez y lo reutiliza en toda la app (como un singleton).
final httpClientProvider = Provider<http.Client>((ref) {
  final cliente = http.Client();

  ref.onDispose(cliente.close);

  return cliente;
});
