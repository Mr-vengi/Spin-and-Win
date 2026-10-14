class GiftOrder {
  const GiftOrder({
    required this.id,
    required this.productId,
    required this.createdAt,
    this.statusIndex = 0,
  });

  final String id;
  final String productId;
  final DateTime createdAt;
  final int statusIndex;

  static const statuses = ['Processing', 'Shipped', 'Delivered'];

  String get status => statuses[statusIndex.clamp(0, statuses.length - 1)];

  GiftOrder copyWith({int? statusIndex}) {
    return GiftOrder(
      id: id,
      productId: productId,
      createdAt: createdAt,
      statusIndex: statusIndex ?? this.statusIndex,
    );
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'productId': productId,
    'createdAt': createdAt.toIso8601String(),
    'statusIndex': statusIndex,
  };

  factory GiftOrder.fromJson(Map<String, dynamic> json) => GiftOrder(
    id: json['id'] as String,
    productId: json['productId'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String),
    statusIndex: (json['statusIndex'] as num?)?.toInt() ?? 0,
  );
}
