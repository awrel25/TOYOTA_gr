import 'package:flutter/material.dart';
import '../config.dart';
import '../data/products.dart';
import '../theme.dart';
import 'common.dart';
import 'product_card.dart';
import 'site_footer.dart';
import 'site_header.dart';

/// Halaman terpisah untuk menampilkan seluruh produk (All Product Page)
/// agar halaman utama (Beranda) tetap ringkas dan tidak perlu scroll terlalu panjang.
class AllProductsPage extends StatefulWidget {
  const AllProductsPage({
    super.key,
    required this.onBackToHome,
    required this.onNavigateSection,
  });

  final VoidCallback onBackToHome;
  final ValueChanged<String> onNavigateSection;

  @override
  State<AllProductsPage> createState() => _AllProductsPageState();
}

class _AllProductsPageState extends State<AllProductsPage> {
  final _scroll = ScrollController();
  Category? _cat;
  bool _onlyBestSeller = false;
  String _q = '';

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  List<Product> get _filtered {
    final q = _q.trim().toLowerCase();
    return products.where((p) {
      if (_onlyBestSeller && !p.isBestSeller) return false;
      if (_cat != null && p.category != _cat) return false;
      if (q.isEmpty) return true;
      return p.name.toLowerCase().contains(q) ||
          p.category.label.toLowerCase().contains(q) ||
          p.primaryPartPreview.toLowerCase().contains(q) ||
          p.colors.any((c) => c.toLowerCase().contains(q));
    }).toList();
  }

  void _top() => _scroll.animateTo(
        0,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutCubic,
      );

  @override
  Widget build(BuildContext context) {
    final m = isMobile(context);
    final list = _filtered;

    return Scaffold(
      backgroundColor: C.bg,
      body: SingleChildScrollView(
        controller: _scroll,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header tanpa garis panjang navbar, menyatu langsung di atas background halaman All Product
            SiteHeader(
              onProduct: _top,
              onNewArrivals: () => widget.onNavigateSection('new-arrivals'),
              onOutlets: () => widget.onNavigateSection('outlets'),
              onAbout: () => widget.onNavigateSection('about'),
              onTop: widget.onBackToHome,
            ),
            Wrap1240(
              vertical: m ? 28 : 48,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tombol kembali ke Beranda
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: widget.onBackToHome,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                        decoration: BoxDecoration(
                          color: C.surface,
                          border: Border.all(color: C.line),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.arrow_back_rounded, size: 16, color: C.red),
                            const SizedBox(width: 8),
                            Text(
                              'KEMBALI KE BERANDA',
                              style: T.label(12.5, color: C.text, w: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  SectionTitle(
                    kicker: 'Katalog Lengkap · ${Config.catalogYear}',
                    title: 'All Product',
                    trailing: m
                        ? null
                        : Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text(
                              'MENAMPILKAN ${list.length} DARI ${products.length} PRODUK',
                              style: T.label(14, color: C.mute),
                            ),
                          ),
                  ),
                  const SizedBox(height: 14),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 640),
                    child: Text(
                      'Jelajahi seluruh ${products.length} koleksi resmi Toyota Gazoo Racing ${Config.catalogYear}. Gunakan pencarian atau pilih kategori di bawah, lalu tekan simbol Chat Admin pada kartu produk untuk memesan.',
                      style: T.body(m ? 15 : 16.5, color: C.mute),
                    ),
                  ),
                  const SizedBox(height: 28),
                  // Bar pencarian & filter Best Seller
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      _SearchField(
                        value: _q,
                        onChanged: (v) => setState(() => _q = v),
                      ),
                      _BestSellerToggle(
                        active: _onlyBestSeller,
                        onTap: () => setState(() => _onlyBestSeller = !_onlyBestSeller),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  // Filter kategori horizontal
                  SizedBox(
                    height: 44,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _CatChip(
                          label: 'Semua Kategori',
                          count: products.length,
                          selected: _cat == null,
                          onTap: () => setState(() => _cat = null),
                        ),
                        for (final c in Category.values)
                          _CatChip(
                            label: c.label,
                            count: products.where((p) => p.category == c).length,
                            selected: _cat == c,
                            onTap: () => setState(() => _cat = c),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  if (list.isEmpty)
                    _Empty(
                      query: _q,
                      onReset: () => setState(() {
                        _q = '';
                        _cat = null;
                        _onlyBestSeller = false;
                      }),
                    )
                  else
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
                          itemCount: list.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: cols,
                            mainAxisSpacing: gap,
                            crossAxisSpacing: gap,
                            mainAxisExtent: cardH,
                          ),
                          itemBuilder: (_, i) => ProductCard(
                            key: ValueKey('all-${_cat?.name}-$_onlyBestSeller-$_q-${list[i].id}'),
                            product: list[i],
                            index: i,
                          ),
                        );
                      },
                    ),
                  const SizedBox(height: 48),
                ],
              ),
            ),
            SiteFooter(
              onTop: _top,
              onProduct: _top,
              onNewArrivals: () => widget.onNavigateSection('new-arrivals'),
              onOutlets: () => widget.onNavigateSection('outlets'),
              onAbout: () => widget.onNavigateSection('about'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.value, required this.onChanged});
  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 520),
      child: TextField(
        onChanged: onChanged,
        style: T.body(15.5),
        cursorColor: C.red,
        decoration: InputDecoration(
          hintText: 'Cari nama produk, kategori, warna, atau Part Number...',
          hintStyle: T.body(14.5, color: C.mute),
          prefixIcon: const Icon(Icons.search, color: C.mute),
          filled: true,
          fillColor: C.surface,
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(color: C.line),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(color: C.red, width: 1.5),
          ),
        ),
      ),
    );
  }
}

class _BestSellerToggle extends StatelessWidget {
  const _BestSellerToggle({required this.active, required this.onTap});
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            color: active ? C.red : C.surface,
            border: Border.all(color: active ? C.red : C.line),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.local_fire_department_outlined,
                size: 18,
                color: active ? Colors.white : C.red,
              ),
              const SizedBox(width: 8),
              Text(
                'BEST SELLER ONLY',
                style: T.label(13.5, color: active ? Colors.white : C.text, w: FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CatChip extends StatefulWidget {
  const _CatChip({
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_CatChip> createState() => _CatChipState();
}

class _CatChipState extends State<_CatChip> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final sel = widget.selected;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            padding: const EdgeInsets.symmetric(horizontal: 18),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: sel ? C.red : Colors.transparent,
              border: Border.all(color: sel ? C.red : (_hover ? C.text : C.line)),
            ),
            child: Row(
              children: [
                Text(
                  widget.label.toUpperCase(),
                  style: T.label(14.5, color: sel ? Colors.white : C.text, w: FontWeight.w700),
                ),
                const SizedBox(width: 8),
                Text(
                  '${widget.count}',
                  style: T.label(12.5, color: sel ? Colors.white.withAlpha(190) : C.mute),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty({required this.query, required this.onReset});
  final String query;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 72, horizontal: 24),
      decoration: BoxDecoration(border: Border.all(color: C.line)),
      child: Column(
        children: [
          Text('TIDAK ADA HASIL', style: T.display(40)),
          const SizedBox(height: 10),
          Text(
            query.isEmpty
                ? 'Belum ada produk di filter ini.'
                : 'Tidak ada produk untuk "$query".',
            style: T.body(16, color: C.mute),
          ),
          const SizedBox(height: 24),
          GrButton(label: 'Reset filter', outline: true, onTap: onReset),
        ],
      ),
    );
  }
}
