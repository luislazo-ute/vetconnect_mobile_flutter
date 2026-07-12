import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/rol.dart';
import '../notifiers/auth_notifier.dart';

final rolActualProvider = Provider<Rol?>((ref) {
  return ref.watch(authNotifierProvider).usuario?.rol;
});

// Actos médicos (vacunas, recetas, hospitalizaciones): admin y doctor escriben.
final puedeGestionarClinicaProvider = Provider<bool>((ref) {
  final rol = ref.watch(rolActualProvider);
  return rol == Rol.admin || rol == Rol.doctor;
});
