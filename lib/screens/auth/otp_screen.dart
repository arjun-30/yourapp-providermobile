import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import '../../constants/colors.dart';
import '../../constants/typography.dart';
import '../../constants/config.dart';
import '../../providers/auth_provider.dart';

class OtpScreen extends StatefulWidget {
  final String phone;
  const OtpScreen({super.key, required this.phone});
  @override State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String _otp = '';
  bool _loading = false;
  String _error = '';
  int _countdown = AppConfig.otpResendSeconds;
  Timer? _timer;

  @override
  void initState() { super.initState(); _startCountdown(); }
  @override
  void dispose() { _timer?.cancel(); super.dispose(); }

  void _startCountdown() {
    _countdown = AppConfig.otpResendSeconds;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_countdown <= 0) { t.cancel(); } else { setState(() => _countdown--); }
    });
  }

  Future<void> _verify(String code) async {
    setState(() { _loading = true; _error = ''; });
    try {
      await context.read<AuthProvider>().verifyOtp(widget.phone, code);
      if (mounted) context.go('/');
    } catch (e) {
      setState(() { _error = 'Incorrect OTP. Please try again.'; _otp = ''; });
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
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 16),
            IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
            const SizedBox(height: 24),
            Text('Enter verification code', style: AppTypography.h1),
            const SizedBox(height: 8),
            Text('We sent a 6-digit code to ${widget.phone}', style: AppTypography.body.copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: 32),
            PinCodeTextField(
              appContext: context,
              length: 6,
              onChanged: (v) => _otp = v,
              onCompleted: _verify,
              autoFocus: true,
              keyboardType: TextInputType.number,
              animationType: AnimationType.fade,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(12),
                fieldHeight: 56, fieldWidth: 48,
                activeColor: AppColors.primary, activeFillColor: AppColors.primaryLight,
                selectedColor: AppColors.primary, selectedFillColor: AppColors.white,
                inactiveColor: AppColors.border, inactiveFillColor: AppColors.surface,
                errorBorderColor: AppColors.error,
              ),
              enableActiveFill: true,
            ),
            if (_error.isNotEmpty) Text(_error, style: AppTypography.caption.copyWith(color: AppColors.error), textAlign: TextAlign.center),
            if (_loading) const Center(child: Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator())),
            const Spacer(),
            Center(child: TextButton(
              onPressed: _countdown > 0 ? null : () { context.read<AuthProvider>().sendOtp(widget.phone); _startCountdown(); },
              child: Text(_countdown > 0 ? 'Resend code in ${_countdown}s' : 'Resend code', style: TextStyle(color: _countdown > 0 ? AppColors.textMuted : AppColors.primary, fontWeight: FontWeight.w600)),
            )),
            const SizedBox(height: 32),
          ]),
        ),
      ),
    );
  }
}
