import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_text_styles.dart';
import '../registration/product_registration_screen.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});
  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  final MobileScannerController _controller = MobileScannerController();
  bool _scanned = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_scanned) return;
    final barcode = capture.barcodes.firstOrNull;
    if (barcode == null || barcode.rawValue == null) return;

    setState(() => _scanned = true);
    _controller.stop();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductRegistrationScreen(qrData: barcode.rawValue!),
      ),
    ).then((_) {
      if (mounted) {
        setState(() => _scanned = false);
        _controller.start();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scanArea = size.width * 0.7;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera
          MobileScanner(controller: _controller, onDetect: _onDetect),

          // Dark overlay with cutout
          CustomPaint(
            size: size,
            painter: _ScannerOverlayPainter(scanArea: scanArea),
          ),

          // Header
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.paddingLg),
              child: Column(
                children: [
                  Row(children: [
                    Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.verified_rounded, size: 20, color: Colors.white),
                    ),
                    const SizedBox(width: 10),
                    Text(AppConstants.appName, style: AppTextStyles.titleSm.copyWith(color: Colors.white)),
                  ]),
                  const SizedBox(height: AppConstants.paddingXl),
                  Text('Scan QR Code', style: AppTextStyles.headlineMd.copyWith(color: Colors.white)),
                  const SizedBox(height: 8),
                  Text(
                    'Position the authenticator tag within the frame to verify your product',
                    style: AppTextStyles.bodyMd.copyWith(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          // Corner decorations
          Positioned(
            top: size.height / 2 - scanArea / 2,
            left: size.width / 2 - scanArea / 2,
            child: SizedBox(
              width: scanArea, height: scanArea,
              child: CustomPaint(painter: _CornersPainter()),
            ),
          ),

          // Bottom info
          Positioned(
            bottom: 100, left: 0, right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.flash_auto_rounded, color: Colors.white70, size: 18),
                  const SizedBox(width: 8),
                  Text('Auto-detect enabled', style: AppTextStyles.bodySm.copyWith(color: Colors.white70)),
                ]),
              ),
            ),
          ),

          // Manual entry button
          Positioned(
            bottom: 40, left: AppConstants.paddingLg, right: AppConstants.paddingLg,
            child: TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProductRegistrationScreen())),
              child: Text('Enter Manually Instead', style: AppTextStyles.labelMd.copyWith(color: Colors.white70)),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScannerOverlayPainter extends CustomPainter {
  final double scanArea;
  _ScannerOverlayPainter({required this.scanArea});

  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = Colors.black.withValues(alpha: 0.6);
    final cutout = Rect.fromCenter(center: Offset(size.width / 2, size.height / 2), width: scanArea, height: scanArea);
    canvas.drawPath(
      Path.combine(PathOperation.difference,
        Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
        Path()..addRRect(RRect.fromRectAndRadius(cutout, const Radius.circular(20))),
      ),
      bg,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CornersPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const len = 30.0;
    const r = 12.0;

    // Top-left
    canvas.drawPath(Path()..moveTo(0, len)..lineTo(0, r)..quadraticBezierTo(0, 0, r, 0)..lineTo(len, 0), paint);
    // Top-right
    canvas.drawPath(Path()..moveTo(size.width - len, 0)..lineTo(size.width - r, 0)..quadraticBezierTo(size.width, 0, size.width, r)..lineTo(size.width, len), paint);
    // Bottom-left
    canvas.drawPath(Path()..moveTo(0, size.height - len)..lineTo(0, size.height - r)..quadraticBezierTo(0, size.height, r, size.height)..lineTo(len, size.height), paint);
    // Bottom-right
    canvas.drawPath(Path()..moveTo(size.width - len, size.height)..lineTo(size.width - r, size.height)..quadraticBezierTo(size.width, size.height, size.width, size.height - r)..lineTo(size.width, size.height - len), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
