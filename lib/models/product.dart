import 'package:flutter/material.dart';

class ProductColor {
  final String name;
  final Color color;

  const ProductColor({
    required this.name,
    required this.color,
  });
}

class Product {
  final String id;
  final String name;
  final String brand;
  final double price;
  final double? originalPrice;
  final bool isSale;
  final bool isNew;
  final bool isOutOfStock;
  final double rating;
  final int reviewCount;
  final String category;
  final String description;
  final Map<String, String> specs;
  final List<String> images;
  final List<ProductColor> availableColors;
  final List<int> availableSizes;
  final List<int> outOfStockSizes;

  const Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    this.originalPrice,
    this.isSale = false,
    this.isNew = false,
    this.isOutOfStock = false,
    required this.rating,
    required this.reviewCount,
    required this.category,
    required this.description,
    required this.specs,
    required this.images,
    required this.availableColors,
    required this.availableSizes,
    this.outOfStockSizes = const [],
  });

  int get discountPercentage {
    if (originalPrice == null || originalPrice! <= price) return 0;
    return (((originalPrice! - price) / originalPrice!) * 100).round();
  }
}

class CartItem {
  final Product product;
  final ProductColor selectedColor;
  final int selectedSize;
  int quantity;

  CartItem({
    required this.product,
    required this.selectedColor,
    required this.selectedSize,
    this.quantity = 1,
  });

  double get totalPrice => product.price * quantity;
}

enum OrderStatus {
  placed('Order Placed', 'Your order was received and logged.'),
  processing('Processing', 'Your footwear is being inspected and packed.'),
  shipped('Shipped', 'Handed over to carrier courier.'),
  outForDelivery('Out for Delivery', 'Package is with your local courier driver.'),
  delivered('Delivered', 'Package safely delivered to your doorstep.');

  final String title;
  final String subtitle;
  const OrderStatus(this.title, this.subtitle);
}

class Address {
  final String id;
  final String name;
  final String phone;
  final String street;
  final String city;
  final String postalCode;
  final bool isDefault;

  const Address({
    required this.id,
    required this.name,
    required this.phone,
    required this.street,
    required this.city,
    required this.postalCode,
    this.isDefault = false,
  });

  String get formatted => '$street, $city $postalCode';
}

class Order {
  final String id;
  final List<CartItem> items;
  final double subtotal;
  final double shippingFee;
  final double discount;
  final double total;
  final OrderStatus status;
  final Address shippingAddress;
  final String paymentMethod;
  final String trackingNumber;
  final String carrier;
  final DateTime createdAt;
  final String estimatedDelivery;

  const Order({
    required this.id,
    required this.items,
    required this.subtotal,
    required this.shippingFee,
    required this.discount,
    required this.total,
    required this.status,
    required this.shippingAddress,
    required this.paymentMethod,
    required this.trackingNumber,
    required this.carrier,
    required this.createdAt,
    required this.estimatedDelivery,
  });
}

class UserProfile {
  final String name;
  final String email;
  final String avatarUrl;
  final List<Address> addresses;
  final List<String> paymentMethods;
  final bool notificationsEnabled;
  final String language;
  final String currency;

  const UserProfile({
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.addresses,
    required this.paymentMethods,
    this.notificationsEnabled = true,
    this.language = 'English (US)',
    this.currency = 'USD (\$)',
  });

  UserProfile copyWith({
    String? name,
    String? email,
    String? avatarUrl,
    List<Address>? addresses,
    List<String>? paymentMethods,
    bool? notificationsEnabled,
    String? language,
    String? currency,
  }) {
    return UserProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      addresses: addresses ?? this.addresses,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      language: language ?? this.language,
      currency: currency ?? this.currency,
    );
  }
}
