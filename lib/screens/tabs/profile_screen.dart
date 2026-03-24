import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../constants/colors.dart';
import '../../constants/typography.dart';
import '../../providers/auth_provider.dart';
import '../../providers/provider_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final prov = context.watch<ProviderState>();
    final user = auth.user;

    return SafeArea(child: SingleChildScrollView(child: Column(children: [
      const SizedBox(height: 24),
      CircleAvatar(radius: 36, backgroundColor: AppColors.primaryLight, child: Text(user?.name.isNotEmpty == true ? user!.name.substring(0, min(2, user.name.length)).toUpperCase() : '?', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.primary))),
      const SizedBox(height: 12),
      Text(user?.name ?? 'Provider', style: AppTypography.h2),
      Text(user?.phone ?? '', style: AppTypography.caption),
      const SizedBox(height: 8),
      Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4), decoration: BoxDecoration(color: prov.isApproved ? AppColors.successLight : AppColors.warningLight, borderRadius: BorderRadius.circular(8)), child: Text(prov.isApproved ? 'Approved' : 'Pending', style: AppTypography.badge.copyWith(color: prov.isApproved ? AppColors.success : AppColors.warning))),
      const SizedBox(height: 24),
      if (prov.profile != null) Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14)),
        child: Row(children: [
          Expanded(child: Column(children: [Text('★ ${prov.profile!.ratingAvg.toStringAsFixed(1)}', style: AppTypography.h2), Text('Rating', style: AppTypography.caption)])),
          Container(width: 1, height: 30, color: AppColors.border),
          Expanded(child: Column(children: [Text('${prov.profile!.totalJobs}', style: AppTypography.h2), Text('Jobs', style: AppTypography.caption)])),
          Container(width: 1, height: 30, color: AppColors.border),
          Expanded(child: Column(children: [Text('${prov.profile!.experienceYears}y', style: AppTypography.h2), Text('Experience', style: AppTypography.caption)])),
        ]),
      ),
      const SizedBox(height: 16),
      ...[
        ('My Jobs', Icons.work_outline, null),
        ('Earnings', Icons.wallet_outlined, null),
        ('Documents', Icons.document_scanner_outlined, null),
        ('Notifications', Icons.notifications_outlined, null),
        ('Help & Support', Icons.help_outline, null),
      ].map((item) => ListTile(leading: Icon(item.$2, color: AppColors.textSecondary), title: Text(item.$1, style: AppTypography.bodyLarge), trailing: const Icon(Icons.chevron_right, size: 18, color: AppColors.textMuted), onTap: item.$3)),
      const Divider(indent: 20, endIndent: 20),
      ListTile(
        leading: const Icon(Icons.logout, color: AppColors.error),
        title: Text('Log out', style: AppTypography.bodyLarge.copyWith(color: AppColors.error)),
        onTap: () => showDialog(context: context, builder: (_) => AlertDialog(
          title: const Text('Log out'), content: const Text('Are you sure?'),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')), TextButton(onPressed: () { auth.logout(); context.go('/auth/phone'); }, child: const Text('Log out', style: TextStyle(color: AppColors.error)))],
        )),
      ),
    ])));
  }
}

int min(int a, int b) => a < b ? a : b;
