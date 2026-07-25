import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_text_styles.dart';
import '../../services/auth_service.dart';
import '../auth/login_screen.dart';
import '../reminder/reminder_settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthService();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingLg),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Avatar
            Container(
              width: 88, height: 88,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 6))],
              ),
              child: Center(child: Text(
                auth.userName.isNotEmpty ? auth.userName[0].toUpperCase() : 'U',
                style: AppTextStyles.displayLg.copyWith(color: Colors.white, fontSize: 36),
              )),
            ),
            const SizedBox(height: AppConstants.paddingMd),
            Text(auth.userName, style: AppTextStyles.headlineMd),
            const SizedBox(height: 4),
            Text(auth.userEmail, style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant)),
            const SizedBox(height: AppConstants.paddingXl),

            // Menu Items
            _MenuItem(icon: Icons.notifications_rounded, title: 'Reminder Settings', subtitle: 'Expiry & warranty alerts',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReminderSettingsScreen()))),
            const SizedBox(height: AppConstants.paddingSm),
            _MenuItem(icon: Icons.shield_rounded, title: 'Privacy & Security', subtitle: 'Manage your data'),
            const SizedBox(height: AppConstants.paddingSm),
            _MenuItem(icon: Icons.help_outline_rounded, title: 'Help & Support', subtitle: 'FAQs and contact us'),
            const SizedBox(height: AppConstants.paddingSm),
            _MenuItem(icon: Icons.info_outline_rounded, title: 'About AuthentiCheck', subtitle: 'Version 1.0.0'),
            const SizedBox(height: AppConstants.paddingXl),

            // Logout
            GestureDetector(
              onTap: () async {
                await auth.signOut();
                if (!context.mounted) return;
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (_) => false);
              },
              child: Container(
                padding: const EdgeInsets.all(AppConstants.paddingMd),
                decoration: BoxDecoration(
                  color: AppColors.errorContainer.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(AppConstants.radiusLg),
                ),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Icon(Icons.logout_rounded, color: AppColors.error, size: 20),
                  const SizedBox(width: 8),
                  Text('Sign Out', style: AppTextStyles.labelMd.copyWith(color: AppColors.error)),
                ]),
              ),
            ),
            const SizedBox(height: AppConstants.paddingLg),
          ],
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  const _MenuItem({required this.icon, required this.title, required this.subtitle, this.onTap});

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
        ),
        child: Row(children: [
          Container(
            width: 42, height: 42,
            decoration: BoxDecoration(gradient: AppColors.cardGradient, borderRadius: BorderRadius.circular(AppConstants.radiusMd)),
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: AppConstants.paddingMd),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: AppTextStyles.titleXs),
            const SizedBox(height: 2),
            Text(subtitle, style: AppTextStyles.bodySm),
          ])),
          const Icon(Icons.chevron_right_rounded, color: AppColors.outline, size: 20),
        ]),
      ),
    );
  }
}
