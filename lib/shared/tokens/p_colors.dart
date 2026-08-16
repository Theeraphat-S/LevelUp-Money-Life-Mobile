import 'package:flutter/material.dart';

class PColor {
  // Light Surface Tokens
  static const Color lightBase = Color(0xFFF5F8F4); // Mist Green
  static const Color lightSurface = Color(0xFFFEFFFC); // Pure Crisp
  static const Color lightSurfaceSubtle = Color(0xFFEAF1EB); // Mist Subtle
  static const Color lightLine = Color(0xFFD9E5DD); // Light Sage
  static const Color lightLineSubtle = Color(0xFFE5EFE8); // Subtle Sub-divider
  static const Color lightInk = Color(0xFF142D2B); // Deep Ink
  static const Color lightInkSoft = Color(0xFF49605C); // Slate Forest
  static const Color lightInkFaint = Color(0xFF6B827E); // Muted Forest

  // Dark Surface Tokens (Obsidian Ink Green)
  static const Color darkBase = Color(0xFF071B1A); // Ink Green
  static const Color darkSurface = Color(0xFF0D2927); // Ink Forest
  static const Color darkSurfaceSubtle = Color(0xFF143532); // Forest Subtle
  static const Color darkLine = Color(0xFF294943); // Defined Forest
  static const Color darkLineSubtle = Color(0xFF1D3D3A); // Forest Sub-divider
  static const Color darkInk = Color(0xFFEDF7F1); // Crisp Sage
  static const Color darkInkSoft = Color(0xFFC2D3CB); // Muted Sage
  static const Color darkInkFaint = Color(0xFF8FA79D); // Faint Sage

  // Semantic Accents (Light)
  static const Color primaryLight = Color(0xFF1C5954); // Deep Teal
  static const Color primarySoftLight = Color(0x1A1C5954);
  static const Color primaryInkLight = Color(0xFF1C5954);
  static const Color primaryContrastLight = Color(0xFFFEFFFC);

  static const Color jadeLight = Color(0xFF4D8E75); // Soft Jade
  static const Color jadeSoftLight = Color(0x1F4D8E75);
  static const Color jadeInkLight = Color(0xFF285444);

  static const Color amberLight = Color(0xFFC99A4B); // Muted Amber
  static const Color amberSoftLight = Color(0x1FC99A4B);
  static const Color amberInkLight = Color(0xFF8A601B);

  static const Color roseLight = Color(0xFFB96D69); // Clay Rose
  static const Color roseSoftLight = Color(0x1FB96D69);
  static const Color roseInkLight = Color(0xFF873632);

  static const Color mossLight = Color(0xFF879B62); // Moss
  static const Color mossSoftLight = Color(0x1F879B62);
  static const Color mossInkLight = Color(0xFF4E5E32);

  static const Color amountIconRoseLight = Color(0xFFA03C38);
  static const Color amountIconJadeLight = Color(0xFF2D7A5A);

  // Semantic Accents (Dark)
  static const Color primaryDark = Color(0xFF76AA9D); // Soft Sage Teal
  static const Color primarySoftDark = Color(0x2976AA9D);
  static const Color primaryInkDark = Color(0xFF76AA9D);
  static const Color primaryContrastDark = Color(0xFF071B1A);

  static const Color jadeDark = Color(0xFF8BB999); // Light Jade
  static const Color jadeSoftDark = Color(0x298BB999);
  static const Color jadeInkDark = Color(0xFF8BB999);

  static const Color amberDark = Color(0xFFD7AE68); // Warm Gold Amber
  static const Color amberSoftDark = Color(0x29D7AE68);
  static const Color amberInkDark = Color(0xFFD7AE68);

  static const Color roseDark = Color(0xFFD58A83); // Soft Terracotta Rose
  static const Color roseSoftDark = Color(0x29D58A83);
  static const Color roseInkDark = Color(0xFFD58A83);

  static const Color mossDark = Color(0xFFA7B67B); // Sage Moss
  static const Color mossSoftDark = Color(0x29A7B67B);
  static const Color mossInkDark = Color(0xFFA7B67B);

  static const Color amountIconRoseDark = Color(0xFFF0A49E);
  static const Color amountIconJadeDark = Color(0xFF7DD6A8);

  // Category Color Map
  static const Color catIncome = Color(0xFF4D8E75);
  static const Color catFood = Color(0xFFC99A4B);
  static const Color catTransport = Color(0xFF1C5954);
  static const Color catHome = Color(0xFF879B62);
  static const Color catHealth = Color(0xFF879B62);
  static const Color catLearning = Color(0xFF1C5954);
  static const Color catFun = Color(0xFFC99A4B);
  static const Color catDebt = Color(0xFFB96D69);
  static const Color catSavings = Color(0xFF4D8E75);

  // Budget Bucket Colors
  static const Color bucketNeeds = Color(0xFF1C5954);
  static const Color bucketWants = Color(0xFF879B62);
  static const Color bucketSavings = Color(0xFF4D8E75);

  // Dynamic Theme Resolvers
  static Color base(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkBase : lightBase;

  static Color surface(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? darkSurface
          : lightSurface;

  static Color surfaceSubtle(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? darkSurfaceSubtle
          : lightSurfaceSubtle;

  static Color line(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkLine : lightLine;

  static Color lineSubtle(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? darkLineSubtle
          : lightLineSubtle;

  static Color ink(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkInk : lightInk;

  static Color inkSoft(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? darkInkSoft
          : lightInkSoft;

  static Color inkFaint(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? darkInkFaint
          : lightInkFaint;

  static Color primary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? primaryDark
          : primaryLight;

  static Color primarySoft(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? primarySoftDark
          : primarySoftLight;

  static Color primaryInk(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? primaryInkDark
          : primaryInkLight;

  static Color primaryContrast(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? primaryContrastDark
          : primaryContrastLight;

  static Color jade(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? jadeDark : jadeLight;

  static Color jadeSoft(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? jadeSoftDark
          : jadeSoftLight;

  static Color jadeInk(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? jadeInkDark
          : jadeInkLight;

  static Color amber(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? amberDark : amberLight;

  static Color amberSoft(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? amberSoftDark
          : amberSoftLight;

  static Color amberInk(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? amberInkDark
          : amberInkLight;

  static Color rose(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? roseDark : roseLight;

  static Color roseSoft(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? roseSoftDark
          : roseSoftLight;

  static Color roseInk(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? roseInkDark
          : roseInkLight;

  static Color moss(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? mossDark : mossLight;

  static Color mossSoft(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? mossSoftDark
          : mossSoftLight;

  static Color mossInk(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? mossInkDark
          : mossInkLight;

  static Color amountIconRose(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? amountIconRoseDark
          : amountIconRoseLight;

  static Color amountIconJade(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? amountIconJadeDark
          : amountIconJadeLight;

  // Legacy fallback aliases for compatibility
  static Color primaryColor = primaryLight;
  static const Color secondaryColor = jadeLight;
  static Color backgroundColor = lightBase;
  static Color neutralColor = lightSurface;
  static const Color textNeutralColor = lightInkSoft;
  static Color contentColor = lightInk;
  static Color errorColor = roseLight;

  static void updatePrimaryColor(Color color) {
    primaryColor = color;
  }
}

