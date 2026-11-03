# GR Merchandise — Katalog Web 2025 (Flutter Web)

Katalog resmi interaktif dari **Toyota Gazoo Racing Apparel & Merchandise Catalog 2025**.

## Ringkasan Revisi & Fitur Utama

1. **Seamless Borderless Navbar**: Navigasi menyatu langsung di atas background website tanpa garis panjang pembatas (`PRODUCT`, `NEW ARRIVALS`, `LOKASI OUTLET`, `ABOUT`), lengkap dengan drawer responsif untuk perangkat mobile.
2. **Bagian New Arrivals (Produk Best Seller)**: Kurasi produk unggulan dan koleksi terbaru 2025 dengan kode Part Number OEM resmi.
3. **Bagian About (Menggantikan Cara Pesan)**: Menampilkan filosofi motorsport Toyota Gazoo Racing Collection, lookbook resmi, dan 3 pilar kualitas menggunakan tipografi (`Barlow Condensed`, `Barlow`, `IBM Plex Mono`) serta palet warna hitam/merah GR yang serasi.
4. **Pemesanan Instan via Simbol Chat Admin di Setiap Card Product**: Tanpa formulir pemesanan yang rumit — setiap kartu produk memiliki tombol simbol Chat Admin yang langsung membuka WhatsApp dengan rincian nama produk, kategori, harga, dan kode Part Number.
5. **Adaptive & Responsive Layout**: Menggunakan `LayoutBuilder` dan `MediaQuery.sizeOf(context)` sesuai pedoman `flutter-build-responsive-layout` dan `design-taste-frontend` agar tampil proporsional di layar mobile, tablet, hingga desktop.

## Menjalankan Project

```bash
flutter pub get
flutter run -d chrome
```
