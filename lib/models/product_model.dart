import 'package:cloud_firestore/cloud_firestore.dart';

/// Product data model for Firestore.
class ProductModel {
  final String id;
  final String userId;
  final String productName;
  final String serialNumber;
  final String category;
  final String qrCode;
  final DateTime purchaseDate;
  final DateTime expiryDate;
  final String status;
  final DateTime registeredAt;

  ProductModel({
    required this.id,
    required this.userId,
    required this.productName,
    required this.serialNumber,
    required this.category,
    required this.qrCode,
    required this.purchaseDate,
    required this.expiryDate,
    required this.status,
    required this.registeredAt,
  });

  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProductModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      productName: data['productName'] ?? '',
      serialNumber: data['serialNumber'] ?? '',
      category: data['category'] ?? '',
      qrCode: data['qrCode'] ?? '',
      purchaseDate:
          (data['purchaseDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      expiryDate:
          (data['expiryDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      status: data['status'] ?? 'registered',
      registeredAt:
          (data['registeredAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'productName': productName,
      'serialNumber': serialNumber,
      'category': category,
      'qrCode': qrCode,
      'purchaseDate': Timestamp.fromDate(purchaseDate),
      'expiryDate': Timestamp.fromDate(expiryDate),
      'status': status,
      'registeredAt': Timestamp.fromDate(registeredAt),
    };
  }

  /// Days remaining until expiry.
  int get daysUntilExpiry => expiryDate.difference(DateTime.now()).inDays;

  /// Whether the product warranty has expired.
  bool get isExpired => DateTime.now().isAfter(expiryDate);

  /// Whether expiry is within 30 days.
  bool get isExpiringSoon => !isExpired && daysUntilExpiry <= 30;

  ProductModel copyWith({
    String? id,
    String? userId,
    String? productName,
    String? serialNumber,
    String? category,
    String? qrCode,
    DateTime? purchaseDate,
    DateTime? expiryDate,
    String? status,
    DateTime? registeredAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      productName: productName ?? this.productName,
      serialNumber: serialNumber ?? this.serialNumber,
      category: category ?? this.category,
      qrCode: qrCode ?? this.qrCode,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      expiryDate: expiryDate ?? this.expiryDate,
      status: status ?? this.status,
      registeredAt: registeredAt ?? this.registeredAt,
    );
  }
}
