import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_text_styles.dart';
import '../../models/product_model.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import '../../widgets/custom_bottom_nav.dart';
import '../../widgets/product_card.dart';

import '../scanner/qr_scanner_screen.dart';
import '../profile/profile_screen.dart';
import '../registration/product_registration_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    _HomeContent(),
    QrScannerScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _pages[_currentIndex],
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    final auth = AuthService();
    final firestore = FirestoreService();
    final userId = auth.currentUser?.uid ?? '';

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 36, height: 36,
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.verified_rounded, size: 20, color: Colors.white),
                          ),
                          const SizedBox(width: 10),
                          Text(AppConstants.appName, style: AppTextStyles.titleSm),
                        ],
                      ),
                      const SizedBox(height: AppConstants.paddingMd),
                      Text('Welcome back, ${auth.userName}', style: AppTextStyles.headlineMd),
                      const SizedBox(height: 4),
                      Text('Your collection is secure and up to date.',
                        style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingLg),

            // Last Registered Product
            StreamBuilder<List<ProductModel>>(
              stream: firestore.getRecentProducts(userId, limit: 1),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  final product = snapshot.data!.first;
                  return Container(
                    padding: const EdgeInsets.all(AppConstants.paddingMd),
                    decoration: BoxDecoration(
                      gradient: AppColors.splashGradient,
                      borderRadius: BorderRadius.circular(AppConstants.radiusLg),
                      boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 6))],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48, height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.inventory_2_rounded, color: Colors.white, size: 24),
                        ),
                        const SizedBox(width: AppConstants.paddingMd),
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(product.productName, style: AppTextStyles.titleXs.copyWith(color: Colors.white)),
                            const SizedBox(height: 2),
                            Text('Registered ${_timeAgo(product.registeredAt)}',
                              style: AppTextStyles.bodySm.copyWith(color: Colors.white.withValues(alpha: 0.8))),
                          ],
                        )),
                        const Icon(Icons.chevron_right_rounded, color: Colors.white70),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            const SizedBox(height: AppConstants.paddingMd),

            // Register Product Card
            GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProductRegistrationScreen())),
              child: Container(
                padding: const EdgeInsets.all(AppConstants.paddingMd),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppConstants.radiusLg),
                  border: Border.all(color: AppColors.outlineVariant, width: 0.5),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48, height: 48,
                      decoration: BoxDecoration(gradient: AppColors.cardGradient, borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Icons.add_circle_outline_rounded, color: AppColors.primary, size: 24),
                    ),
                    const SizedBox(width: AppConstants.paddingMd),
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Register Product', style: AppTextStyles.titleXs),
                        const SizedBox(height: 2),
                        Text('Add a new item to your vault', style: AppTextStyles.bodySm),
                      ],
                    )),
                    const Icon(Icons.chevron_right_rounded, color: AppColors.outline),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppConstants.paddingLg),

            // Recent Status
            Text('Recent Status', style: AppTextStyles.titleSm),
            const SizedBox(height: AppConstants.paddingMd),
            StreamBuilder<List<ProductModel>>(
              stream: firestore.getRecentProducts(userId, limit: 3),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(AppConstants.paddingXl),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppConstants.radiusLg),
                      border: Border.all(color: AppColors.outlineVariant, width: 0.5),
                    ),
                    child: Center(child: Column(children: [
                      Icon(Icons.inventory_2_outlined, size: 48, color: AppColors.outline),
                      const SizedBox(height: 8),
                      Text('No products registered yet', style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant)),
                    ])),
                  );
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

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 0) return '${diff.inDays} day${diff.inDays > 1 ? 's' : ''} ago';
    if (diff.inHours > 0) return '${diff.inHours} hour${diff.inHours > 1 ? 's' : ''} ago';
    return 'just now';
  }
}
