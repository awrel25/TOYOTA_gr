import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Palet warna terkalibrasi: Carbon Asphalt, Pit Surface, Bone White, dan Gazoo Racing Red.
class C {
  C._();
  static const bg = Color(0xFF0A0A0B);
  static const surface = Color(0xFF131315);
  static const surface2 = Color(0xFF1B1B1E);
  static const line = Color(0xFF2B2B30);
  static const text = Color(0xFFF3F3F0);
  static const mute = Color(0xFF9B9BA2);
  static const red = Color(0xFFEB0A1E);
  static const redDark = Color(0xFFB30817);
}

class T {
  T._();

  /// Judul besar: condensed, italic, tebal — karakter khas motorsport Gazoo Racing.
  static TextStyle display(double size, {Color color = C.text, double height = 0.94}) =>
      GoogleFonts.barlowCondensed(
        fontSize: size,
        fontWeight: FontWeight.w800,
        fontStyle: FontStyle.italic,
        color: color,
        height: height,
        letterSpacing: size * 0.005,
      );

  /// Label kecil huruf kapital dengan tracking presisi.
  static TextStyle label(double size, {Color color = C.mute, FontWeight w = FontWeight.w600}) =>
      GoogleFonts.barlowCondensed(
        fontSize: size,
        fontWeight: w,
        color: color,
        letterSpacing: size * 0.14,
        height: 1.15,
      );

  /// Teks isi yang bersih dan nyaman dibaca di semua ukuran layar.
  static TextStyle body(double size,
          {Color color = C.text, FontWeight w = FontWeight.w400, double height = 1.55}) =>
      GoogleFonts.barlow(fontSize: size, fontWeight: w, color: color, height: height);

  /// Teks monospace untuk kode OEM Part Number dan tabel ukuran.
  static TextStyle mono(double size,
          {Color color = C.text, FontWeight w = FontWeight.w500, double height = 1.4}) =>
      GoogleFonts.ibmPlexMono(fontSize: size, fontWeight: w, color: color, height: height);
}

ThemeData buildTheme() {
  final base = ThemeData.dark(useMaterial3: true);
  return base.copyWith(
    scaffoldBackgroundColor: C.bg,
    colorScheme: const ColorScheme.dark(
      primary: C.red,
      onPrimary: Colors.white,
      surface: C.surface,
      onSurface: C.text,
    ),
    textTheme: GoogleFonts.barlowTextTheme(base.textTheme).apply(
      bodyColor: C.text,
      displayColor: C.text,
    ),
    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.transparent,
    hoverColor: Colors.transparent,
    snackBarTheme: SnackBarThemeData(
      backgroundColor: C.surface2,
      contentTextStyle: T.body(14),
      behavior: SnackBarBehavior.floating,
      shape: const RoundedRectangleBorder(),
    ),
  );
}

/// Kontainer responsif dengan batas lebar maksimum dan padding adaptif sesuai lebar layar.
class Wrap1240 extends StatelessWidget {
  const Wrap1240({super.key, required this.child, this.vertical = 0});
  final Widget child;
  final double vertical;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final pad = w < 480 ? 16.0 : (w < 768 ? 24.0 : (w < 1200 ? 36.0 : 48.0));
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1336),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: pad, vertical: vertical),
          child: child,
        ),
      ),
    );
  }
}

bool isMobile(BuildContext c) => MediaQuery.sizeOf(c).width < 768;
bool isCompact(BuildContext c) => MediaQuery.sizeOf(c).width < 480;
