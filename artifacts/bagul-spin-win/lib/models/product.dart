import 'package:flutter/material.dart';

class Product {
  const Product({
    required this.id,
    required this.name,
    required this.shortName,
    required this.icon,
    this.isRetry = false,
  });

  final String id;
  final String name;
  final String shortName;
  final IconData icon;
  final bool isRetry;

  static const wheelProducts = <Product>[
    Product(id: 'pen', name: 'Premium Pen', shortName: 'PEN', icon: Icons.edit),
    Product(
      id: 'tshirt',
      name: 'Bagul T-Shirt',
      shortName: 'T-SHIRT',
      icon: Icons.checkroom,
    ),
    Product(
      id: 'phone',
      name: 'Smartphone',
      shortName: 'PHONE',
      icon: Icons.smartphone,
    ),
    Product(
      id: 'try-again-1',
      name: 'Try Again',
      shortName: 'TRY AGAIN',
      icon: Icons.refresh,
      isRetry: true,
    ),
    Product(
      id: 'headphones',
      name: 'Wireless Headphones',
      shortName: 'AUDIO',
      icon: Icons.headphones,
    ),
    Product(
      id: 'gift-box',
      name: 'Mystery Gift Box',
      shortName: 'GIFT BOX',
      icon: Icons.redeem,
    ),
    Product(
      id: 'gift-card',
      name: 'Shopping Gift Card',
      shortName: 'GIFT CARD',
      icon: Icons.card_giftcard,
    ),
    Product(
      id: 'try-again-2',
      name: 'Try Again',
      shortName: 'TRY AGAIN',
      icon: Icons.refresh,
      isRetry: true,
    ),
  ];

  static Product byId(String id) {
    return wheelProducts.firstWhere(
      (product) => product.id == id,
      orElse: () => wheelProducts.first,
    );
  }
}
