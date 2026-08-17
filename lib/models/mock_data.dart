import 'package:flutter/material.dart';
import 'product.dart';

class MockData {
  MockData._();

  static const List<Map<String, dynamic>> categoryItems = [
    {'name': 'Lifestyle', 'icon': Icons.flash_on_rounded},
    {'name': 'Basketball', 'icon': Icons.sports_basketball_outlined},
    {'name': 'Running', 'icon': Icons.directions_run_rounded},
    {'name': 'Training', 'icon': Icons.fitness_center_rounded},
    {'name': 'Outdoor', 'icon': Icons.terrain_rounded},
  ];

  static const List<String> categories = [
    'Lifestyle',
    'Basketball',
    'Running',
    'Training',
    'Outdoor',
  ];

  static const List<String> brands = [
    'All Brands',
    'Nike',
    'Jordan',
    'Adidas',
    'New Balance',
  ];

  static const List<String> recentSearches = [
    'Air Max Pre-Day',
    'Creter Impact',
    'Air Max 90',
    'Space Hippie',
  ];

  static const List<String> popularSearches = [
    'Men\'s Shoes',
    'Running shoes',
    'Air Max',
    'Crater',
    'Jordan',
  ];

  static final List<Product> products = [
    Product(
      id: 'prod_preday',
      name: 'Air Max Pre-Day',
      brand: 'Nike',
      price: 137.50,
      originalPrice: 155.00,
      isSale: false,
      isNew: true,
      rating: 5.0,
      reviewCount: 1120,
      category: 'Lifestyle',
      description:
          'Taking the classic look of heritage Nike Running into a new realm, the Nike Air Max Pre-Day brings you a fast-paced look that\'s ready for today\'s world. Made with recycled materials, it combines the retro track aesthetic with a new Air window that energizes the look and feels unbelievably soft.',
      specs: {
        'Material': 'Sustainable recycled textile & soft synthetic suede',
        'Upper': 'Deconstructed upper with iconic large retro Swoosh',
        'Sole': 'Updated rubber Waffle sole with visible Air unit',
        'Fit': 'True to size with streamlined low-cut padded collar',
        'Country': 'Vietnam',
      },
      images: [
        'assets/images/air_max_preday_volt.png',
        'assets/images/air_max_preday_terracotta.png',
        'assets/images/air_max_preday_obsidian.png',
      ],
      availableColors: [
        ProductColor(name: 'Volt Lime', color: Color(0xFFC4E822)),
        ProductColor(name: 'Terracotta Red', color: Color(0xFFE85836)),
        ProductColor(name: 'Obsidian Grey', color: Color(0xFF161312)),
      ],
      availableSizes: [40, 41, 42, 43, 45, 46],
      outOfStockSizes: [45],
    ),
    Product(
      id: 'prod_crater',
      name: 'Creter Impact',
      brand: 'Nike',
      price: 99.56,
      originalPrice: 115.00,
      isSale: true,
      isNew: true,
      rating: 4.9,
      reviewCount: 840,
      category: 'Lifestyle',
      description:
          'Nike Crater Impact is part of our sustainability journey to transform trash into shoes that tread a little lighter. Made with at least 25% recycled material by weight, it brings unique design choices that reduce waste when compared with traditional methods.',
      specs: {
        'Material': 'Track-inspired silhouette with straight-edged overlays',
        'Upper': 'Breathable mesh upper with stitched webbing accents',
        'Sole': 'Lifted Crater foam midsole made from 12% recycled content',
        'Fit': 'Comfortable standard width with plush low collar',
        'Country': 'Indonesia',
      },
      images: [
        'assets/images/crater_impact_white.png',
        'assets/images/crater_impact_orange.png',
        'assets/images/crater_impact_obsidian.png',
      ],
      availableColors: [
        ProductColor(name: 'Summit White', color: Color(0xFFDFDFDF)),
        ProductColor(name: 'Terracotta Orange', color: Color(0xFFE85836)),
        ProductColor(name: 'Dark Obsidian', color: Color(0xFF161312)),
      ],
      availableSizes: [39, 40, 41, 42, 43, 44, 45],
      outOfStockSizes: [],
    ),
    Product(
      id: 'prod_airmax90',
      name: 'Air Max 90 Terracotta',
      brand: 'Nike',
      price: 130.00,
      originalPrice: 160.00,
      isSale: true,
      isNew: false,
      rating: 4.95,
      reviewCount: 1240,
      category: 'Lifestyle',
      description:
          'Nothing as fly, nothing as proven. The Nike Air Max 90 stays true to its OG running roots with the iconic Waffle sole, stitched overlays and classic TPU accents.',
      specs: {
        'Material': 'Stitched leather overlays and molded TPU accents',
        'Upper': 'Padded low-top collar that looks sleek and feels great',
        'Sole': 'Max Air unit in heel with rubber Waffle outsole',
        'Fit': 'True to size',
        'Country': 'Vietnam',
      },
      images: [
        'assets/images/air_max_90_terracotta.png',
        'assets/images/air_max_90_sand.png',
        'assets/images/air_max_90_black.png',
      ],
      availableColors: [
        ProductColor(name: 'Terracotta Orange', color: Color(0xFFE85836)),
        ProductColor(name: 'Sand Dune', color: Color(0xFFA98B73)),
        ProductColor(name: 'Midnight Black', color: Color(0xFF161312)),
      ],
      availableSizes: [39, 40, 41, 42, 43, 44],
      outOfStockSizes: [],
    ),
    Product(
      id: 'prod_spacehippie',
      name: 'Space Hippie 04',
      brand: 'Nike',
      price: 130.00,
      originalPrice: null,
      isSale: false,
      isNew: true,
      rating: 4.85,
      reviewCount: 460,
      category: 'Running',
      description:
          'Space Hippie is an exploratory footwear collection inspired by life on Mars. From the upper to the outsole, Space Hippie 04 is made with at least 25% recycled material by weight.',
      specs: {
        'Material': 'Space Waste Yarn upper made from recycled plastic bottles',
        'Upper': 'Lightweight and stretchy Flyknit construction',
        'Sole': 'Crater Foam midsole combining Nike Grind with foam blends',
        'Fit': 'Snug sock-like fit',
        'Country': 'Vietnam',
      },
      images: [
        'assets/images/space_hippie_orange.png',
        'assets/images/space_hippie_black.png',
        'assets/images/space_hippie_blue.png',
      ],
      availableColors: [
        ProductColor(name: 'Orange Volt', color: Color(0xFFE85836)),
        ProductColor(name: 'Midnight Black', color: Color(0xFF161312)),
        ProductColor(name: 'Royal Cobalt', color: Color(0xFF2B5B84)),
      ],
      availableSizes: [40, 41, 42, 43, 44, 45],
      outOfStockSizes: [40],
    ),
    Product(
      id: 'prod_blazer',
      name: 'Blazer Mid 77 Vintage',
      brand: 'Nike',
      price: 105.00,
      originalPrice: null,
      isSale: false,
      isNew: false,
      rating: 4.88,
      reviewCount: 910,
      category: 'Basketball',
      description:
          'In the \'70s, Nike was the new shoe on the block. The Nike Blazer Mid \'77 Vintage harnesses the old-school look of Nike basketball with a vintage midsole finish.',
      specs: {
        'Material': 'Leather and synthetic upper maintains the classic look',
        'Upper': 'Exposed foam tongue provides a retro feel',
        'Sole': 'Solid-rubber outsole with herringbone pattern for traction',
        'Fit': 'Snug retro court fit',
        'Country': 'Indonesia',
      },
      images: [
        'assets/images/blazer_mid_white.png',
        'assets/images/blazer_mid_red.png',
        'assets/images/blazer_mid_navy.png',
      ],
      availableColors: [
        ProductColor(name: 'White / Black Swoosh', color: Color(0xFFDFDFDF)),
        ProductColor(name: 'Terracotta Team Red', color: Color(0xFFE85836)),
        ProductColor(name: 'Court Blue', color: Color(0xFF254B73)),
      ],
      availableSizes: [39, 40, 41, 42, 43, 44, 45, 46],
      outOfStockSizes: [],
    ),
    Product(
      id: 'prod_pegasus',
      name: 'Air Zoom Pegasus 38',
      brand: 'Nike',
      price: 120.00,
      originalPrice: 140.00,
      isSale: true,
      isNew: false,
      rating: 4.92,
      reviewCount: 670,
      category: 'Running',
      description:
          'Your workhorse with wings returns. The Nike Air Zoom Pegasus 38 continues to put a spring in your step, using the same responsive React foam as its predecessor.',
      specs: {
        'Material': 'Engineered sandwich mesh upper',
        'Upper': 'Midfoot webbing for a secure snug lockdown',
        'Sole': 'Nike React foam with forefoot Zoom Air unit',
        'Fit': 'Wider toe box for enhanced running comfort',
        'Country': 'Vietnam',
      },
      images: [
        'assets/images/pegasus_crimson.png',
        'assets/images/pegasus_black.png',
        'assets/images/pegasus_teal.png',
      ],
      availableColors: [
        ProductColor(name: 'Crimson Tint', color: Color(0xFFE85836)),
        ProductColor(name: 'Pure Black', color: Color(0xFF161312)),
        ProductColor(name: 'Emerald Teal', color: Color(0xFF1D6F60)),
      ],
      availableSizes: [39, 40, 41, 42, 43, 44, 45],
      outOfStockSizes: [],
    ),
  ];

  static const Address initialAddress = Address(
    id: 'addr_1',
    name: 'Munib Tariq',
    phone: '+1 (555) 234-8901',
    street: '742 Evergreen Terrace, Suite 4B',
    city: 'San Francisco, CA',
    postalCode: '94107',
    isDefault: true,
  );

  static final UserProfile initialProfile = UserProfile(
    name: 'Munib',
    email: 'munib.designer@nws.studio',
    avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=400&q=80',
    addresses: [initialAddress],
    paymentMethods: [
      'Apple Pay (Default)',
      'Visa ending in •••• 4242',
      'Mastercard ending in •••• 8819',
    ],
  );

  static final List<Order> initialOrders = [
    Order(
      id: 'NWS10248',
      items: [
        CartItem(
          product: products[0],
          selectedColor: products[0].availableColors[0],
          selectedSize: 42,
          quantity: 1,
        ),
      ],
      subtotal: 137.50,
      shippingFee: 10.0,
      discount: 0.0,
      total: 147.50,
      status: OrderStatus.shipped,
      shippingAddress: initialAddress,
      paymentMethod: 'Apple Pay',
      trackingNumber: 'NWS-TRK-9821739',
      carrier: 'FedEx Express Sneaker Priority',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      estimatedDelivery: 'Aug 20–22',
    ),
  ];
}
