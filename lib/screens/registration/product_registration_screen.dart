import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/validators.dart';
import '../../models/product_model.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';

class ProductRegistrationScreen extends StatefulWidget {
  final String? qrData;
  const ProductRegistrationScreen({super.key, this.qrData});
  @override
  State<ProductRegistrationScreen> createState() => _ProductRegistrationScreenState();
}

class _ProductRegistrationScreenState extends State<ProductRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _serialCtrl = TextEditingController();
  final _auth = AuthService();
  final _firestore = FirestoreService();
  String _category = AppConstants.productCategories.first;
  DateTime _purchaseDate = DateTime.now();
  DateTime _expiryDate = DateTime.now().add(const Duration(days: 365));
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    if (widget.qrData != null) _parseQrData(widget.qrData!);
  }

  void _parseQrData(String data) {
    // Try to parse QR data — could be JSON or simple text
    _serialCtrl.text = data.length > 20 ? data.substring(0, 20) : data;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _serialCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate(bool isPurchase) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isPurchase ? _purchaseDate : _expiryDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2040),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(colorScheme: const ColorScheme.light(primary: AppColors.primary)),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        if (isPurchase) {
          _purchaseDate = picked;
        } else {
          _expiryDate = picked;
        }
      });
    }
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() => _loading = true);
    try {
      final product = ProductModel(
        id: '',
        userId: _auth.currentUser!.uid,
        productName: _nameCtrl.text.trim(),
        serialNumber: _serialCtrl.text.trim(),
        category: _category,
        qrCode: widget.qrData ?? '',
        purchaseDate: _purchaseDate,
        expiryDate: _expiryDate,
        status: widget.qrData != null ? AppConstants.statusVerified : AppConstants.statusRegistered,
        registeredAt: DateTime.now(),
      );
      await _firestore.addProduct(product);
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Product registered successfully!'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ));
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to register: $e'),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ));
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFmt = DateFormat('MMM dd, yyyy');
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => Navigator.pop(context)),
        title: Text('Product Registration', style: AppTextStyles.titleSm),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingLg),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text('Secure Registration', style: AppTextStyles.headlineMd),
              const SizedBox(height: 4),
              Text('Link your premium product to your digital vault for lifetime authenticity.',
                style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant)),
              const SizedBox(height: AppConstants.paddingLg),

              // QR Badge
              if (widget.qrData != null) ...[
                Container(
                  padding: const EdgeInsets.all(AppConstants.paddingMd),
                  decoration: BoxDecoration(
                    gradient: AppColors.cardGradient,
                    borderRadius: BorderRadius.circular(AppConstants.radiusLg),
                  ),
                  child: Row(children: [
                    const Icon(Icons.qr_code_rounded, color: AppColors.primary, size: 28),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('QR Code Scanned', style: AppTextStyles.labelMd.copyWith(color: AppColors.primary)),
                      Text(widget.qrData!, style: AppTextStyles.bodySm, maxLines: 1, overflow: TextOverflow.ellipsis),
                    ])),
                    const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 24),
                  ]),
                ),
                const SizedBox(height: AppConstants.paddingMd),
              ],

              // Product Name
              CustomTextField(controller: _nameCtrl, label: 'Product Name', hint: 'e.g., Seamaster Professional', prefixIcon: Icons.inventory_2_outlined, validator: (v) => Validators.required(v, 'Product name')),
              const SizedBox(height: AppConstants.paddingMd),

              // Serial Number
              CustomTextField(controller: _serialCtrl, label: 'Serial Number', hint: 'e.g., 8942-XXXX-1102', prefixIcon: Icons.tag_rounded, validator: (v) => Validators.required(v, 'Serial number')),
              const SizedBox(height: AppConstants.paddingMd),

              // Category Dropdown
              Text('Category', style: AppTextStyles.labelMd),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppConstants.radiusLg),
                  border: Border.all(color: AppColors.outlineVariant),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _category, isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.outline),
                    items: AppConstants.productCategories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                    onChanged: (v) => setState(() => _category = v!),
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.paddingMd),

              // Dates
              Row(children: [
                Expanded(child: _DateField(label: 'Purchase Date', value: dateFmt.format(_purchaseDate), onTap: () => _pickDate(true))),
                const SizedBox(width: 12),
                Expanded(child: _DateField(label: 'Expiry Date', value: dateFmt.format(_expiryDate), onTap: () => _pickDate(false))),
              ]),
              const SizedBox(height: AppConstants.paddingXl),

              // Register Button
              CustomButton(text: 'Register Product', onPressed: _register, isLoading: _loading, icon: Icons.verified_rounded),
              const SizedBox(height: AppConstants.paddingMd),

              // Security note
              Center(child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.lock_rounded, size: 14, color: AppColors.outline),
                const SizedBox(width: 6),
                Text('Encrypted on AuthentiCheck', style: AppTextStyles.bodySm),
              ])),
              const SizedBox(height: AppConstants.paddingLg),
            ],
          ),
        ),
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;
  const _DateField({required this.label, required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppConstants.radiusLg),
          border: Border.all(color: AppColors.outlineVariant),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: AppTextStyles.bodySm.copyWith(fontSize: 11)),
          const SizedBox(height: 4),
          Row(children: [
            const Icon(Icons.calendar_today_rounded, size: 16, color: AppColors.primary),
            const SizedBox(width: 6),
            Text(value, style: AppTextStyles.labelMd.copyWith(fontSize: 13)),
          ]),
        ]),
      ),
    );
  }
}
