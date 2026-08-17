import 'package:flutter/material.dart';
import 'product.dart';

class MockData {
  MockData._();

  static const List<String> categories = [
    'All',
    'Sneakers',
    'Running',
    'Lifestyle',
    'Training',
    'Boots',
  ];

  static const List<String> brands = [
    'All Brands',
    'Nike',
    'Adidas',
    'New Balance',
    'Puma',
    'Reebok',
    'Salomon',
  ];

  static const List<String> recentSearches = [
    'Nike Air Max',
    'Adidas Samba',
    'New Balance 990',
    'Jordan 1 Retro',
  ];

  static const List<String> popularSearches = [
    'Running shoes',
    'Sneakers',
    'Air Max',
    'Jordan',
    'Chunky soles',
    'Terracotta',
  ];

  static final List<Product> products = [
    Product(
      id: 'prod_1',
      name: 'Air Max 90 Terracotta',
      brand: 'Nike',
      price: 130.0,
      originalPrice: 160.0,
      isSale: true,
      isNew: false,
      rating: 4.9,
      reviewCount: 184,
      category: 'Sneakers',
      description:
          'A timeless silhouette redefined in rich terracotta and obsidian tones. Crafted with stitched overlays and molded plastic accents on the heel and eyestays, keeping the iconic 90s heritage alive with ultra-plush Max Air cushioning.',
      specs: {
        'Material': 'Full-grain leather with breathable ripstop mesh',
        'Upper': 'Layered suede and engineered synthetic canvas',
        'Sole': 'Heritage Waffle rubber sole with visible Air unit',
        'Fit': 'True to size with padded low-cut collar',
        'Country': 'Vietnam',
      },
      images: [
        'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=1000&q=80',
        'https://images.unsplash.com/photo-1552346154-21d32810aba3?auto=format&fit=crop&w=1000&q=80',
        'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?auto=format&fit=crop&w=1000&q=80',
      ],
      availableColors: [
        ProductColor(name: 'Terracotta Red', color: Color(0xFFBB2C1A)),
        ProductColor(name: 'Obsidian Black', color: Color(0xFF0C0706)),
        ProductColor(name: 'Desert Sand', color: Color(0xFFA98B73)),
      ],
      availableSizes: [39, 40, 41, 42, 43, 44, 45],
      outOfStockSizes: [45],
    ),
    Product(
      id: 'prod_2',
      name: 'Air Jordan 1 High OG',
      brand: 'Nike',
      price: 180.0,
      originalPrice: 200.0,
      isSale: false,
      isNew: true,
      rating: 4.95,
      reviewCount: 312,
      category: 'Sneakers',
      description:
          'The sneaker that started it all. High-cut profile in premium tumbled leather with signature Wings logo and encapsulated Air-Sole unit for lightweight comfort and unmatched street presence.',
      specs: {
        'Material': '100% Genuine tumbled leather',
        'Upper': 'High-top collar with supportive padding',
        'Sole': 'Solid rubber cupsole with deep flex grooves',
        'Fit': 'Snug court fit. Consider half size up for wide feet',
        'Country': 'Indonesia',
      },
      images: [
        'https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?auto=format&fit=crop&w=1000&q=80',
        'https://images.unsplash.com/photo-1597045566677-8cf032ed6634?auto=format&fit=crop&w=1000&q=80',
        'https://images.unsplash.com/photo-1514989940743-46e30018fa1b?auto=format&fit=crop&w=1000&q=80',
      ],
      availableColors: [
        ProductColor(name: 'Classic Black/Red', color: Color(0xFF5C180E)),
        ProductColor(name: 'Shadow Grey', color: Color(0xFF615A56)),
        ProductColor(name: 'Pure Neutral', color: Color(0xFFDFDFDF)),
      ],
      availableSizes: [40, 41, 42, 43, 44, 45, 46],
      outOfStockSizes: [40],
    ),
    Product(
      id: 'prod_3',
      name: 'Samba OG Editorial',
      brand: 'Adidas',
      price: 110.0,
      originalPrice: null,
      isSale: false,
      isNew: true,
      rating: 4.8,
      reviewCount: 98,
      category: 'Lifestyle',
      description:
          'Born on the pitch, adopted by subcultures worldwide. The Samba OG pairs supple leather uppers with a suede T-toe overlay and iconic gum rubber sole.',
      specs: {
        'Material': 'Smooth leather upper with suede T-toe',
        'Upper': 'Low-profile silhouette with serrated 3-Stripes',
        'Sole': 'Textured gum rubber cupsole',
        'Fit': 'True to size standard width',
        'Country': 'Vietnam',
      },
      images: [
        'https://images.unsplash.com/photo-1587563871167-1ee9c731aefb?auto=format&fit=crop&w=1000&q=80',
        'https://images.unsplash.com/photo-1518002171953-a080ee817e1f?auto=format&fit=crop&w=1000&q=80',
      ],
      availableColors: [
        ProductColor(name: 'Chalk White', color: Color(0xFFF3F0EA)),
        ProductColor(name: 'Core Black', color: Color(0xFF0C0706)),
        ProductColor(name: 'Blush Tan', color: Color(0xFFCCB9B4)),
      ],
      availableSizes: [38, 39, 40, 41, 42, 43, 44],
      outOfStockSizes: [],
    ),
    Product(
      id: 'prod_4',
      name: 'Made in USA 990v5',
      brand: 'New Balance',
      price: 195.0,
      originalPrice: 220.0,
      isSale: true,
      isNew: false,
      rating: 4.88,
      reviewCount: 240,
      category: 'Lifestyle',
      description:
          'Blended with timeless craftsmanship and modern cushioning. Features an ENCAP midsole support system that combines lightweight foam with a durable polyurethane rim.',
      specs: {
        'Material': 'Pigskin suede and breathable mesh',
        'Upper': 'Dual-density collar foam with TPU power strap',
        'Sole': 'Blown rubber outsole with Ndurance heel',
        'Fit': 'True to size with spacious toe box',
        'Country': 'United States',
      },
      images: [
        'https://images.unsplash.com/photo-1539185441755-769473a23570?auto=format&fit=crop&w=1000&q=80',
        'https://images.unsplash.com/photo-1608231387042-66d1773070a5?auto=format&fit=crop&w=1000&q=80',
      ],
      availableColors: [
        ProductColor(name: 'Heritage Grey', color: Color(0xFF615A56)),
        ProductColor(name: 'Sand Dune', color: Color(0xFFA98B73)),
        ProductColor(name: 'Midnight Black', color: Color(0xFF0C0706)),
      ],
      availableSizes: [39, 40, 41, 42, 43, 44, 45, 46],
      outOfStockSizes: [39, 46],
    ),
    Product(
      id: 'prod_5',
      name: 'ZoomX Vaporfly 3',
      brand: 'Nike',
      price: 250.0,
      originalPrice: null,
      isSale: false,
      isNew: true,
      rating: 4.92,
      reviewCount: 88,
      category: 'Running',
      description:
          'Catch \'em if you can. Built for speed from 10Ks to marathons, featuring an ultra-responsive full-length carbon fiber Flyplate and ZoomX superfoam.',
      specs: {
        'Material': 'Flyknit engineered micro-mesh',
        'Upper': 'Asymmetrical lacing and thin heel pod',
        'Sole': 'ZoomX foam with integrated Carbon Flyplate',
        'Fit': 'Racer fit; race-ready snug lock-in',
        'Country': 'China',
      },
      images: [
        'https://images.unsplash.com/photo-1605348532760-6753d2c43329?auto=format&fit=crop&w=1000&q=80',
        'https://images.unsplash.com/photo-1582588678413-dbf45f4823e9?auto=format&fit=crop&w=1000&q=80',
      ],
      availableColors: [
        ProductColor(name: 'Solar Red', color: Color(0xFFBB2C1A)),
        ProductColor(name: 'Phantom Bone', color: Color(0xFFDFDFDF)),
      ],
      availableSizes: [40, 41, 42, 43, 44, 45],
      outOfStockSizes: [],
    ),
    Product(
      id: 'prod_6',
      name: 'XT-6 Advanced Trail',
      brand: 'Salomon',
      price: 210.0,
      originalPrice: 230.0,
      isSale: false,
      isNew: false,
      rating: 4.86,
      reviewCount: 119,
      category: 'Boots',
      description:
          'Originally launched in 2013 for ultra-distance runners under harsh conditions. Now refreshed with high-fashion color palettes while retaining the ACS chassis and Quicklace system.',
      specs: {
        'Material': 'Abrasion-resistant TPU film and mesh',
        'Upper': 'Sensifit cradling with Quicklace harness',
        'Sole': 'Mud Contagrip with Agile Chassis System (ACS)',
        'Fit': 'Performance snug. High arch support',
        'Country': 'Vietnam',
      },
      images: [
        'https://images.unsplash.com/photo-1575537302964-96cd47c06b1b?auto=format&fit=crop&w=1000&q=80',
        'https://images.unsplash.com/photo-1511556532299-8f662fc26c06?auto=format&fit=crop&w=1000&q=80',
      ],
      availableColors: [
        ProductColor(name: 'Safari Sand', color: Color(0xFFA98B73)),
        ProductColor(name: 'Stealth Black', color: Color(0xFF0C0706)),
        ProductColor(name: 'Terracotta Rust', color: Color(0xFF5C180E)),
      ],
      availableSizes: [39, 40, 41, 42, 43, 44, 45],
      outOfStockSizes: [44],
    ),
    Product(
      id: 'prod_7',
      name: 'Suede Classic XXI',
      brand: 'Puma',
      price: 75.0,
      originalPrice: 90.0,
      isSale: true,
      isNew: false,
      rating: 4.75,
      reviewCount: 165,
      category: 'Lifestyle',
      description:
          'The Suede hit the scene in 1968 and has been changing the game ever since. Full suede upper with modern comfort improvements including a cushioned sockliner.',
      specs: {
        'Material': '100% Premium split suede',
        'Upper': 'PUMA Formstrip with debossed gold foil branding',
        'Sole': 'Durable textured rubber outsole',
        'Fit': 'Regular width classic fit',
        'Country': 'Cambodia',
      },
      images: [
        'https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?auto=format&fit=crop&w=1000&q=80',
        'https://images.unsplash.com/photo-1600185365926-3a2ce3cdb9eb?auto=format&fit=crop&w=1000&q=80',
      ],
      availableColors: [
        ProductColor(name: 'Earthy Clay', color: Color(0xFFA98B73)),
        ProductColor(name: 'Dark Mahogany', color: Color(0xFF5C180E)),
        ProductColor(name: 'Onyx Black', color: Color(0xFF0C0706)),
      ],
      availableSizes: [38, 39, 40, 41, 42, 43, 44, 45],
      outOfStockSizes: [],
    ),
    Product(
      id: 'prod_8',
      name: 'Club C 85 Vintage',
      brand: 'Reebok',
      price: 85.0,
      originalPrice: null,
      isSale: false,
      isNew: false,
      rating: 4.82,
      reviewCount: 147,
      category: 'Training',
      description:
          'Clean court-inspired style born in 1985. Garment leather upper delivers buttery soft comfort, while the vintage off-white midsole gives an authentic retro finish.',
      specs: {
        'Material': 'Garment leather upper with terry lining',
        'Upper': 'Low-cut profile for mobility and sleek stance',
        'Sole': 'High-abrasion rubber outsole',
        'Fit': 'True to size comfortable fit',
        'Country': 'Vietnam',
      },
      images: [
        'https://images.unsplash.com/photo-1525966222134-fcfa99b8ae77?auto=format&fit=crop&w=1000&q=80',
        'https://images.unsplash.com/photo-1560769629-975ec94e6a86?auto=format&fit=crop&w=1000&q=80',
      ],
      availableColors: [
        ProductColor(name: 'Chalk Cream', color: Color(0xFFF3F0EA)),
        ProductColor(name: 'Forest Maroon', color: Color(0xFF5C180E)),
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
    name: 'Irtaza',
    email: 'irtaza.designer@nws.studio',
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
        CartItem(
          product: products[2],
          selectedColor: products[2].availableColors[0],
          selectedSize: 42,
          quantity: 1,
        ),
      ],
      subtotal: 240.0,
      shippingFee: 10.0,
      discount: 20.0,
      total: 230.0,
      status: OrderStatus.shipped,
      shippingAddress: initialAddress,
      paymentMethod: 'Apple Pay',
      trackingNumber: 'NWS-TRK-9821739',
      carrier: 'FedEx Express Sneaker Priority',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      estimatedDelivery: 'Aug 20–22',
    ),
    Order(
      id: 'NWS10195',
      items: [
        CartItem(
          product: products[1],
          selectedColor: products[1].availableColors[0],
          selectedSize: 43,
          quantity: 1,
        ),
      ],
      subtotal: 180.0,
      shippingFee: 0.0,
      discount: 0.0,
      total: 180.0,
      status: OrderStatus.delivered,
      shippingAddress: initialAddress,
      paymentMethod: 'Visa •••• 4242',
      trackingNumber: 'NWS-TRK-8726190',
      carrier: 'DHL Express Luxury Drop',
      createdAt: DateTime.now().subtract(const Duration(days: 14)),
      estimatedDelivery: 'Aug 04',
    ),
  ];
}
