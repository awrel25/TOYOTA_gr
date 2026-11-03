import 'package:flutter/material.dart';
import '../theme.dart';

/// Muncul dengan fade + naik halus. Dipakai untuk hero dan kartu produk.
class Reveal extends StatefulWidget {
  const Reveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.dy = 28,
  });

  final Widget child;
  final Duration delay;
  final double dy;

  @override
  State<Reveal> createState() => _RevealState();
}

class _RevealState extends State<Reveal> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
  late final Animation<double> _a = CurvedAnimation(parent: _c, curve: Curves.easeOutCubic);

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.delay, () {
      if (mounted) _c.forward();
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _a,
      builder: (context, child) => Opacity(
        opacity: _a.value,
        child: Transform.translate(offset: Offset(0, (1 - _a.value) * widget.dy), child: child),
      ),
      child: widget.child,
    );
  }
}

/// Tiga garis miring ala katalog GR (dekorasi).
class Slashes extends StatelessWidget {
  const Slashes({super.key, this.width = 220, this.height = 120});
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: Size(width, height), painter: _SlashPainter());
}

class _SlashPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final skew = size.height * 0.55;
    void bar(double x, double w, Color color) {
      final p = Path()
        ..moveTo(x + skew, 0)
        ..lineTo(x + skew + w, 0)
        ..lineTo(x + w, size.height)
        ..lineTo(x, size.height)
        ..close();
      canvas.drawPath(p, Paint()..color = color);
    }

    final u = size.width / 11;
    bar(u * 1.0, u * 3.2, C.red);
    bar(u * 4.9, u * 1.2, C.text);
    bar(u * 6.9, u * 3.0, C.redDark);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class GrButton extends StatefulWidget {
  const GrButton({
    super.key,
    required this.label,
    required this.onTap,
    this.outline = false,
    this.icon,
    this.expand = false,
    this.compact = false,
  });

  final String label;
  final VoidCallback? onTap;
  final bool outline;
  final IconData? icon;
  final bool expand;
  final bool compact;

  @override
  State<GrButton> createState() => _GrButtonState();
}

class _GrButtonState extends State<GrButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onTap != null;
    final Color bg;
    final Color fg;
    final Color border;
    if (widget.outline) {
      bg = _hover ? C.text : Colors.transparent;
      fg = _hover ? C.bg : C.text;
      border = C.text;
    } else {
      bg = !enabled ? C.line : (_hover ? C.redDark : C.red);
      fg = Colors.white;
      border = bg;
    }
    final child = AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      padding: EdgeInsets.symmetric(
        horizontal: widget.compact ? 16 : 24,
        vertical: widget.compact ? 10 : 16,
      ),
      decoration: BoxDecoration(color: bg, border: Border.all(color: border, width: 1.5)),
      child: Row(
        mainAxisSize: widget.expand ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.icon != null) ...[
            Icon(widget.icon, size: 18, color: fg),
            const SizedBox(width: 10),
          ],
          Flexible(
            child: Text(
              widget.label.toUpperCase(),
              overflow: TextOverflow.ellipsis,
              style: T.label(widget.compact ? 14 : 16, color: fg, w: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
    return MouseRegion(
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(onTap: widget.onTap, child: child),
    );
  }
}

/// Titik warna. Dua warna ditampilkan terbelah.
class Swatch extends StatelessWidget {
  const Swatch({super.key, required this.colors, this.size = 14});
  final List<Color> colors;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withAlpha(70)),
      ),
      child: ClipOval(
        child: Row(
          children: [for (final c in colors) Expanded(child: ColoredBox(color: c, child: const SizedBox.expand()))],
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle({super.key, required this.kicker, required this.title, this.trailing});
  final String kicker;
  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final m = isMobile(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Transform(
                    transform: Matrix4.skewX(-0.45),
                    child: Container(width: 22, height: 10, color: C.red),
                  ),
                  const SizedBox(width: 12),
                  Text(kicker.toUpperCase(), style: T.label(14, color: C.red, w: FontWeight.w700)),
                ],
              ),
              const SizedBox(height: 14),
              Text(title.toUpperCase(), style: T.display(m ? 44 : 72)),
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}
