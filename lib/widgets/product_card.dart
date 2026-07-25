import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_constants.dart';
import '../core/constants/app_text_styles.dart';
import '../models/product_model.dart';

/// Product card widget for Dashboard and Home screens.
/// Shows product name, serial number, status chip, and expiry info.
class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppConstants.paddingMd),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppConstants.radiusLg),
          border: Border.all(color: AppColors.outlineVariant, width: 0.5),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Category Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: AppColors.cardGradient,
                borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              ),
              child: Icon(
                _getCategoryIcon(product.category),
                color: AppColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: AppConstants.paddingMd),

            // Product Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.productName,
                    style: AppTextStyles.titleXs,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'SN: ${product.serialNumber}',
                    style: AppTextStyles.bodySm,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _StatusChip(status: product.status),
                      const Spacer(),
                      _ExpiryInfo(product: product),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.outline,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'watches & jewelry':
        return Icons.watch_rounded;
      case 'handbags & accessories':
        return Icons.shopping_bag_rounded;
      case 'electronics':
        return Icons.devices_rounded;
      case 'sneakers & footwear':
        return Icons.directions_run_rounded;
      case 'art & collectibles':
        return Icons.palette_rounded;
      default:
        return Icons.inventory_2_rounded;
    }
  }
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'verified':
        bgColor = AppColors.successBg;
        textColor = AppColors.success;
        break;
      case 'pending':
        bgColor = AppColors.warningBg;
        textColor = AppColors.warning;
        break;
      default:
        bgColor = AppColors.infoBg;
        textColor = AppColors.primary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppConstants.radiusFull),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: textColor,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _ExpiryInfo extends StatelessWidget {
  final ProductModel product;

  const _ExpiryInfo({required this.product});

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('MMM dd, yyyy').format(product.expiryDate);

    if (product.isExpired) {
      return Text(
        'Expired',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.error,
        ),
      );
    }

    if (product.isExpiringSoon) {
      return Text(
        '${product.daysUntilExpiry}d left',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.warning,
        ),
      );
    }

    return Text(
      dateStr,
      style: AppTextStyles.bodySm.copyWith(fontSize: 11),
    );
  }
}
