import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/validators.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import '../home/home_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _auth = AuthService();
  bool _loading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() => _loading = true);
    try {
      await _auth.signUp(
        name: _nameCtrl.text,
        email: _emailCtrl.text,
        password: _passCtrl.text,
      );
      if (!mounted) {
        return;
      }
      Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => const HomeScreen()));
    } on FirebaseAuthException catch (e) {
      if (!mounted) {
        return;
      }
      String msg = e.message ?? 'Sign up failed.';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(msg), backgroundColor: AppColors.error,
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
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.paddingLg),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 40),
                // Logo
                Container(
                  width: 72, height: 72,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 6))],
                  ),
                  child: const Icon(Icons.verified_rounded, size: 38, color: Colors.white),
                ),
                const SizedBox(height: AppConstants.paddingMd),
                Text(AppConstants.appName, style: AppTextStyles.headlineMd),
                const SizedBox(height: AppConstants.paddingSm),
                Text('Effortless verification for your premium assets.',
                  style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant), textAlign: TextAlign.center),
                const SizedBox(height: AppConstants.paddingSm),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text('Already have an account? ', style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant)),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text('Login here', style: AppTextStyles.labelMd.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700)),
                  ),
                ]),
                const SizedBox(height: AppConstants.paddingXl),
                CustomTextField(controller: _nameCtrl, label: 'Full Name', hint: 'Enter your full name', prefixIcon: Icons.person_outline_rounded, validator: Validators.name),
                const SizedBox(height: AppConstants.paddingMd),
                CustomTextField(controller: _emailCtrl, label: 'Email', hint: 'Enter your email', prefixIcon: Icons.email_outlined, keyboardType: TextInputType.emailAddress, validator: Validators.email),
                const SizedBox(height: AppConstants.paddingMd),
                CustomTextField(controller: _passCtrl, label: 'Password', hint: 'Create a password', prefixIcon: Icons.lock_outline_rounded, obscureText: true, validator: Validators.password),
                const SizedBox(height: AppConstants.paddingLg),
                CustomButton(text: 'Create Account', onPressed: _signUp, isLoading: _loading),
                const SizedBox(height: AppConstants.paddingXl),
                // Trust Badge
                Container(
                  padding: const EdgeInsets.all(AppConstants.paddingMd),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppConstants.radiusLg),
                    border: Border.all(color: AppColors.outlineVariant, width: 0.5),
                  ),
                  child: Row(children: [
                    Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(gradient: AppColors.cardGradient, borderRadius: BorderRadius.circular(AppConstants.radiusMd)),
                      child: const Icon(Icons.shield_rounded, color: AppColors.primary, size: 22),
                    ),
                    const SizedBox(width: AppConstants.paddingMd),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Authenticity Guaranteed', style: AppTextStyles.labelMd),
                      const SizedBox(height: 2),
                      Text('Join thousands who trust AuthentiCheck to secure their high-value assets.', style: AppTextStyles.bodySm),
                    ])),
                  ]),
                ),
                const SizedBox(height: AppConstants.paddingLg),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
