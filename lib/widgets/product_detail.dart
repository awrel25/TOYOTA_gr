
import 'package:flutter/material.dart';
import '../data/products.dart';
import '../format.dart';
import '../services/whatsapp.dart';
import '../theme.dart';
import 'common.dart';
import 'product_card.dart' show imagePath;

Future<void> showProductDetail(BuildContext context, Product p) {
  final m = isMobile(context);
  return showDialog<void>(
    context: context,
    barrierColor: Colors.black.withAlpha(215),
    builder: (dialogContext) => Dialog(
      backgroundColor: C.bg,
      insetPadding: EdgeInsets.all(m ? 12 : 32),
      shape: const RoundedRectangleBorder(side: BorderSide(color: C.line)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1040),
        child: ProductDetail(product: p),
      ),
    ),
  );
}

class ProductDetail extends StatefulWidget {
  const ProductDetail({super.key, required this.product});
  final Product product;

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  late String _color = widget.product.colors.first;
  late String? _size = widget.product.sizes?.first;
  int _qty = 1;
  int _img = 0;
  bool _showChart = false;

  Product get p => widget.product;

  void _chatAdmin() {
    chatAdminForProduct(p, color: _color, size: _size, qty: _qty);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isStack = constraints.maxWidth < 760;
        final media = _Gallery(
          product: p,
          index: _img,
          onSelect: (i) => setState(() => _img = i),
        );
        final info = _info(context, isStack);

        return Stack(
          children: [
            SingleChildScrollView(
              child: isStack
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [media, info],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 10, child: media),
                        Expanded(flex: 11, child: info),
                      ],
                    ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                tooltip: 'Tutup',
                onPressed: () => Navigator.of(context).pop(),
                style: IconButton.styleFrom(
                  backgroundColor: C.bg.withAlpha(200),
                  shape: const RoundedRectangleBorder(),
                ),
                icon: const Icon(Icons.close, color: C.text),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _info(BuildContext context, bool m) {
    final part = p.partFor(_color, _size);
    final sizes = p.sizes;

    return Padding(
      padding: EdgeInsets.all(m ? 20 : 36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                p.category.label.toUpperCase(),
                style: T.label(13.5, color: C.red, w: FontWeight.w700),
              ),
              if (p.tag != null) ...[
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  color: C.red,
                  child: Text(
                    p.tag!.toUpperCase(),
                    style: T.label(
                      10.5,
                      color: Colors.white,
                      w: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(right: 36),
            child: Text(
              p.name.toUpperCase(),
              style: T.display(m ? 32 : 42),
            ),
          ),
          const SizedBox(height: 14),
          Text.rich(
            TextSpan(
              children: [
                if (p.priceFrom)
                  TextSpan(
                    text: 'mulai ',
                    style: T.body(14, color: C.mute),
                  ),
                TextSpan(
                  text: rupiah(p.price),
                  style: T.display(32, height: 1.1),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          const Divider(color: C.line, height: 1),
          const SizedBox(height: 20),

          // Pilihan warna / varian
          if (p.hasColorChoice) ...[
            _Label('${p.optionLabel}  —  $_color'),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (final c in p.colors)
                  _OptionBox(
                    selected: c == _color,
                    onTap: () => setState(() => _color = c),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Swatch(colors: swatchFor(c), size: 15),
                        const SizedBox(width: 8),
                        Text(
                          c.toUpperCase(),
                          style: T.label(
                            13.5,
                            color: c == _color ? Colors.white : C.text,
                            w: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
          ] else
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                children: [
                  _Label(p.optionLabel),
                  const SizedBox(width: 12),
                  Swatch(colors: swatchFor(p.colors.first), size: 15),
                  const SizedBox(width: 8),
                  Text(p.colors.first, style: T.body(15)),
                ],
              ),
            ),

          // Pilihan ukuran
          if (sizes != null) ...[
            Row(
              children: [
                _Label('Ukuran${_size == null ? '' : '  —  $_size'}'),
                const Spacer(),
                if (p.chart != null)
                  GestureDetector(
                    onTap: () => setState(() => _showChart = !_showChart),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Text(
                        (_showChart
                                ? 'Tutup panduan ukuran'
                                : 'Panduan ukuran')
                            .toUpperCase(),
                        style: T.label(
                          12.5,
                          color: C.red,
                          w: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (final s in sizes)
                  _OptionBox(
                    selected: s == _size,
                    minWidth: 52,
                    onTap: () => setState(() => _size = s),
                    child: Text(
                      s,
                      textAlign: TextAlign.center,
                      style: T.label(
                        15,
                        color: s == _size ? Colors.white : C.text,
                        w: FontWeight.w700,
                      ),
                    ),
                  ),
              ],
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 240),
              curve: Curves.easeOutCubic,
              alignment: Alignment.topCenter,
              child: _showChart && p.chart != null
                  ? Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: _ChartTable(
                        chart: p.chart!,
                        highlight: _size,
                      ),
                    )
                  : const SizedBox(width: double.infinity),
            ),
            const SizedBox(height: 20),
          ],

          // Spesifikasi teknis
          _SpecRow('Bahan', p.material),
          _SpecRow('Part No.', part ?? 'Dikonfirmasi admin'),
          if (p.note != null) _SpecRow('Catatan', p.note!),
          const SizedBox(height: 22),

          // Jumlah & Estimasi
          Row(
            children: [
              _Qty(
                value: _qty,
                onChanged: (v) => setState(() => _qty = v),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('ESTIMASI HARGA', style: T.label(11.5)),
                  Text(
                    rupiah(p.price * _qty),
                    style: T.display(28, height: 1.1),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 22),
          GrButton(
            label: 'Chat Admin via WhatsApp',
            icon: Icons.chat_bubble_outline_rounded,
            expand: true,
            onTap: _chatAdmin,
          ),
          const SizedBox(height: 12),
          Text(
            'Terhubung langsung ke WhatsApp Admin dengan rincian nama produk, ukuran, dan kode Part Number tanpa perlu mengisi formulir.',
            style: T.body(13, color: C.mute),
          ),
        ],
      ),
    );
  }
}

class _Gallery extends StatelessWidget {
  const _Gallery({
    required this.product,
    required this.index,
    required this.onSelect,
  });

  final Product product;
  final int index;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final imgs = product.images;

    return Container(
      // Background galeri disamakan dengan katalog produk.
      color: const Color(0xFFE3E5E8),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Stack(
              children: [
                const Positioned(
                  left: 0,
                  bottom: 0,
                  child: Slashes(width: 150, height: 70),
                ),
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.all(28),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 240),
                      child: Image.asset(
                        imagePath(imgs[index]),
                        key: ValueKey(imgs[index]),
                        fit: BoxFit.contain,
                        filterQuality: FilterQuality.high,
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
              ],
            ),
          ),
          if (imgs.length > 1)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                children: [
                  for (var i = 0; i < imgs.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: GestureDetector(
                        onTap: () => onSelect(i),
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Container(
                            width: 64,
                            height: 64,
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: C.bg,
                              border: Border.all(
                                color: i == index ? C.red : C.line,
                                width: i == index ? 2 : 1,
                              ),
                            ),
                            child: Image.asset(
                              imagePath(imgs[i]),
                              fit: BoxFit.contain,
                              cacheWidth: 160,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);
  final String text;

  @override
  Widget build(BuildContext context) =>
      Text(
        text.toUpperCase(),
        style: T.label(13.5, color: C.mute, w: FontWeight.w700),
      );
}

class _OptionBox extends StatelessWidget {
  const _OptionBox({
    required this.selected,
    required this.onTap,
    required this.child,
    this.minWidth = 0,
  });

  final bool selected;
  final VoidCallback onTap;
  final Widget child;
  final double minWidth;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          constraints: BoxConstraints(
            minWidth: minWidth,
            minHeight: 44,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? C.red : Colors.transparent,
            border: Border.all(
              color: selected ? C.red : C.line,
              width: 1.5,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _SpecRow extends StatelessWidget {
  const _SpecRow(this.k, this.v);

  final String k;
  final String v;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 92,
            child: Text(k.toUpperCase(), style: T.label(12.5)),
          ),
          Expanded(
            child: Text(v, style: T.body(14.5)),
          ),
        ],
      ),
    );
  }
}

class _Qty extends StatelessWidget {
  const _Qty({
    required this.value,
    required this.onChanged,
  });

  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    Widget btn(IconData i, VoidCallback? f) => InkResponse(
          onTap: f,
          child: SizedBox(
            width: 42,
            height: 44,
            child: Icon(
              i,
              size: 19,
              color: f == null ? C.line : C.text,
            ),
          ),
        );

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: C.line, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          btn(
            Icons.remove,
            value > 1 ? () => onChanged(value - 1) : null,
          ),
          SizedBox(
            width: 36,
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: T.display(22, height: 1.4),
            ),
          ),
          btn(
            Icons.add,
            value < 99 ? () => onChanged(value + 1) : null,
          ),
        ],
      ),
    );
  }
}

class _ChartTable extends StatelessWidget {
  const _ChartTable({
    required this.chart,
    this.highlight,
  });

  final SizeChart chart;
  final String? highlight;

  @override
  Widget build(BuildContext context) {
    TableRow row(
      List<String> cells, {
      bool head = false,
      bool hi = false,
    }) =>
        TableRow(
          decoration: BoxDecoration(
            color: head
                ? C.surface2
                : (hi ? C.red.withAlpha(60) : Colors.transparent),
            border: const Border(
              bottom: BorderSide(color: C.line),
            ),
          ),
          children: [
            for (final c in cells)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 10,
                ),
                child: Text(
                  head ? c.toUpperCase() : c,
                  textAlign: TextAlign.center,
                  style: head
                      ? T.label(11, color: C.mute, w: FontWeight.w700)
                      : T.body(13.5, w: FontWeight.w600),
                ),
              ),
          ],
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 420),
            child: Table(
              defaultColumnWidth: const IntrinsicColumnWidth(),
              children: [
                row(['Size', ...chart.columns], head: true),
                for (final e in chart.rows.entries)
                  row(
                    [e.key, ...e.value],
                    hi: e.key == highlight,
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Semua ukuran dalam sentimeter (cm). Toleransi ukuran dapat terjadi.',
          style: T.body(12, color: C.mute),
        ),
      ],
    );
  }
}
