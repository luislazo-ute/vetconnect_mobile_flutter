import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/rol.dart';
import '../notifiers/auth_notifier.dart';

/// El rol del usuario actual (null si no hay sesión).
/// Fuente ÚNICA de verdad para mostrar/ocultar acciones por rol.
final rolActualProvider = Provider<Rol?>((ref) {
  // COMPLETAR: devuelve el rol del usuario logueado.
  // Pista: ref.watch(authNotifierProvider).usuario?.rol
  return ref.watch(authNotifierProvider).usuario?.rol;
});
