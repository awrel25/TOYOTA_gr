import 'package:flutter/material.dart';
import 'theme.dart';
import 'widgets/about_section.dart';
import 'widgets/catalog_section.dart';
import 'widgets/hero_banner.dart';
import 'widgets/new_arrivals_section.dart';
import 'widgets/outlets_section.dart';
import 'widgets/site_footer.dart';

void main() => runApp(const GrMerchApp());

class GrMerchApp extends StatelessWidget {
  const GrMerchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GR Merchandise — Official Catalog 2026',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scroll = ScrollController();
  final _newArrivalsKey = GlobalKey();
  final _outletsKey = GlobalKey();
  final _aboutKey = GlobalKey();

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _go(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOutCubic,
      alignment: 0,
    );
  }

  void _top() => _scroll.animateTo(
        0,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOutCubic,
      );

  /// Membuka halaman All Product yang terpisah agar pengguna tidak perlu scroll terlalu panjang di beranda.
  void _openAllProductsPage() {
    Navigator.of(context).push(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 280),
        reverseTransitionDuration: const Duration(milliseconds: 220),
        pageBuilder: (ctx, animation, secondaryAnimation) => FadeTransition(
          opacity: animation,
          child: AllProductsPage(
            onBackToHome: () => Navigator.of(ctx).pop(),
            onNavigateSection: (section) {
              Navigator.of(ctx).pop();
              WidgetsBinding.instance.addPostFrameCallback((_) {
                switch (section) {
                  case 'new-arrivals':
                    _go(_newArrivalsKey);
                  case 'outlets':
                    _go(_outletsKey);
                  case 'about':
                    _go(_aboutKey);
                }
              });
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: _scroll,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HeroBanner(
              onProduct: _openAllProductsPage,
              onNewArrivals: () => _go(_newArrivalsKey),
              onOutlets: () => _go(_outletsKey),
              onAbout: () => _go(_aboutKey),
              onTop: _top,
            ),
            // Di halaman utama (hook), hanya ditampilkan produk Best Seller / New Arrivals
            // beserta tombol CTA di bawahnya untuk masuk ke halaman All Product.
            KeyedSubtree(
              key: _newArrivalsKey,
              child: NewArrivalsSection(
                onOpenAllProducts: _openAllProductsPage,
              ),
            ),
            KeyedSubtree(
              key: _outletsKey,
              child: const OutletsSection(),
            ),
            KeyedSubtree(
              key: _aboutKey,
              child: const AboutSection(),
            ),
            SiteFooter(
              onTop: _top,
              onProduct: _openAllProductsPage,
              onNewArrivals: () => _go(_newArrivalsKey),
              onOutlets: () => _go(_outletsKey),
              onAbout: () => _go(_aboutKey),
            ),
          ],
        ),
      ),
    );
  }
}
