import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Sistema de diseño centralizado de VetConnect.
class TemaApp {
  // --- Colores del profe (constantes) ---
  static const Color verdeBosque = Color(0xFF1E5B3E);
  static const Color verdeMedio  = Color(0xFF4C8C6A);
  static const Color fondo       = Color(0xFFFCFFFB);
  static const Color texto       = Color(0xFF161616);

  /// Devuelve el tema claro de la app.
  static ThemeData get tema {
    // 1) Genera la paleta a partir de la semilla verde bosque.
    final esquema = ColorScheme.fromSeed(seedColor: verdeBosque);

    // 2) Construye y devuelve el ThemeData.
    return ThemeData(
      useMaterial3: true,
      colorScheme: esquema.copyWith(
        primary:  verdeBosque,
        secondary: verdeMedio,
      ),
      scaffoldBackgroundColor: fondo,
      textTheme: GoogleFonts.outfitTextTheme(),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: const StadiumBorder(),
        ),
      ),
    );
  }
}


