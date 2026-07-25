import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_text_styles.dart';

class ReminderSettingsScreen extends StatefulWidget {
  const ReminderSettingsScreen({super.key});
  @override
  State<ReminderSettingsScreen> createState() => _ReminderSettingsScreenState();
}

class _ReminderSettingsScreenState extends State<ReminderSettingsScreen> {
  bool _remindersEnabled = true;
  bool _advanceNotice = true;
  bool _pushNotifications = true;
  bool _emailDigest = false;
  bool _smsAlerts = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => Navigator.pop(context)),
        title: Text('Reminder Settings', style: AppTextStyles.titleSm),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Reminder Settings', style: AppTextStyles.headlineMd),
            const SizedBox(height: 4),
            Text('Configure how you want to be notified about product expirations and warranty renewals.',
              style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant)),
            const SizedBox(height: AppConstants.paddingLg),

            // Enable Reminders
            _SettingsToggle(
              icon: Icons.notifications_rounded,
              title: 'Enable Reminders',
              subtitle: 'Master switch for all notifications',
              value: _remindersEnabled,
              onChanged: (v) => setState(() => _remindersEnabled = v),
            ),
            const SizedBox(height: AppConstants.paddingSm),

            // Advance Notice
            _SettingsToggle(
              icon: Icons.timer_rounded,
              title: 'Advance Notice',
              subtitle: 'Receive an extra ping when only 2 days remain.',
              value: _advanceNotice,
              enabled: _remindersEnabled,
              onChanged: (v) => setState(() => _advanceNotice = v),
            ),
            const SizedBox(height: AppConstants.paddingLg),

            // Delivery Channels
            Text('Delivery Channels', style: AppTextStyles.titleSm),
            const SizedBox(height: AppConstants.paddingMd),

            _SettingsToggle(
              icon: Icons.phone_android_rounded,
              title: 'Push Notifications',
              subtitle: 'Instant alerts on your device',
              value: _pushNotifications,
              enabled: _remindersEnabled,
              onChanged: (v) => setState(() => _pushNotifications = v),
            ),
            const SizedBox(height: AppConstants.paddingSm),

            _SettingsToggle(
              icon: Icons.email_rounded,
              title: 'Email Digest',
              subtitle: 'Weekly summary of upcoming dates',
              value: _emailDigest,
              enabled: _remindersEnabled,
              onChanged: (v) => setState(() => _emailDigest = v),
            ),
            const SizedBox(height: AppConstants.paddingSm),

            _SettingsToggle(
              icon: Icons.sms_rounded,
              title: 'SMS Alerts',
              subtitle: 'Available for Premium members',
              value: _smsAlerts,
              enabled: _remindersEnabled,
              onChanged: (v) => setState(() => _smsAlerts = v),
              badge: 'PREMIUM',
            ),
            const SizedBox(height: AppConstants.paddingXl),

            // Info Card
            Container(
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
                  child: const Icon(Icons.shield_rounded, color: AppColors.primary, size: 22),
                ),
                const SizedBox(width: AppConstants.paddingMd),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Always Authentic', style: AppTextStyles.labelMd),
                  const SizedBox(height: 2),
                  Text('Our reminders ensure your luxury assets never lose their certified status or warranty coverage.', style: AppTextStyles.bodySm),
                ])),
              ]),
            ),
            const SizedBox(height: AppConstants.paddingLg),
          ],
        ),
      ),
    );
  }
}

class _SettingsToggle extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final bool enabled;
  final ValueChanged<bool> onChanged;
  final String? badge;

  const _SettingsToggle({
    required this.icon, required this.title, required this.subtitle,
    required this.value, this.enabled = true, required this.onChanged, this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1.0 : 0.5,
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
            Row(children: [
              Text(title, style: AppTextStyles.titleXs),
              if (badge != null) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                  ),
                  child: Text(badge!, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 0.5)),
                ),
              ],
            ]),
            const SizedBox(height: 2),
            Text(subtitle, style: AppTextStyles.bodySm),
          ])),
          Switch(
            value: value,
            onChanged: enabled ? onChanged : null,
            activeThumbColor: AppColors.primary,
          ),
        ]),
      ),
    );
  }
}
