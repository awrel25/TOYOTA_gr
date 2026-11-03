import 'package:flutter/material.dart';
import '../data/products.dart';
import '../format.dart';
import '../services/whatsapp.dart';
import '../theme.dart';
import 'common.dart';
import 'product_detail.dart';

String imagePath(String name) => 'assets/images/$name.webp';

class ProductCard extends StatefulWidget {
  const ProductCard({super.key, required this.product, this.index = 0});
  final Product product;
  final int index;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    return Reveal(
      delay: Duration(milliseconds: 50 * (widget.index % 4)),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: GestureDetector(
          onTap: () => showProductDetail(context, p),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: C.surface,
              border: Border.all(
                color: _hover ? C.red : C.line,
                width: _hover ? 1.5 : 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      const Positioned.fill(child: ColoredBox(color: C.surface2)),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 240),
                          opacity: _hover ? 1.0 : 0.0,
                          child: const Slashes(width: 84, height: 42),
                        ),
                      ),
                      Positioned.fill(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: AnimatedScale(
                            scale: _hover ? 1.06 : 1.0,
                            duration: const Duration(milliseconds: 340),
                            curve: Curves.easeOutCubic,
                            child: Image.asset(
                              imagePath(p.images.first),
                              fit: BoxFit.contain,
                              cacheWidth: 700,
                              filterQuality: FilterQuality.medium,
                              errorBuilder: (_, __, ___) => const Center(
                                child: Icon(
                                  Icons.image_not_supported_outlined,
                                  color: C.mute,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (p.tag != null)
                        Positioned(
                          left: 0,
                          top: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            color: p.isBestSeller ? C.red : C.bg.withAlpha(220),
                            child: Text(
                              p.tag!.toUpperCase(),
                              style: T.label(11, color: Colors.white, w: FontWeight.w700),
                            ),
                          ),
                        ),
                      Positioned(
                        right: 10,
                        bottom: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                          color: C.bg.withAlpha(190),
                          child: Text(
                            p.primaryPartPreview,
                            style: T.mono(10.5, color: C.mute),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              p.category.label.toUpperCase(),
                              overflow: TextOverflow.ellipsis,
                              style: T.label(11.5, color: C.mute),
                            ),
                          ),
                          for (final c in p.colors.take(4))
                            Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: Swatch(colors: swatchFor(c), size: 12),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      SizedBox(
                        height: 40,
                        child: Text(
                          p.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: T.body(14.5, w: FontWeight.w600, height: 1.32),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (p.priceFrom)
                                  Text('MULAI DARI', style: T.label(9.5, color: C.mute)),
                                Text(
                                  rupiah(p.price),
                                  overflow: TextOverflow.ellipsis,
                                  style: T.display(21, height: 1.05),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          _ChatAdminBadgeButton(
                            onTap: () => chatAdminForProduct(p),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ChatAdminBadgeButton extends StatefulWidget {
  const _ChatAdminBadgeButton({required this.onTap});
  final VoidCallback onTap;

  @override
  State<_ChatAdminBadgeButton> createState() => _ChatAdminBadgeButtonState();
}

class _ChatAdminBadgeButtonState extends State<_ChatAdminBadgeButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Chat Admin untuk pesan produk ini',
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _hover ? C.red : C.surface2,
              border: Border.all(
                color: _hover ? C.red : C.line,
                width: 1.2,
              ),
            ),
            child: Icon(
              Icons.chat_bubble_outline_rounded,
              size: 18,
              color: _hover ? Colors.white : C.red,
            ),
          ),
        ),
      ),
    );
  }
}
