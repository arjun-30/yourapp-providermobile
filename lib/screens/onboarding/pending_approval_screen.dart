import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart' as p;
import '../../constants/colors.dart';
import '../../constants/typography.dart';
import '../../providers/provider_state.dart';

class PendingApprovalScreen extends StatefulWidget {
  const PendingApprovalScreen({super.key});
  @override State<PendingApprovalScreen> createState() => _PendingApprovalScreenState();
}

class _PendingApprovalScreenState extends State<PendingApprovalScreen> {
  Timer? _timer;
  bool _checking = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 10), (_) => _checkApproval());
  }

  @override void dispose() { _timer?.cancel(); super.dispose(); }

  Future<void> _checkApproval() async {
    setState(() => _checking = true);
    try {
      await p.Provider.of<ProviderState>(context, listen: false).loadProfile();
      if (mounted && p.Provider.of<ProviderState>(context, listen: false).isApproved) context.go('/');
    } catch (_) {}
    if (mounted) setState(() => _checking = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(width: 96, height: 96, decoration: BoxDecoration(color: AppColors.warningLight, borderRadius: BorderRadius.circular(48)), child: const Icon(Icons.schedule, size: 48, color: AppColors.warning)),
            const SizedBox(height: 24),
            Text('Under review', style: AppTypography.h1),
            const SizedBox(height: 12),
            Text('Your profile is being reviewed. This usually takes 1–2 business days.', style: AppTypography.body.copyWith(color: AppColors.textSecondary), textAlign: TextAlign.center),
            const SizedBox(height: 32),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              if (_checking) const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) else const Icon(Icons.refresh, size: 16, color: AppColors.textMuted),
              const SizedBox(width: 8),
              Text('Checking status automatically...', style: AppTypography.caption),
            ]),
          ]),
        ),
      ),
    );
  }
}
