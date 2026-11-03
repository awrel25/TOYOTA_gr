import 'package:flutter/material.dart';
import '../config.dart';
import '../services/whatsapp.dart';
import '../theme.dart';
import 'common.dart';

class SiteFooter extends StatelessWidget {
  const SiteFooter({
    super.key,
    required this.onTop,
    required this.onProduct,
    required this.onNewArrivals,
    required this.onOutlets,
    required this.onAbout,
  });

  final VoidCallback onTop;
  final VoidCallback onProduct;
  final VoidCallback onNewArrivals;
  final VoidCallback onOutlets;
  final VoidCallback onAbout;

  @override
  Widget build(BuildContext context) {
    final m = isMobile(context);
    return Container(
      color: C.bg,
      child: Column(
        children: [
          Container(
            color: C.red,
            child: Wrap1240(
              vertical: m ? 52 : 84,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final wide = constraints.maxWidth >= 820;
                  final content = Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'BUTUH BANTUAN UKURAN\nATAU CEK STOK CEPAT?',
                        style: T.display(m ? 44 : 76, color: Colors.white),
                      ),
                      const SizedBox(height: 18),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 540),
                        child: Text(
                          'Tanyakan ketersediaan stok, konsultasi ukuran, atau pemesanan langsung ke admin resmi kami via WhatsApp.',
                          style: T.body(m ? 15.5 : 18, color: Colors.white.withAlpha(235)),
                        ),
                      ),
                    ],
                  );

                  final actions = Wrap(
                    spacing: 14,
                    runSpacing: 14,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      _WhiteButton(
                        label: 'Chat Admin',
                        onTap: () => openWhatsApp(),
                      ),
                      GrButton(
                        label: 'Kembali ke Atas',
                        outline: true,
                        icon: Icons.arrow_upward_rounded,
                        onTap: onTop,
                      ),
                    ],
                  );

                  if (wide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(child: content),
                        const SizedBox(width: 32),
                        actions,
                      ],
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      content,
                      const SizedBox(height: 28),
                      actions,
                    ],
                  );
                },
              ),
            ),
          ),
          Container(
            color: C.bg,
            child: Wrap1240(
              vertical: 32,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 28,
                    runSpacing: 12,
                    children: [
                      _FooterNav('PRODUCT', onProduct),
                      _FooterNav('NEW ARRIVALS', onNewArrivals),
                      _FooterNav('LOKASI OUTLET', onOutlets),
                      _FooterNav('ABOUT', onAbout),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(color: C.line, height: 1),
                  const SizedBox(height: 18),
                  Text(
                    '${Config.storeName} · Official Catalog ${Config.catalogYear}. Harga dan ketersediaan stok dapat berubah sewaktu-waktu. '
                    'Seluruh foto, spesifikasi bahan, dan kode Part Number mengacu pada Toyota Gazoo Racing Apparel & Merchandise Catalog ${Config.catalogYear}.',
                    style: T.body(12.5, color: C.mute),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterNav extends StatelessWidget {
  const _FooterNav(this.label, this.onTap);
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          label,
          style: T.label(13.5, color: C.text, w: FontWeight.w700),
        ),
      ),
    );
  }
}

class _WhiteButton extends StatefulWidget {
  const _WhiteButton({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  State<_WhiteButton> createState() => _WhiteButtonState();
}

class _WhiteButtonState extends State<_WhiteButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          color: _hover ? C.bg : Colors.white,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.chat_bubble_outline_rounded,
                size: 19,
                color: _hover ? Colors.white : C.red,
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  widget.label.toUpperCase(),
                  overflow: TextOverflow.ellipsis,
                  style: T.label(
                    15.5,
                    color: _hover ? Colors.white : C.bg,
                    w: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
