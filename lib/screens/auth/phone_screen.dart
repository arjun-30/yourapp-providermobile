import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../constants/colors.dart';
import '../../constants/typography.dart';
import '../../providers/auth_provider.dart';

class PhoneScreen extends StatefulWidget {
  const PhoneScreen({super.key});
  @override State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  final _controller = TextEditingController();
  bool _loading = false;
  String _error = '';

  bool get _isValid => RegExp(r'^[6-9]\d{9}$').hasMatch(_controller.text);

  Future<void> _send() async {
    if (!_isValid) { setState(() => _error = 'Please enter a valid 10-digit mobile number.'); return; }
    setState(() { _loading = true; _error = ''; });
    try {
      await context.read<AuthProvider>().sendOtp('+91${_controller.text}');
      if (mounted) context.push('/auth/otp?phone=+91${_controller.text}');
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 72, height: 72,
                decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(36)),
                child: const Icon(Icons.handyman, size: 32, color: AppColors.primary),
              ),
              const SizedBox(height: 16),
              Text('RoundU Provider', style: AppTypography.appName),
              const SizedBox(height: 8),
              Text('Enter your phone number to get started', style: AppTypography.body.copyWith(color: AppColors.textSecondary), textAlign: TextAlign.center),
              const SizedBox(height: 40),
              Container(
                decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border, width: 1.5)),
                child: Row(children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: const BoxDecoration(border: Border(right: BorderSide(color: AppColors.border))),
                    child: Text('+91', style: AppTypography.bodyLarge),
                  ),
                  Expanded(child: TextField(
                    controller: _controller,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    autofocus: true,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, letterSpacing: 1),
                    decoration: const InputDecoration(border: InputBorder.none, counterText: '', hintText: '9876543210', contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16)),
                    onChanged: (_) => setState(() => _error = ''),
                  )),
                ]),
              ),
              if (_error.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 8), child: Text(_error, style: AppTypography.caption.copyWith(color: AppColors.error), textAlign: TextAlign.center)),
              const SizedBox(height: 16),
              SizedBox(width: double.infinity, child: ElevatedButton(
                onPressed: _isValid && !_loading ? _send : null,
                child: _loading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text('Send OTP'),
              )),
              const SizedBox(height: 24),
              Text('By continuing, you agree to our Terms of Service and Privacy Policy.', style: AppTypography.caption.copyWith(color: AppColors.textMuted), textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
