class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String unit;
  final ProductCategory category;
  final String sellerId;
  final String sellerName;
  final String sellerLocation;
  final List<String> imageUrls;
  final double rating;
  final int reviewCount;
  final int stockQuantity;
  final bool isOrganic;
  final DateTime harvestDate;
  final DateTime expiryDate;
  final ProductStatus status;
  final List<String> tags;
  final double discount;
  final String? certificationUrl;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.unit,
    required this.category,
    required this.sellerId,
    required this.sellerName,
    required this.sellerLocation,
    required this.imageUrls,
    this.rating = 0.0,
    this.reviewCount = 0,
    required this.stockQuantity,
    this.isOrganic = false,
    required this.harvestDate,
    required this.expiryDate,
    this.status = ProductStatus.available,
    this.tags = const [],
    this.discount = 0.0,
    this.certificationUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      unit: json['unit'],
      category: ProductCategory.values.firstWhere(
        (c) => c.name == json['category'],
        orElse: () => ProductCategory.vegetables,
      ),
      sellerId: json['sellerId'],
      sellerName: json['sellerName'],
      sellerLocation: json['sellerLocation'],
      imageUrls: List<String>.from(json['imageUrls']),
      rating: json['rating']?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] ?? 0,
      stockQuantity: json['stockQuantity'],
      isOrganic: json['isOrganic'] ?? false,
      harvestDate: DateTime.parse(json['harvestDate']),
      expiryDate: DateTime.parse(json['expiryDate']),
      status: ProductStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => ProductStatus.available,
      ),
      tags: List<String>.from(json['tags'] ?? []),
      discount: json['discount']?.toDouble() ?? 0.0,
      certificationUrl: json['certificationUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'unit': unit,
      'category': category.name,
      'sellerId': sellerId,
      'sellerName': sellerName,
      'sellerLocation': sellerLocation,
      'imageUrls': imageUrls,
      'rating': rating,
      'reviewCount': reviewCount,
      'stockQuantity': stockQuantity,
      'isOrganic': isOrganic,
      'harvestDate': harvestDate.toIso8601String(),
      'expiryDate': expiryDate.toIso8601String(),
      'status': status.name,
      'tags': tags,
      'discount': discount,
      'certificationUrl': certificationUrl,
    };
  }

  double get discountedPrice => price * (1 - discount / 100);
  
  bool get isExpiringSoon {
    final daysToExpiry = expiryDate.difference(DateTime.now()).inDays;
    return daysToExpiry <= 3;
  }

  bool get isFresh {
    final daysSinceHarvest = DateTime.now().difference(harvestDate).inDays;
    return daysSinceHarvest <= 2;
  }
}

enum ProductCategory {
  vegetables,
  fruits,
  grains,
  herbs,
  dairy,
  meat,
  seeds,
  tools,
  fertilizers,
  equipment,
}

enum ProductStatus {
  available,
  outOfStock,
  reserved,
  sold,
  expired,
}

class CartItem {
  final String id;
  final Product product;
  final int quantity;
  final DateTime addedAt;
  final String? notes;

  CartItem({
    required this.id,
    required this.product,
    required this.quantity,
    required this.addedAt,
    this.notes,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      product: Product.fromJson(json['product']),
      quantity: json['quantity'],
      addedAt: DateTime.parse(json['addedAt']),
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product': product.toJson(),
      'quantity': quantity,
      'addedAt': addedAt.toIso8601String(),
      'notes': notes,
    };
  }

  double get totalPrice => product.discountedPrice * quantity;
}

class Order {
  final String id;
  final String buyerId;
  final String buyerName;
  final List<CartItem> items;
  final double totalAmount;
  final double deliveryFee;
  final OrderStatus status;
  final DateTime orderDate;
  final DateTime? deliveryDate;
  final String deliveryAddress;
  final String? deliveryInstructions;
  final PaymentMethod paymentMethod;
  final PaymentStatus paymentStatus;
  final String? trackingNumber;
  final List<OrderUpdate> updates;

  Order({
    required this.id,
    required this.buyerId,
    required this.buyerName,
    required this.items,
    required this.totalAmount,
    this.deliveryFee = 0.0,
    this.status = OrderStatus.pending,
    required this.orderDate,
    this.deliveryDate,
    required this.deliveryAddress,
    this.deliveryInstructions,
    required this.paymentMethod,
    this.paymentStatus = PaymentStatus.pending,
    this.trackingNumber,
    this.updates = const [],
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      buyerId: json['buyerId'],
      buyerName: json['buyerName'],
      items: (json['items'] as List)
          .map((item) => CartItem.fromJson(item))
          .toList(),
      totalAmount: json['totalAmount'].toDouble(),
      deliveryFee: json['deliveryFee']?.toDouble() ?? 0.0,
      status: OrderStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => OrderStatus.pending,
      ),
      orderDate: DateTime.parse(json['orderDate']),
      deliveryDate: json['deliveryDate'] != null
          ? DateTime.parse(json['deliveryDate'])
          : null,
      deliveryAddress: json['deliveryAddress'],
      deliveryInstructions: json['deliveryInstructions'],
      paymentMethod: PaymentMethod.values.firstWhere(
        (p) => p.name == json['paymentMethod'],
        orElse: () => PaymentMethod.cash,
      ),
      paymentStatus: PaymentStatus.values.firstWhere(
        (p) => p.name == json['paymentStatus'],
        orElse: () => PaymentStatus.pending,
      ),
      trackingNumber: json['trackingNumber'],
      updates: (json['updates'] as List? ?? [])
          .map((update) => OrderUpdate.fromJson(update))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'buyerId': buyerId,
      'buyerName': buyerName,
      'items': items.map((item) => item.toJson()).toList(),
      'totalAmount': totalAmount,
      'deliveryFee': deliveryFee,
      'status': status.name,
      'orderDate': orderDate.toIso8601String(),
      'deliveryDate': deliveryDate?.toIso8601String(),
      'deliveryAddress': deliveryAddress,
      'deliveryInstructions': deliveryInstructions,
      'paymentMethod': paymentMethod.name,
      'paymentStatus': paymentStatus.name,
      'trackingNumber': trackingNumber,
      'updates': updates.map((update) => update.toJson()).toList(),
    };
  }

  double get grandTotal => totalAmount + deliveryFee;
}

enum OrderStatus {
  pending,
  confirmed,
  preparing,
  shipped,
  delivered,
  cancelled,
  returned,
}

enum PaymentMethod {
  cash,
  card,
  upi,
  netBanking,
  wallet,
}

enum PaymentStatus {
  pending,
  paid,
  failed,
  refunded,
}

class OrderUpdate {
  final String id;
  final OrderStatus status;
  final String message;
  final DateTime timestamp;
  final String? location;

  OrderUpdate({
    required this.id,
    required this.status,
    required this.message,
    required this.timestamp,
    this.location,
  });

  factory OrderUpdate.fromJson(Map<String, dynamic> json) {
    return OrderUpdate(
      id: json['id'],
      status: OrderStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => OrderStatus.pending,
      ),
      message: json['message'],
      timestamp: DateTime.parse(json['timestamp']),
      location: json['location'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status.name,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'location': location,
    };
  }
}

class Review {
  final String id;
  final String productId;
  final String buyerId;
  final String buyerName;
  final double rating;
  final String comment;
  final DateTime reviewDate;
  final List<String> imageUrls;
  final bool isVerifiedPurchase;

  Review({
    required this.id,
    required this.productId,
    required this.buyerId,
    required this.buyerName,
    required this.rating,
    required this.comment,
    required this.reviewDate,
    this.imageUrls = const [],
    this.isVerifiedPurchase = false,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      productId: json['productId'],
      buyerId: json['buyerId'],
      buyerName: json['buyerName'],
      rating: json['rating'].toDouble(),
      comment: json['comment'],
      reviewDate: DateTime.parse(json['reviewDate']),
      imageUrls: List<String>.from(json['imageUrls'] ?? []),
      isVerifiedPurchase: json['isVerifiedPurchase'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'buyerId': buyerId,
      'buyerName': buyerName,
      'rating': rating,
      'comment': comment,
      'reviewDate': reviewDate.toIso8601String(),
      'imageUrls': imageUrls,
      'isVerifiedPurchase': isVerifiedPurchase,
    };
  }
}

class Seller {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String location;
  final String address;
  final double rating;
  final int totalSales;
  final DateTime joinDate;
  final bool isVerified;
  final String? profileImageUrl;
  final String? description;
  final List<String> specialties;

  Seller({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.location,
    required this.address,
    this.rating = 0.0,
    this.totalSales = 0,
    required this.joinDate,
    this.isVerified = false,
    this.profileImageUrl,
    this.description,
    this.specialties = const [],
  });

  factory Seller.fromJson(Map<String, dynamic> json) {
    return Seller(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      location: json['location'],
      address: json['address'],
      rating: json['rating']?.toDouble() ?? 0.0,
      totalSales: json['totalSales'] ?? 0,
      joinDate: DateTime.parse(json['joinDate']),
      isVerified: json['isVerified'] ?? false,
      profileImageUrl: json['profileImageUrl'],
      description: json['description'],
      specialties: List<String>.from(json['specialties'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'location': location,
      'address': address,
      'rating': rating,
      'totalSales': totalSales,
      'joinDate': joinDate.toIso8601String(),
      'isVerified': isVerified,
      'profileImageUrl': profileImageUrl,
      'description': description,
      'specialties': specialties,
    };
  }
}
