import 'package:flutter/material.dart';

/// ZELDA App Color Palette
/// Based on UI design from E:\stitch_javid_application_ui_design
class AppColors {
  AppColors._();

  // Primary Colors
  static const Color primary = Color(0xFF00E0FF);        // Cyan - Main accent
  static const Color primaryLight = Color(0xFF5CEFFF);    // Light cyan
  static const Color primaryDark = Color(0xFF00B8D9);     // Dark cyan

  // Secondary/Alert Colors
  static const Color secondary = Color(0xFFFF3B3B);       // Red - Emergency/SOS
  static const Color secondaryLight = Color(0xFFFF6B6B); // Light red
  static const Color secondaryDark = Color(0xFFCC2E2E);   // Dark red

  // Background Colors
  static const Color backgroundDark = Color(0xFF0B1120);  // Navy/Dark background
  static const Color backgroundLight = Color(0xFFF8F5F5); // Light background
  static const Color surfaceDark = Color(0xFF1A2332);     // Card/Surface dark
  static const Color surfaceLight = Color(0xFF2A3447);    // Elevated surface

  // Glassmorphism Colors
  static const Color glassWhite = Color(0x1AFFFFFF);       // 10% white
  static const Color glassBorder = Color(0x33FFFFFF);     // 20% white border
  static const Color glassBackground = Color(0x0D1A2D3D); // Glass effect bg

  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);      // White text
  static const Color textSecondary = Color(0xFFB0B8C4);   // Gray text
  static const Color textHint = Color(0xFF6B7280);        // Hint text
  static const Color textOnPrimary = Color(0xFF0B1120);    // Text on cyan

  // Status Colors
  static const Color success = Color(0xFF10B981);         // Green
  static const Color warning = Color(0xFFF59E0B);        // Amber
  static const Color error = Color(0xFFEF4444);           // Red
  static const Color info = Color(0xFF3B82F6);            // Blue

  // Color Aliases for convenience
  static const Color cyan = primary;                      // Alias for primary
  static const Color mapMarkerEmergency = Color(0xFFFF3B3B); // Emergency marker
  static const Color mapMarkerPolice = Color(0xFF10B981); // Police marker
  static const Color mapRoute = Color(0xFF00E0FF);        // Route line

  // Convenience Color Aliases
  static const Color red = secondary;                    // Alias for emergency color
  static const Color orange = warning;                  // Alias for warning
  static const Color green = success;                  // Alias for success
  static const Color navy = backgroundDark;            // Alias for background

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient emergencyGradient = LinearGradient(
    colors: [secondary, secondaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [backgroundDark, Color(0xFF0F1925)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Glass Effect Decoration
  static BoxDecoration get glassDecoration => BoxDecoration(
    color: glassBackground,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: glassBorder, width: 1),
  );

  // Dark Card Decoration
  static BoxDecoration get cardDecoration => BoxDecoration(
    color: surfaceDark,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: glassBorder, width: 0.5),
  );
}
