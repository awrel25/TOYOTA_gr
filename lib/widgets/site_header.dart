import 'package:flutter/material.dart';
import '../config.dart';
import '../services/whatsapp.dart';
import '../theme.dart';

class SiteHeader extends StatelessWidget {
  const SiteHeader({
    super.key,
    required this.onProduct,
    required this.onNewArrivals,
    required this.onOutlets,
    required this.onAbout,
    this. onTop,
  });

  final VoidCallback onProduct;
  final VoidCallback onNewArrivals;
  final VoidCallback onOutlets;
  final VoidCallback onAbout;
  final VoidCallback? onTop;

  void _openMobileMenu(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: C.surface,
      barrierColor: Colors.black.withAlpha(200),
      shape: const RoundedRectangleBorder(
        side: BorderSide(color: C.line),
      ),
      builder: (ctx) {
        Widget item(String label, String sub, VoidCallback action) {
          return InkWell(
            onTap: () {
              Navigator.of(ctx).pop();
              action();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: C.line)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(label, style: T.display(26)),
                        const SizedBox(height: 2),
                        Text(sub.toUpperCase(), style: T.label(11, color: C.mute)),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_outward_rounded, size: 18, color: C.red),
                ],
              ),
            ),
          );
        }

        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 16, 16),
                child: Row(
                  children: [
                    const _Logo(),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      icon: const Icon(Icons.close, color: C.text),
                    ),
                  ],
                ),
              ),
              const Divider(color: C.line, height: 1),
              item('PRODUCT', 'Katalog lengkap 39 produk resmi', onProduct),
              item('NEW ARRIVALS', 'Produk Best Seller & koleksi unggulan', onNewArrivals),
              item('LOKASI OUTLET', '29 jaringan resmi Toyota GR Places', onOutlets),
              item('ABOUT', 'Filosofi & kualitas Toyota Gazoo Racing', onAbout),
              Padding(
                padding: const EdgeInsets.all(20),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(ctx).pop();
                    openWhatsApp();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
                    color: C.red,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.chat_bubble_outline_rounded, size: 18, color: Colors.white),
                        const SizedBox(width: 10),
                        Text(
                          'CHAT ADMIN WHATSAPP',
                          style: T.label(14, color: Colors.white, w: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Tanpa garis panjang navbar atau bar latar belakang kaku — menyatu langsung di atas background website.
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Wrap1240(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compactNav = constraints.maxWidth < 760;
            return Row(
              children: [
                GestureDetector(
                  onTap: onTop,
                  child: const MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: _Logo(),
                  ),
                ),
                const Spacer(),
                if (!compactNav)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _NavLink('PRODUCT', onProduct),
                      const SizedBox(width: 8),
                      _NavLink('NEW ARRIVALS', onNewArrivals, badge: 'BEST'),
                      const SizedBox(width: 8),
                      _NavLink('LOKASI OUTLET', onOutlets),
                      const SizedBox(width: 8),
                      _NavLink('ABOUT', onAbout),
                    ],
                  )
                else
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () => _openMobileMenu(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        color: Colors.transparent,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('MENU', style: T.label(14, color: C.text, w: FontWeight.w700)),
                            const SizedBox(width: 8),
                            const Icon(Icons.menu_rounded, color: C.text, size: 22),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Transform(
          transform: Matrix4.skewX(-0.22),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 3),
            color: C.red,
            child: Text('GR', style: T.display(25, color: Colors.white, height: 1)),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              Config.storeName.replaceFirst('GR ', '').toUpperCase(),
              style: T.label(16, color: C.text, w: FontWeight.w700),
            ),
            Text(
              'TOYOTA GAZOO RACING',
              style: T.label(9.5, color: C.mute, w: FontWeight.w600),
            ),
          ],
        ),
      ],
    );
  }
}

class _NavLink extends StatefulWidget {
  const _NavLink(this.label, this.onTap, {this.badge});
  final String label;
  final VoidCallback onTap;
  final String? badge;

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.label,
                    style: T.label(
                      14.5,
                      color: _hover ? Colors.white : C.text.withAlpha(225),
                      w: FontWeight.w700,
                    ),
                  ),
                  if (widget.badge != null) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                      color: C.red,
                      child: Text(
                        widget.badge!,
                        style: T.label(9.5, color: Colors.white, w: FontWeight.w700),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 5),
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                height: 2,
                width: _hover ? 24 : 0,
                color: C.red,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
