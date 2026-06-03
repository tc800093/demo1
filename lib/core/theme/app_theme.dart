import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF0D47A1), // Deep Premium Blue
        secondary: Color(0xFF00B0FF), // Vibrant Light Blue
        surface: Colors.white,
        surfaceContainerHighest: Color(0xFFF0F4F8), // Soft premium background
        onSurface: Color(0xFF102A43), // Very Dark Blue Text
        outline: Color(0xFFD9E2EC),
      ),
      scaffoldBackgroundColor: const Color(0xFFF0F4F8),
      textTheme: GoogleFonts.outfitTextTheme().copyWith(
        displayLarge: GoogleFonts.outfit(
          color: const Color(0xFF102A43),
          fontWeight: FontWeight.w800,
        ),
        titleLarge: GoogleFonts.outfit(
          color: const Color(0xFF102A43),
          fontWeight: FontWeight.w700,
        ),
        bodyLarge: GoogleFonts.outfit(
          color: const Color(0xFF243B53),
          fontSize: 16,
        ),
        bodyMedium: GoogleFonts.outfit(
          color: const Color(0xFF486581),
          fontSize: 14,
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 8,
        shadowColor: const Color(0xFF0D47A1).withOpacity(0.15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24), // Extra rounded
          side: const BorderSide(
            color: Colors.white,
            width: 1,
          ), // Invisible border for clean look
        ),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0D47A1),
          foregroundColor: Colors.white,
          elevation: 6,
          shadowColor: const Color(0xFF0D47A1).withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 32),
          textStyle: GoogleFonts.outfit(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            letterSpacing: 1.2,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 24,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none, // Removed border for floating look
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF00B0FF), width: 2),
        ),
        labelStyle: GoogleFonts.outfit(color: const Color(0xFF829AB1)),
      ),
    );
  }
}
