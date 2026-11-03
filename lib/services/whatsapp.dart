import 'package:url_launcher/url_launcher.dart';
import '../config.dart';
import '../data/products.dart';
import '../format.dart';

/// Membuat pesan WhatsApp otomatis saat pengguna menekan simbol Chat Admin pada produk.
String buildDirectProductMessage(
  Product product, {
  String? color,
  String? size,
  int qty = 1,
}) {
  final selectedColor = color ?? (product.colors.isNotEmpty ? product.colors.first : null);
  final partNo = product.partFor(selectedColor, size);
  final b = StringBuffer()
    ..writeln(
        'Halo Admin ${Config.storeName}, saya tertarik dengan produk dari Katalog ${Config.catalogYear}:')
    ..writeln()
    ..writeln('*${product.name}*')
    ..writeln('Kategori: ${product.category.label}')
    ..writeln('Harga: ${product.priceFrom ? "Mulai " : ""}${rupiah(product.price)}');

  if (product.hasColorChoice && selectedColor != null && selectedColor != '—') {
    b.writeln('${product.optionLabel}: $selectedColor');
  } else if (selectedColor != null && selectedColor != '—') {
    b.writeln('Warna: $selectedColor');
  }
  if (size != null) {
    b.writeln('Ukuran: $size');
  }
  if (partNo != null) {
    b.writeln('Part No: $partNo');
  }
  if (qty > 1) {
    b.writeln('Jumlah: $qty pcs');
  }
  b
    ..writeln()
    ..write('Mohon informasi ketersediaan stok dan cara pemesanannya. Terima kasih.');
  return b.toString();
}

Future<bool> openWhatsApp([String? message]) {
  final base = 'https://wa.me/${Config.whatsappNumber}';
  final uri = Uri.parse(
    message == null ? base : '$base?text=${Uri.encodeComponent(message)}',
  );
  return launchUrl(uri, mode: LaunchMode.externalApplication);
}

Future<bool> chatAdminForProduct(
  Product product, {
  String? color,
  String? size,
  int qty = 1,
}) {
  return openWhatsApp(
    buildDirectProductMessage(product, color: color, size: size, qty: qty),
  );
}
