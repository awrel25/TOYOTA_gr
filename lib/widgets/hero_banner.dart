import 'package:flutter/material.dart';
import '../data/products.dart';
import '../theme.dart';
import 'common.dart';
import 'site_header.dart';

class HeroBanner extends StatelessWidget {
  const HeroBanner({
    super.key,
    required this.onProduct,
    required this.onNewArrivals,
    required this.onOutlets,
    required this.onAbout,
    this.onTop,
  });

  final VoidCallback onProduct;
  final VoidCallback onNewArrivals;
  final VoidCallback onOutlets;
  final VoidCallback onAbout;
  final VoidCallback? onTop;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final m = w < 768;
        final compact = w < 480;
        final heroHeight = compact ? 680.0 : (m ? 740.0 : 840.0);
        final headlineSize = compact ? 54.0 : (m ? 72.0 : (w < 1100 ? 104.0 : 128.0));

        return SizedBox(
          height: heroHeight,
          child: Stack(
            children: [
              // Foto utama katalog sebagai background penuh.
              Positioned.fill(
                child: Image.asset(
                  'assets/images/hero-cover.webp',
                  fit: BoxFit.cover,
                  alignment: m ? const Alignment(0.35, 0) : const Alignment(0.15, -0.1),
                  errorBuilder: (_, __, ___) => const ColoredBox(color: C.surface),
                ),
              ),
              // Gradasi halus agar navbar dan tipografi menyatu langsung di atas background.
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        C.bg.withAlpha(210),
                        C.bg.withAlpha(90),
                        C.bg.withAlpha(235),
                      ],
                      stops: const [0.0, 0.35, 0.95],
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        C.bg.withAlpha(240),
                        C.bg.withAlpha(165),
                        C.bg.withAlpha(20),
                      ],
                      stops: const [0.0, 0.52, 0.92],
                    ),
                  ),
                ),
              ),
              if (!m)
                const Positioned(
                  right: 0,
                  bottom: 64,
                  child: Slashes(width: 310, height: 155),
                ),
              // Navbar langsung menyatu pada background website tanpa garis panjang.
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SiteHeader(
                  onProduct: onProduct,
                  onNewArrivals: onNewArrivals,
                  onOutlets: onOutlets,
                  onAbout: onAbout,
                  onTop: onTop,
                ),
              ),
              // Konten utama Hero
              Positioned.fill(
                child: Wrap1240(
                  child: Align(
                    alignment: m ? Alignment.bottomLeft : Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: m ? 88 : 96,
                        bottom: m ? 96 : 64,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Reveal(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Transform(
                                  transform: Matrix4.skewX(-0.45),
                                  child: Container(width: 18, height: 9, color: C.red),
                                ),
                                const SizedBox(width: 10),
                                Flexible(
                                  child: Text(
                                    'OFFICIAL APPAREL & MERCHANDISE CATALOG 2026',
                                    style: T.label(compact ? 11.5 : 14, color: C.red, w: FontWeight.w700),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Reveal(
                            delay: const Duration(milliseconds: 110),
                            child: Text.rich(
                              TextSpan(
                                style: T.display(headlineSize),
                                children: [
                                  const TextSpan(text: 'GAYA\n'),
                                  TextSpan(
                                    text: 'BERKELAS,\n',
                                    style: T.display(headlineSize, color: C.red),
                                  ),
                                  const TextSpan(text: 'MELAJU TANPA BATAS.'),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 22),
                          Reveal(
                            delay: const Duration(milliseconds: 220),
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 490),
                              child: Text(
                                'Koleksi resmi Toyota Gazoo Racing 2026. Pilih polo, t-shirt, jaket, hingga gears favorit Anda dan pesan instan melalui tombol Chat Admin pada setiap produk.',
                                style: T.body(compact ? 14.5 : (m ? 15.5 : 17.5), color: C.text.withAlpha(220)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 28),
                          Reveal(
                            delay: const Duration(milliseconds: 320),
                            child: Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: [
                                GrButton(
                                  label: 'Explore Product',
                                  icon: Icons.arrow_downward_rounded,
                                  onTap: onProduct,
                                ),
                                GrButton(
                                  label: 'New Arrivals',
                                  outline: true,
                                  onTap: onNewArrivals,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(left: 0, right: 0, bottom: 0, child: _StatStrip()),
            ],
          ),
        );
      },
    );
  }
}

class _StatStrip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = <String>[
      '${products.length} Official Products',
      '${bestSellerProducts.length} Best Seller & New Arrivals',
      '${outlets.length} Lokasi Outlet GR Places',
      'Direct Chat Admin Order',
    ];
    return Container(
      color: C.red,
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: isMobile(context) ? 16 : 40),
        itemCount: items.length,
        separatorBuilder: (_, __) => Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Transform(
              transform: Matrix4.skewX(-0.45),
              child: Container(width: 5, height: 16, color: Colors.white.withAlpha(150)),
            ),
          ),
        ),
        itemBuilder: (_, i) => Center(
          child: Text(
            items[i].toUpperCase(),
            style: T.label(14.5, color: Colors.white, w: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}
