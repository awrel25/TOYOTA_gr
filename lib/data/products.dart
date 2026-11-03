import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
//  Data diambil dari "GR Apparel & Merchandise Catalog 2025".
//  Harga, bahan, part number, dan size chart mengikuti katalog resmi.
// ---------------------------------------------------------------------------

enum Category { polo, tshirt, shirt, hoodie, jacket, cap, umbrella, gears }

extension CategoryX on Category {
  String get label => switch (this) {
        Category.polo => 'Polo Shirt',
        Category.tshirt => 'T-Shirt',
        Category.shirt => 'Shirt',
        Category.hoodie => 'Hoodie',
        Category.jacket => 'Jacket',
        Category.cap => 'Cap',
        Category.umbrella => 'Umbrella',
        Category.gears => 'Gears',
      };
}

class SizeChart {
  const SizeChart(this.columns, this.rows);
  final List<String> columns;
  final Map<String, List<String>> rows; // ukuran -> nilai tiap kolom (cm)
}

const _cols = [
  'Lingkar badan',
  'Lebar bahu',
  'Panjang badan',
  'Panjang lengan',
  'Lebar leher',
];

const _sizes = ['S', 'M', 'L', '2L', '3L'];

const chartPolo = SizeChart(_cols, {
  'S': ['98', '41.5', '65.5', '21', '16'],
  'M': ['102', '43.5', '67.5', '22', '16'],
  'L': ['106', '45.5', '69.5', '23', '16.5'],
  '2L': ['110', '47.5', '71.5', '24', '17'],
  '3L': ['114', '49.5', '73.5', '25', '17.5'],
});

const chartPoloDryFit = SizeChart(_cols, {
  'S': ['98', '41.5', '65.5', '19', '16'],
  'M': ['102', '43.5', '67.5', '20', '16'],
  'L': ['106', '45.5', '69.5', '21', '16.5'],
  '2L': ['110', '47.5', '71.5', '22', '17'],
  '3L': ['114', '49.5', '73.5', '23', '17.5'],
});

const chartTee = SizeChart(_cols, {
  'S': ['92', '42', '68', '19.5', '19'],
  'M': ['96', '44', '70', '20', '19'],
  'L': ['102', '46', '72', '20.5', '19.5'],
  '2L': ['108', '48', '74', '21', '20'],
  '3L': ['114', '50', '75', '21.5', '20.5'],
});

const chartShirt = SizeChart(_cols, {
  'S': ['105', '43.5', '65', '22', '16'],
  'M': ['108', '44.5', '68', '23', '16'],
  'L': ['114', '46', '71', '24', '16.6'],
  '2L': ['120', '47.5', '74', '25', '17'],
  '3L': ['126', '49', '77', '25.5', '17.5'],
});

const chartHoodie = SizeChart(_cols, {
  'S': ['104', '42', '62', '68', '24'],
  'M': ['110', '46', '66', '70', '24'],
  'L': ['116', '50', '70', '71', '24.5'],
  '2L': ['126', '53', '75', '72', '25'],
  '3L': ['136', '56', '80', '72', '25.5'],
});

const chartLightJacket = SizeChart(_cols, {
  'S': ['100', '42', '73', '71', '-'],
  'M': ['106', '43.5', '73', '71', '-'],
  'L': ['112', '45', '75', '72', '-'],
  '2L': ['118', '46.5', '75', '72', '-'],
  '3L': ['124', '48', '77', '73', '-'],
});

const chartJacket2 = SizeChart(_cols, {
  'S': ['102', '42', '62.5', '61', '17.5'],
  'M': ['108', '45', '64.5', '62.5', '17.5'],
  'L': ['116', '47.5', '67.5', '65', '18'],
  '2L': ['126', '51', '69.5', '66', '18.5'],
  '3L': ['136', '54', '72.5', '66.5', '19'],
});

class Product {
  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.material,
    required this.images,
    this.colors = const ['—'],
    this.sizes,
    this.parts = const {},
    this.chart,
    this.tag,
    this.note,
    this.optionLabel = 'Warna',
    this.priceFrom = false,
    this.isBestSeller = false,
  });

  final String id;
  final String name;
  final Category category;
  final int price;
  final String material;
  final List<String> images;
  final List<String> colors;
  final List<String>? sizes;
  final Map<String, String> parts;
  final SizeChart? chart;
  final String? tag;
  final String? note;
  final String optionLabel;
  final bool priceFrom;
  final bool isBestSeller;

  bool get hasColorChoice => colors.length > 1;

  /// Cari part number: "warna|ukuran" -> "ukuran" -> "warna" -> "*".
  String? partFor(String? color, String? size) {
    return parts['$color|$size'] ?? parts[size] ?? parts[color] ?? parts['*'];
  }

  /// Kode referensi utama untuk ditampilkan pada kartu produk.
  String get primaryPartPreview {
    if (parts.isEmpty) return 'GR-2025';
    return parts.values.first;
  }
}

Map<String, String> _bySize(List<String> codes) =>
    {for (var i = 0; i < codes.length; i++) _sizes[i]: codes[i]};

Map<String, String> _bySizeColor(String color, List<String> codes) =>
    {for (var i = 0; i < codes.length; i++) '$color|${_sizes[i]}': codes[i]};

const _polyHd = 'Dry Fit Polyester + HD Printing';
const _cottonHd = 'Cotton Combed + HD Printing';
const _umbrellaMat = 'Polyester (Canopy) + Fiber Plastic (Handle) + Sponge';
const _strapMat = 'Polyester (Strap) + Metal (Stopper & Hanger)';

final List<Product> products = [
  // ------------------------------ POLO ------------------------------------
  Product(
    id: 'sporty-polo-black',
    name: 'Gazoo Sporty Polo Shirt Black',
    category: Category.polo,
    price: 489000,
    material: _polyHd,
    images: ['sporty-polo-black'],
    colors: ['Black'],
    sizes: _sizes,
    chart: chartPolo,
    tag: 'Best Seller',
    isBestSeller: true,
    parts: _bySize(['10311TAG25', '10312TAG25', '10313TAG25', '10314TAG25', '10315TAG25']),
  ),
  Product(
    id: 'sporty-polo-white',
    name: 'Gazoo Sporty Polo Shirt White',
    category: Category.polo,
    price: 489000,
    material: _polyHd,
    images: ['sporty-polo-white'],
    colors: ['White'],
    sizes: _sizes,
    chart: chartPolo,
    tag: 'New Arrival',
    isBestSeller: true,
    parts: _bySize(['1030VTAG25', '1030WTAG25', '1030XTAG25', '1030YTAG25', '1030ZTAG25']),
  ),
  Product(
    id: 'sporty-polo-female-white',
    name: 'Gazoo Sporty Polo Shirt (Female Version) White',
    category: Category.polo,
    price: 489000,
    material: _polyHd,
    images: ['sporty-polo-female-white'],
    colors: ['White'],
    sizes: _sizes,
    tag: 'Female · New',
    note:
        'Versi wanita. Detail ukuran lengkap ada di halaman size chart katalog — tanyakan admin bila ragu.',
    parts: _bySize(['1030LTAG25', '1030MTAG25', '1030NTAG25', '1030OTAG25', '1030PTAG25']),
  ),
  Product(
    id: 'casual-polo-black',
    name: 'Gazoo Casual Polo Shirt Black',
    category: Category.polo,
    price: 349000,
    material: _cottonHd,
    images: ['casual-polo-black'],
    colors: ['Black'],
    sizes: _sizes,
    chart: chartPolo,
    tag: 'New Arrival',
    parts: _bySize(['1030GTAG25', '1030HTAG25', '1030ITAG25', '1030JTAG25', '1030KTAG25']),
  ),
  Product(
    id: 'dryfit-polo-white',
    name: 'Gazoo Polo Shirt Dry Fit White',
    category: Category.polo,
    price: 449000,
    material: _polyHd,
    images: ['dryfit-polo-white'],
    colors: ['White'],
    sizes: _sizes,
    chart: chartPoloDryFit,
    parts: _bySize(['10301TAG24', '10302TAG24', '10303TAG24', '10304TAG24', '10306TAG24']),
  ),
  Product(
    id: 'dryfit-polo-black',
    name: 'Gazoo Polo Shirt Dry Fit Black',
    category: Category.polo,
    price: 449000,
    material: _polyHd,
    images: ['dryfit-polo-black'],
    colors: ['Black'],
    sizes: _sizes,
    chart: chartPoloDryFit,
    parts: {'M': '10308TAG24', 'L': '1030ATAG24', '2L': '1030BTAG24', '3L': '1030CTAG24'},
  ),

  // ------------------------------ T-SHIRT ---------------------------------
  Product(
    id: 'yaris-t1-white',
    name: 'GR Yaris T-Shirt Type 1 White',
    category: Category.tshirt,
    price: 329000,
    material: _cottonHd,
    images: ['yaris-t1-white'],
    colors: ['White'],
    sizes: _sizes,
    chart: chartTee,
    tag: 'New Arrival',
    parts: _bySize(['1031BTAG25', '1031CTAG25', '1031DTAG25', '1031ETAG25', '1031FTAG25']),
  ),
  Product(
    id: 'yaris-t1-black',
    name: 'GR Yaris T-Shirt Type 1 Black',
    category: Category.tshirt,
    price: 329000,
    material: _cottonHd,
    images: ['yaris-t1-black'],
    colors: ['Black'],
    sizes: _sizes,
    chart: chartTee,
    tag: 'Best Seller',
    isBestSeller: true,
    parts: _bySize(['10316TAG25', '10317TAG25', '10318TAG25', '10319TAG25', '1031ATAG25']),
  ),
  Product(
    id: 'yaris-t2-white',
    name: 'GR Yaris T-Shirt Type 2 White',
    category: Category.tshirt,
    price: 329000,
    material: _cottonHd,
    images: ['yaris-t2-white'],
    colors: ['White'],
    sizes: _sizes,
    chart: chartTee,
    tag: 'Best Seller',
    isBestSeller: true,
    parts: _bySize(['1031LTAG25', '1031MTAG25', '1031NTAG25', '1031OTAG25', '1031PTAG25']),
  ),
  Product(
    id: 'yaris-t2-black',
    name: 'GR Yaris T-Shirt Type 2 Black',
    category: Category.tshirt,
    price: 329000,
    material: _cottonHd,
    images: ['yaris-t2-black'],
    colors: ['Black'],
    sizes: _sizes,
    chart: chartTee,
    tag: 'New Arrival',
    parts: _bySize(['1031GTAG25', '1031HTAG25', '1031ITAG25', '1031JTAG25', '1031KTAG25']),
  ),
  Product(
    id: 'dryfit-yaris-black',
    name: 'Gazoo T-Shirt Dry Fit GR Yaris Edition Black',
    category: Category.tshirt,
    price: 275000,
    material: 'Dry Fit Polyester + Sublime + HD Printing',
    images: ['dryfit-yaris-black'],
    colors: ['Black'],
    sizes: _sizes,
    chart: chartTee,
    tag: 'New Arrival',
    parts: _bySize(['10321TAG25', '10322TAG25', '10323TAG25', '10324TAG25', '10325TAG25']),
  ),
  Product(
    id: 'dryfit-yaris-white',
    name: 'Gazoo T-Shirt Dry Fit GR Yaris Edition White',
    category: Category.tshirt,
    price: 275000,
    material: 'Dry Fit Polyester + Sublime + HD Printing',
    images: ['dryfit-yaris-white'],
    colors: ['White'],
    sizes: _sizes,
    chart: chartTee,
    tag: 'New Arrival',
    parts: _bySize(['10326TAG25', '10327TAG25', '10328TAG25', '10329TAG25', '1032ATAG25']),
  ),
  Product(
    id: 'rally2-black',
    name: 'Gazoo T-Shirt Rally2 Boxy Cut Black',
    category: Category.tshirt,
    price: 299000,
    material: 'Cotton Combed 16S + HD Printing',
    images: ['rally2-black'],
    colors: ['Black'],
    sizes: _sizes,
    chart: chartTee,
    tag: 'Best Seller',
    isBestSeller: true,
    parts: _bySize(['1031QTAG25', '1031RTAG25', '1031STAG25', '1031TTAG25', '1031UTAG25']),
  ),
  Product(
    id: 'rally2-white',
    name: 'Gazoo T-Shirt Rally2 Boxy Cut White',
    category: Category.tshirt,
    price: 299000,
    material: 'Cotton Combed 16S + HD Printing',
    images: ['rally2-white'],
    colors: ['White'],
    sizes: _sizes,
    chart: chartTee,
    tag: 'New Arrival',
    parts: _bySize(['1031VTAG25', '1031WTAG25', '1031XTAG25', '1031YTAG25', '1031ZTAG25']),
  ),
  Product(
    id: 'prius',
    name: 'GR T-Shirt Prius',
    category: Category.tshirt,
    price: 299000,
    material: _cottonHd,
    images: ['prius'],
    colors: ['White'],
    sizes: _sizes,
    chart: chartTee,
    tag: 'Limited Edition',
    parts: _bySize(['1030RTAG24', '1030STAG24', '1030TTAG24', '1030UTAG24', '1030VTAG24']),
  ),
  Product(
    id: 'combi',
    name: 'Gazoo T-Shirt Combi White',
    category: Category.tshirt,
    price: 229000,
    material: _cottonHd,
    images: ['combi'],
    colors: ['White'],
    sizes: _sizes,
    chart: chartTee,
    parts: _bySize(['1030WTAG23', '1030XTAG23', '1030YTAG23', '1030ZTAG23', '10311TAG23']),
  ),

  // ------------------------------ SHIRT -----------------------------------
  Product(
    id: 'mechanic2',
    name: 'Gazoo Mechanic 2',
    category: Category.shirt,
    price: 499000,
    material: 'Cotton + Polyester',
    images: ['mechanic2'],
    colors: ['Black'],
    sizes: _sizes,
    chart: chartShirt,
    parts: _bySize(['10361TAG21', '10362TAG21', '10363TAG21', '10364TAG21', '10365TAG21']),
  ),
  Product(
    id: 'uniform',
    name: 'Gazoo Uniform',
    category: Category.shirt,
    price: 499000,
    material: 'Cotton + Polyester',
    images: ['uniform'],
    colors: ['White'],
    sizes: _sizes,
    chart: chartShirt,
    parts: _bySize(['1033ATAG22', '1033BTAG22', '1033CTAG22', '1033DTAG22', '1033ETAG22']),
  ),

  // ------------------------------ HOODIE ----------------------------------
  Product(
    id: 'hoodie-white',
    name: 'Gazoo Casual Hoodie White',
    category: Category.hoodie,
    price: 899000,
    material: 'Cotton',
    images: ['hoodie-white', 'hoodie-white-2'],
    colors: ['White'],
    sizes: _sizes,
    chart: chartHoodie,
    parts: _bySize(['1030ITAG24', '1030JTAG24', '1030KTAG24', '1030LTAG24', '1030MTAG24']),
  ),
  Product(
    id: 'hoodie-black',
    name: 'Gazoo Casual Hoodie Black',
    category: Category.hoodie,
    price: 899000,
    material: 'Cotton',
    images: ['hoodie-black'],
    colors: ['Black'],
    sizes: _sizes,
    chart: chartHoodie,
    tag: 'Best Seller',
    isBestSeller: true,
    parts: _bySize(['1030DTAG24', '1030ETAG24', '1030FTAG24', '1030GTAG24', '1030HTAG24']),
  ),

  // ------------------------------ JACKET ----------------------------------
  Product(
    id: 'sporty-light-jacket',
    name: 'Gazoo Sporty Light Jacket',
    category: Category.jacket,
    price: 659000,
    material: 'Polyester + HD Printing',
    images: ['sporty-light-jacket'],
    colors: ['Black', 'White'],
    sizes: _sizes,
    chart: chartLightJacket,
    tag: 'Best Seller',
    isBestSeller: true,
    parts: {
      ..._bySizeColor('Black', ['1030BTAG25', '1030CTAG25', '1030DTAG25', '1030ETAG25', '1030FTAG25']),
      ..._bySizeColor('White', ['10306TAG25', '10307TAG25', '10308TAG25', '10309TAG25', '1030ATAG25']),
    },
  ),
  Product(
    id: 'casual-light-jacket',
    name: 'Gazoo Casual Light Jacket Grey',
    category: Category.jacket,
    price: 526000,
    material: 'Cotton',
    images: ['casual-light-jacket'],
    colors: ['Grey'],
    sizes: _sizes,
    chart: chartLightJacket,
    tag: 'New Arrival',
    parts: _bySize(['10301TAG25', '10302TAG25', '10303TAG25', '10304TAG25', '10305TAG25']),
  ),
  Product(
    id: 'jacket2',
    name: 'Gazoo Jacket 2',
    category: Category.jacket,
    price: 949000,
    material: 'Polyester',
    images: ['jacket2'],
    colors: ['Black'],
    sizes: _sizes,
    chart: chartJacket2,
    tag: 'Best Seller',
    isBestSeller: true,
    note: 'Bomber eksklusif dengan aksen checkered flag Toyota Gazoo Racing.',
    parts: _bySize(['10461TAG21', '10462TAG21', '10463TAG21', '10464TAG21', '10465TAG21']),
  ),

  // ------------------------------ CAP -------------------------------------
  Product(
    id: 'cap-combi',
    name: 'Gazoo Racing Cap Combi',
    category: Category.cap,
    price: 189000,
    material: 'Polyester',
    images: ['cap-combi'],
    colors: ['Black'],
    parts: {'*': '10802TAG21'},
  ),
  Product(
    id: 'cap-white-t1',
    name: 'Gazoo Racing Cap White Type 1',
    category: Category.cap,
    price: 189000,
    material: 'Polyester',
    images: ['cap-white-t1'],
    colors: ['White'],
    parts: {'*': '1081ETAG22'},
  ),
  Product(
    id: 'cap-black',
    name: 'Gazoo Racing Cap - Black',
    category: Category.cap,
    price: 189000,
    material: 'Polyester',
    images: ['cap-black'],
    colors: ['Black'],
    parts: {'*': '10803TAG21'},
  ),
  Product(
    id: 'cap-black-batik',
    name: 'Gazoo Racing Cap - Black Batik',
    category: Category.cap,
    price: 189000,
    material: 'Polyester',
    images: ['cap-black-batik'],
    colors: ['Black'],
    parts: {'*': '10801TAG21'},
  ),
  Product(
    id: 'cap-classic-t1',
    name: 'Gazoo Racing Classic Cap Type 1',
    category: Category.cap,
    price: 189000,
    material: 'Polyester',
    images: ['cap-classic-t1'],
    colors: ['Black'],
    note: 'Tersedia juga model baseball cap.',
    parts: {'*': '1030XTAG24'},
  ),
  Product(
    id: 'cap-black-t1',
    name: 'Gazoo Racing Cap Black Type 1',
    category: Category.cap,
    price: 189000,
    material: 'Polyester',
    images: ['cap-black-t1'],
    colors: ['Black'],
    parts: {'*': '1081ATAG22'},
  ),

  // ------------------------------ UMBRELLA --------------------------------
  Product(
    id: 'umbrella-folding-black',
    name: 'Gazoo Racing Folding Umbrella Black',
    category: Category.umbrella,
    price: 199000,
    material: _umbrellaMat,
    images: ['umbrella-folding-black'],
    colors: ['Black'],
    parts: {'*': '1082ATAG22'},
  ),
  Product(
    id: 'umbrella-folding-red',
    name: 'Gazoo Racing Folding Umbrella Red',
    category: Category.umbrella,
    price: 199000,
    material: _umbrellaMat,
    images: ['umbrella-folding-red'],
    colors: ['Red'],
    parts: {'*': '1082BTAG22'},
  ),
  Product(
    id: 'umbrella-golf-black',
    name: 'Gazoo Racing Umbrella Golf Black',
    category: Category.umbrella,
    price: 499000,
    material: _umbrellaMat,
    images: ['umbrella-golf-black'],
    colors: ['Black'],
    parts: {'*': '1083BTAG22'},
  ),
  Product(
    id: 'umbrella-golf-white',
    name: 'Gazoo Racing Umbrella Golf White',
    category: Category.umbrella,
    price: 499000,
    material: _umbrellaMat,
    images: ['umbrella-golf-white'],
    colors: ['White'],
    parts: {'*': '1083ATAG22'},
  ),

  // ------------------------------ GEARS -----------------------------------
  Product(
    id: 'tumbler',
    name: 'Toyota Gazoo Racing Tumbler Thermos',
    category: Category.gears,
    price: 429000,
    material: 'Stainless Steel',
    images: ['tumbler'],
    colors: ['Black', 'White', 'Grey', 'Red'],
    parts: {
      'Black': '1085ATAG22',
      'White': '1085DTAG22',
      'Grey': '1080ITAG24',
      'Red': '1085ETAG22',
    },
  ),
  Product(
    id: 'keychain',
    name: 'Gazoo Keychain',
    category: Category.gears,
    price: 119000,
    material: _strapMat,
    images: ['keychain'],
    colors: ['Black & Grey', 'Red & White'],
    parts: {'Black & Grey': '10803TAG24', 'Red & White': '10804TAG24'},
  ),
  Product(
    id: 'lanyard-t2',
    name: 'Gazoo Lanyard Type 2',
    category: Category.gears,
    price: 170000,
    material: _strapMat,
    images: ['lanyard-t2'],
    colors: ['Black', 'Red'],
    parts: {'Black': '1080HTAG24', 'Red': '1080GTAG24'},
  ),
  Product(
    id: 'lanyard-t3',
    name: 'Gazoo Lanyard Type 3',
    category: Category.gears,
    price: 170000,
    material: _strapMat,
    images: ['lanyard-t3'],
    colors: ['Black', 'Red'],
    parts: {'Black': '10802TAG24', 'Red': '10801TAG24'},
  ),
  Product(
    id: 'sticker-straight',
    name: 'GR Sticker Straight Cutting',
    category: Category.gears,
    price: 96000,
    priceFrom: true,
    material: 'Sticker cutting',
    images: ['sticker-straight'],
    colors: ['White', 'White Background'],
    optionLabel: 'Varian',
    sizes: ['S', 'M', 'L'],
    note: 'Harga dapat berbeda sesuai ukuran.',
    parts: {
      'White|S': '10841TAG21',
      'White|M': '10842TAG21',
      'White|L': '10843TAG21',
      'White Background|S': '10851TAG21',
      'White Background|M': '10852TAG21',
      'White Background|L': '10853TAG21',
    },
  ),
  Product(
    id: 'sticker-stack',
    name: 'GR Sticker Stack Cutting',
    category: Category.gears,
    price: 59000,
    priceFrom: true,
    material: 'Sticker cutting',
    images: ['sticker-stack'],
    colors: ['White', 'White Background'],
    optionLabel: 'Varian',
    sizes: ['S', 'M', 'L'],
    note: 'Harga dapat berbeda sesuai ukuran.',
    parts: {
      'White|S': '10821TAG21',
      'White|M': '10822TAG21',
      'White|L': '10823TAG21',
      'White Background|S': '10831TAG21',
      'White Background|M': '10832TAG21',
      'White Background|L': '10833TAG21',
    },
  ),
];

/// Produk unggulan untuk menu NEW ARRIVALS (Produk Best Seller).
List<Product> get bestSellerProducts =>
    products.where((p) => p.isBestSeller).toList(growable: false);

/// Warna titik pada pilihan warna. Dua warna = split.
List<Color> swatchFor(String name) {
  switch (name) {
    case 'Black':
      return const [Color(0xFF121214)];
    case 'White':
    case 'White Background':
      return const [Color(0xFFF4F4F2)];
    case 'Grey':
      return const [Color(0xFF7D8186)];
    case 'Red':
      return const [Color(0xFFEB0A1E)];
    case 'Black & Grey':
      return const [Color(0xFF121214), Color(0xFF7D8186)];
    case 'Red & White':
      return const [Color(0xFFEB0A1E), Color(0xFFF4F4F2)];
    default:
      return const [Color(0xFF3A3A3F)];
  }
}

class Outlet {
  const Outlet(this.no, this.name, this.city);
  final int no;
  final String name;
  final String city;
}

const outlets = <Outlet>[
  Outlet(1, 'GR Garage by Auto2000', 'Jakarta Utara'),
  Outlet(2, 'Astrido Toyota Kelapa Gading II', 'Jakarta Utara'),
  Outlet(3, 'Daya Toyota Cakung', 'Jakarta Timur'),
  Outlet(4, 'Tunas Toyota Pecenongan', 'Jakarta Pusat'),
  Outlet(5, 'Astrido Toyota Pondok Indah', 'Jakarta Selatan'),
  Outlet(6, 'AUTO2000 Tebet Saharjo', 'Jakarta Selatan'),
  Outlet(7, 'Plaza Toyota Tendean', 'Jakarta Selatan'),
  Outlet(8, 'Tunas Toyota Pasar Minggu', 'Jakarta Selatan'),
  Outlet(9, 'AUTO2000 BSD City', 'Tangerang Selatan'),
  Outlet(10, 'Plaza Toyota Serpong', 'Tangerang Selatan'),
  Outlet(11, 'Selamat Toyota Sukabumi', 'Sukabumi'),
  Outlet(12, 'Duta Cendana Mobilindo', 'Cianjur'),
  Outlet(13, 'AUTO2000 Setiabudi', 'Bandung'),
  Outlet(14, 'Nasmoco Siliwangi', 'Semarang'),
  Outlet(15, 'Arina Parama Jaya', 'Gresik'),
  Outlet(16, 'AUTO2000 Basuki Rachmat', 'Surabaya'),
  Outlet(17, 'Asri Motor Taman', 'Sidoarjo'),
  Outlet(18, 'Kartika Sari Motor', 'Malang'),
  Outlet(19, 'Agung Toyota Kuta', 'Kuta'),
  Outlet(20, 'Krida Toyota', 'Mataram'),
  Outlet(21, 'Dunia Barusa Banda Aceh', 'Banda Aceh'),
  Outlet(22, 'AUTO2000 Sisingamangaraja', 'Medan'),
  Outlet(23, 'Deltamas Surya Indah Mulia', 'Medan'),
  Outlet(24, 'Perintis Perkasa Gagak Hitam', 'Medan'),
  Outlet(25, 'Agung Toyota Pekanbaru IV (Harapan Raya)', 'Pekanbaru'),
  Outlet(26, 'Agung Toyota Batam Center', 'Batam'),
  Outlet(27, 'Anzon Toyota Pontianak', 'Pontianak'),
  Outlet(28, 'Kalla Toyota Urip Sumoharjo', 'Makassar'),
  Outlet(29, 'Hasjrat Toyota Manado Tendean', 'Manado'),
];
