/// App-wide constants: strings, paddings, durations, etc.
class AppConstants {
  AppConstants._();

  // ── App Info ──
  static const String appName = 'AuthentiCheck';
  static const String appTagline = 'Effortless Verification';
  static const String appDescription =
      'Effortless verification for your premium lifestyle.';

  // ── Padding ──
  static const double paddingXs = 4.0;
  static const double paddingSm = 8.0;
  static const double paddingMd = 16.0;
  static const double paddingLg = 24.0;
  static const double paddingXl = 32.0;
  static const double paddingXxl = 48.0;

  // ── Border Radius ──
  static const double radiusSm = 4.0;
  static const double radiusMd = 8.0;
  static const double radiusLg = 12.0;
  static const double radiusXl = 16.0;
  static const double radiusXxl = 24.0;
  static const double radiusFull = 100.0;

  // ── Animation Durations ──
  static const Duration durationFast = Duration(milliseconds: 200);
  static const Duration durationMedium = Duration(milliseconds: 350);
  static const Duration durationSlow = Duration(milliseconds: 500);
  static const Duration splashDuration = Duration(milliseconds: 2500);

  // ── Firestore Collections ──
  static const String usersCollection = 'users';
  static const String productsCollection = 'products';

  // ── Product Categories ──
  static const List<String> productCategories = [
    'Watches & Jewelry',
    'Handbags & Accessories',
    'Electronics',
    'Sneakers & Footwear',
    'Art & Collectibles',
    'Other',
  ];

  // ── Product Statuses ──
  static const String statusVerified = 'verified';
  static const String statusPending = 'pending';
  static const String statusRegistered = 'registered';
}
