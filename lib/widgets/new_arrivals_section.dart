import 'package:flutter/material.dart';
import '../config.dart';
import '../data/products.dart';
import '../theme.dart';
import 'common.dart';
import 'product_card.dart';

/// Bagian khusus NEW ARRIVALS (Produk Best Seller & Koleksi Baru 2025) di halaman utama (hook).
/// Dilengkapi CTA di bagian bawah untuk masuk ke halaman All Product yang terpisah.
class NewArrivalsSection extends StatelessWidget {
  const NewArrivalsSection({super.key, required this.onOpenAllProducts});
  final VoidCallback onOpenAllProducts;

  @override
  Widget build(BuildContext context) {
    final m = isMobile(context);
    final items = bestSellerProducts;

    return Container(
      color: C.bg,
      child: Wrap1240(
        vertical: m ? 64 : 104,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionTitle(
              kicker: 'Produk Best Seller · ${Config.catalogYear}',
              title: 'New Arrivals',
              trailing: m
                  ? null
                  : Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        '${items.length} PRODUK UNGGULAN',
                        style: T.label(14.5, color: C.mute),
                      ),
                    ),
            ),
            const SizedBox(height: 16),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: Text(
                'Deretan produk paling diminati (Best Seller) dan rilisan terbaru dari Toyota Gazoo Racing Collection ${Config.catalogYear}. Klik simbol Chat Admin pada kartu produk untuk memesan langsung.',
                style: T.body(m ? 15 : 16.5, color: C.mute),
              ),
            ),
            SizedBox(height: m ? 28 : 44),
            LayoutBuilder(
              builder: (context, constraints) {
                final w = constraints.maxWidth;
                final cols = w >= 1060 ? 4 : (w >= 720 ? 3 : (w >= 340 ? 2 : 1));
                final gap = w < 600 ? 12.0 : 20.0;
                final cardW = (w - gap * (cols - 1)) / cols;
                final cardH = cardW * (w < 600 ? 0.92 : 0.98) + 128;

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: cols,
                    mainAxisSpacing: gap,
                    crossAxisSpacing: gap,
                    mainAxisExtent: cardH,
                  ),
                  itemBuilder: (_, i) => ProductCard(
                    key: ValueKey('best-${items[i].id}'),
                    product: items[i],
                    index: i,
                  ),
                );
              },
            ),
            SizedBox(height: m ? 32 : 48),
            // Panel CTA di bawah New Arrivals untuk masuk ke halaman All Product
            _AllProductsBannerCta(
              totalCount: products.length,
              categoryCount: Category.values.length,
              onTap: onOpenAllProducts,
            ),
          ],
        ),
      ),
    );
  }
}

class _AllProductsBannerCta extends StatefulWidget {
  const _AllProductsBannerCta({
    required this.totalCount,
    required this.categoryCount,
    required this.onTap,
  });

  final int totalCount;
  final int categoryCount;
  final VoidCallback onTap;

  @override
  State<_AllProductsBannerCta> createState() => _AllProductsBannerCtaState();
}

class _AllProductsBannerCtaState extends State<_AllProductsBannerCta> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isStack = constraints.maxWidth < 720;
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _hover = true),
          onExit: (_) => setState(() => _hover = false),
          child: GestureDetector(
            onTap: widget.onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(
                horizontal: isStack ? 20 : 32,
                vertical: isStack ? 24 : 28,
              ),
              decoration: BoxDecoration(
                color: C.surface,
                border: Border.all(
                  color: _hover ? C.red : C.line,
                  width: _hover ? 1.5 : 1,
                ),
              ),
              child: isStack
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _textBlock(true),
                        const SizedBox(height: 20),
                        GrButton(
                          label: 'Lihat Semua Produk (${widget.totalCount})',
                          icon: Icons.arrow_forward_rounded,
                          expand: true,
                          onTap: widget.onTap,
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(child: _textBlock(false)),
                        const SizedBox(width: 24),
                        GrButton(
                          label: 'Lihat Semua Produk (${widget.totalCount})',
                          icon: Icons.arrow_forward_rounded,
                          onTap: widget.onTap,
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget _textBlock(bool compact) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Transform(
              transform: Matrix4.skewX(-0.45),
              child: Container(width: 14, height: 7, color: C.red),
            ),
            const SizedBox(width: 8),
            Text(
              'FULL CATALOG · ${widget.categoryCount} KATEGORI RESMI',
              style: T.label(12, color: C.red, w: FontWeight.w700),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'INGIN MELIHAT KOLEKSI LENGKAP LAINNYA?',
          style: T.display(compact ? 26 : 32, height: 1.02),
        ),
        const SizedBox(height: 6),
        Text(
          'Buka halaman khusus All Product untuk menjelajahi seluruh ${widget.totalCount} item (Polo, T-Shirt, Shirt, Hoodie, Jacket, Cap, Umbrella, dan Gears) lengkap dengan pencarian dan filter kategori.',
          style: T.body(14.5, color: C.mute),
        ),
      ],
    );
  }
}
