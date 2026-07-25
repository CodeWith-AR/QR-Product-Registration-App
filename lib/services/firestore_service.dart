import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/constants/app_constants.dart';
import '../models/product_model.dart';
import '../models/user_model.dart';

/// Firestore service for CRUD operations on users and products.
class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ── Users ──

  /// Get user document by ID.
  Future<UserModel?> getUser(String uid) async {
    final doc =
        await _firestore.collection(AppConstants.usersCollection).doc(uid).get();
    if (doc.exists) {
      return UserModel.fromFirestore(doc);
    }
    return null;
  }

  /// Save or update user document.
  Future<void> saveUser(UserModel user) async {
    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(user.uid)
        .set(user.toFirestore(), SetOptions(merge: true));
  }

  // ── Products ──

  /// Add a new product.
  Future<String> addProduct(ProductModel product) async {
    final docRef = await _firestore
        .collection(AppConstants.productsCollection)
        .add(product.toFirestore());
    return docRef.id;
  }

  /// Get all products for a user.
  Stream<List<ProductModel>> getProducts(String userId) {
    return _firestore
        .collection(AppConstants.productsCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('registeredAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => ProductModel.fromFirestore(doc)).toList());
  }

  /// Get recent products for a user (limited).
  Stream<List<ProductModel>> getRecentProducts(String userId, {int limit = 3}) {
    return _firestore
        .collection(AppConstants.productsCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('registeredAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => ProductModel.fromFirestore(doc)).toList());
  }

  /// Get products expiring soon (within 30 days).
  Stream<List<ProductModel>> getExpiringSoonProducts(String userId) {
    final now = DateTime.now();
    final thirtyDaysLater = now.add(const Duration(days: 30));

    return _firestore
        .collection(AppConstants.productsCollection)
        .where('userId', isEqualTo: userId)
        .where('expiryDate', isGreaterThan: Timestamp.fromDate(now))
        .where('expiryDate',
            isLessThanOrEqualTo: Timestamp.fromDate(thirtyDaysLater))
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => ProductModel.fromFirestore(doc)).toList());
  }

  /// Update a product.
  Future<void> updateProduct(String productId, Map<String, dynamic> data) async {
    await _firestore
        .collection(AppConstants.productsCollection)
        .doc(productId)
        .update(data);
  }

  /// Delete a product.
  Future<void> deleteProduct(String productId) async {
    await _firestore
        .collection(AppConstants.productsCollection)
        .doc(productId)
        .delete();
  }

  /// Get total product count for a user.
  Future<int> getProductCount(String userId) async {
    final snapshot = await _firestore
        .collection(AppConstants.productsCollection)
        .where('userId', isEqualTo: userId)
        .count()
        .get();
    return snapshot.count ?? 0;
  }
}
