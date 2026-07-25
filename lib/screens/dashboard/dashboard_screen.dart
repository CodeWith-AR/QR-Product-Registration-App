import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_text_styles.dart';
import '../../models/product_model.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import '../../widgets/product_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthService();
    final firestore = FirestoreService();
    final userId = auth.currentUser?.uid ?? '';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Row(children: [
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(9)),
            child: const Icon(Icons.verified_rounded, size: 18, color: Colors.white),
          ),
          const SizedBox(width: 8),
          Text(AppConstants.appName, style: AppTextStyles.titleSm),
        ]),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Registered Products', style: AppTextStyles.headlineMd),
            const SizedBox(height: 4),
            Text('Manage your luxury assets and warranty status.',
              style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant)),
            const SizedBox(height: AppConstants.paddingLg),
            StreamBuilder<List<ProductModel>>(
              stream: firestore.getProducts(userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: Padding(
                    padding: EdgeInsets.all(48),
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Padding(
                    padding: const EdgeInsets.all(48),
                    child: Column(children: [
                      Icon(Icons.inventory_2_outlined, size: 64, color: AppColors.outline),
                      const SizedBox(height: 16),
                      Text('No products yet', style: AppTextStyles.titleSm.copyWith(color: AppColors.onSurfaceVariant)),
                      const SizedBox(height: 4),
                      Text('Scan a QR code to register your first product.',
                        style: AppTextStyles.bodyMd.copyWith(color: AppColors.outline), textAlign: TextAlign.center),
                    ]),
                  ));
                }
                return Column(
                  children: snapshot.data!.map((p) => Padding(
                    padding: const EdgeInsets.only(bottom: AppConstants.paddingSm),
                    child: ProductCard(product: p),
                  )).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
