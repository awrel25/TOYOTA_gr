import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../data/products.dart';
import '../theme.dart';
import 'common.dart';

class OutletsSection extends StatefulWidget {
  const OutletsSection({super.key});

  @override
  State<OutletsSection> createState() => _OutletsSectionState();
}

class _OutletsSectionState extends State<OutletsSection> {
  String _cityFilter = '';

  @override
  Widget build(BuildContext context) {
    final m = isMobile(context);
    final q = _cityFilter.trim().toLowerCase();

    debugPrint('TOTAL OUTLETS: ${outlets.length}');
    for (final o in outlets) {
      debugPrint('ID: ${o.no} | ${o.name} | ${o.city}');
    }

    final byCity = <String, List<Outlet>>{};
    for (final o in outlets) {
      if (q.isNotEmpty &&
          !o.city.toLowerCase().contains(q) &&
          !o.name.toLowerCase().contains(q)) {
        continue;
      }
      byCity.putIfAbsent(o.city, () => []).add(o);
    }

    return Container(
      color: C.bg,
      child: Wrap1240(
        vertical: m ? 64 : 108,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionTitle(
              kicker: 'Jaringan Resmi GR Places',
              title: 'Lokasi Outlet',
              trailing: m
                  ? null
                  : Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        '${outlets.length} DEALER RESMI',
                        style: T.label(14.5, color: C.mute),
                      ),
                    ),
            ),
            const SizedBox(height: 18),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 620),
              child: Text(
                'Ingin melihat langsung material dan mencoba ukuran sebelum membeli? Koleksi resmi GR Merchandise tersedia di ${outlets.length} titik jaringan outlet GR Places di seluruh Indonesia.',
                style: T.body(m ? 15 : 16.5, color: C.mute),
              ),
            ),
            const SizedBox(height: 24),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: TextField(
                onChanged: (v) => setState(() => _cityFilter = v),
                style: T.body(15),
                cursorColor: C.red,
                decoration: InputDecoration(
                  hintText:
                      'Cari kota atau nama dealer (mis. Jakarta, Semarang)...',
                  hintStyle: T.body(14, color: C.mute),
                  prefixIcon: const Icon(Icons.location_on_outlined,
                      color: C.red, size: 20),
                  filled: true,
                  fillColor: C.surface,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
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
            ),
            SizedBox(height: m ? 28 : 44),
            LayoutBuilder(
              builder: (context, constraints) {
                final w = constraints.maxWidth;
                final cols =
                    w >= 1020 ? 4 : (w >= 680 ? 3 : (w >= 460 ? 2 : 1));

                final entries = byCity.entries.toList();

                return MasonryGridView.count(
                  crossAxisCount: cols,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    final e = entries[index];

                    return Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: C.surface,
                        border: Border.all(color: C.line),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Transform(
                                transform: Matrix4.skewX(-0.45),
                                child: Container(
                                  width: 8,
                                  height: 16,
                                  color: C.red,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  e.key.toUpperCase(),
                                  style: T.display(22, height: 1.05),
                                ),
                              ),
                              Text(
                                '${e.value.length}',
                                style: T.mono(12, color: C.mute),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          for (final o in e.value)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 26,
                                    child: Text(
                                      o.no.toString().padLeft(2, '0'),
                                      style: T.mono(14, color: C.red),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      o.name,
                                      style: T.body(
                                        14,
                                        color: C.text.withAlpha(225),
                                        height: 1.35,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
