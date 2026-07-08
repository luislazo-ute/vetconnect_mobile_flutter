import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TemaApp {
  static const Color verdeBosque = Color(0xFF1E5B3E);
  static const Color verdeMedio = Color(0xFF4C8C6A);
  static const Color fondo = Color(0xFFFCFFFB);
  static const Color texto = Color(0xFF161616);

  static ThemeData get tema {
    final esquema = ColorScheme.fromSeed(seedColor: verdeBosque);

    return ThemeData(
      useMaterial3: true,
      colorScheme: esquema.copyWith(
        primary: verdeBosque,
        secondary: verdeMedio,
      ),
      scaffoldBackgroundColor: fondo,
      textTheme: GoogleFonts.outfitTextTheme(),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(shape: const StadiumBorder()),
      ),
    );
  }
}
