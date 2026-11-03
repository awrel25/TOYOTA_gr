import 'package:flutter/material.dart';
import '../config.dart';
import '../data/products.dart';
import '../services/whatsapp.dart';
import '../theme.dart';
import 'common.dart';

/// Bagian ABOUT (menggantikan bagian Cara Pesan) dengan tipografi dan palet warna yang serasi.
class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  static const _pillars = <(String, String, String)>[
    (
      '01',
      'Motorsport DNA & Identity',
      'Setiap potong apparel dan gears membawa identitas balap autentik Toyota Gazoo Racing—dirancang dengan siluet presisi, aksen garis tegas, dan karakter sporty untuk gaya harian Anda.',
    ),
    (
      '02',
      'Engineered Comfort & Material',
      'Menggunakan material pilihan seperti Dry Fit Polyester dengan teknologi HD Printing, Cotton Combed 16S berkualitas tinggi, hingga Stainless Steel pada lini resmi GR Gears.',
    ),
    (
      '03',
      'Official OEM Part Number',
      'Seluruh koleksi memiliki kode suku cadang (Part Number) resmi Toyota Gazoo Racing Collection 2026 yang terjamin keasliannya di 29 jaringan outlet GR Places di Indonesia.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: C.surface,
      child: Wrap1240(
        vertical: isMobile(context) ? 64 : 110,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            final isWide = w >= 880;
            final m = w < 768;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionTitle(
                  kicker: 'Toyota Gazoo Racing Collection',
                  title: 'About',
                ),
                SizedBox(height: m ? 32 : 52),
                if (isWide)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 6, child: _VisualShowcase(isMobile: m)),
                      const SizedBox(width: 48),
                      Expanded(flex: 6, child: _NarrativeColumn(isMobile: m)),
                    ],
                  )
                else ...[
                  _VisualShowcase(isMobile: m),
                  const SizedBox(height: 36),
                  _NarrativeColumn(isMobile: m),
                ],
                SizedBox(height: m ? 40 : 64),
                _PillarsGrid(maxWidth: w),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _VisualShowcase extends StatelessWidget {
  const _VisualShowcase({required this.isMobile});
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: C.bg,
        border: Border.all(color: C.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 16 / 10,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/images/hero-lineup.webp',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const ColoredBox(color: C.surface2),
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          C.bg.withAlpha(210),
                        ],
                        stops: const [0.45, 1.0],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 20,
                  bottom: 18,
                  right: 20,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'OFFICIAL LOOKBOOK ${Config.catalogYear}',
                              style: T.label(11.5, color: C.red, w: FontWeight.w700),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'IGNITING THE SPIRIT OF AUTOMOTIVE ENTHUSIASTS',
                              style: T.display(isMobile ? 22 : 26, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: const BoxDecoration(
              color: C.bg,
              border: Border(top: BorderSide(color: C.line)),
            ),
            child: Wrap(
              spacing: 24,
              runSpacing: 12,
              alignment: WrapAlignment.spaceBetween,
              children: [
                _MiniStat('KOLEKSI RESMI', '${products.length} ITEM'),
                _MiniStat('KATEGORI LINI', '${Category.values.length} LINI'),
                _MiniStat('JARINGAN RESMI', '${outlets.length} GR PLACES'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: T.label(10.5, color: C.mute)),
        const SizedBox(height: 2),
        Text(value, style: T.display(20, color: C.text)),
      ],
    );
  }
}

class _NarrativeColumn extends StatelessWidget {
  const _NarrativeColumn({required this.isMobile});
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'DRIVEN BY PASSION,\nCRAFTED FOR EVERYDAY LIFE.',
          style: T.display(isMobile ? 32 : 42, height: 0.98),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.only(left: 18),
          decoration: const BoxDecoration(
            border: Border(left: BorderSide(color: C.red, width: 3)),
          ),
          child: Text(
            '"Driven by a shared ardor for adrenaline, GR Merchandise ignites the spirit of the automotive enthusiast. This meticulously crafted collection offers a diverse lineup, seamlessly integrating your passion into everyday life."',
            style: T.body(isMobile ? 15 : 16, color: C.text.withAlpha(235), height: 1.55),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Mulai dari perlengkapan esensial yang fungsional hingga lini pakaian bergaya sporty, setiap item berkualitas tinggi dalam katalog ${Config.storeName} ${Config.catalogYear} dirancang untuk menginspirasi dan mengangkat semangat balap Anda setiap hari.',
          style: T.body(15.5, color: C.mute, height: 1.6),
        ),
        const SizedBox(height: 16),
        Text(
          'Untuk kemudahan pemesanan tanpa formulir yang rumit, cukup tekan simbol Chat Admin pada produk pilihan Anda untuk terhubung langsung dengan admin resmi kami melalui WhatsApp.',
          style: T.body(15.5, color: C.mute, height: 1.6),
        ),
        const SizedBox(height: 28),
        GrButton(
          label: 'Hubungi Admin via WhatsApp',
          icon: Icons.chat_bubble_outline_rounded,
          onTap: () => openWhatsApp(),
        ),
      ],
    );
  }
}

class _PillarsGrid extends StatelessWidget {
  const _PillarsGrid({required this.maxWidth});
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final cols = maxWidth >= 900 ? 3 : 1;
    const gap = 20.0;
    final itemWidth = cols == 1 ? maxWidth : (maxWidth - gap * (cols - 1)) / cols;

    return Wrap(
      spacing: gap,
      runSpacing: gap,
      children: [
        for (final p in AboutSection._pillars)
          SizedBox(
            width: itemWidth,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: C.bg,
                border: Border.all(color: C.line),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(p.$1, style: T.display(36, color: C.red)),
                      const Spacer(),
                      Transform(
                        transform: Matrix4.skewX(-0.45),
                        child: Container(width: 14, height: 7, color: C.red),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(p.$2.toUpperCase(), style: T.display(22, height: 1.08)),
                  const SizedBox(height: 10),
                  Text(p.$3, style: T.body(14.5, color: C.mute, height: 1.55)),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
