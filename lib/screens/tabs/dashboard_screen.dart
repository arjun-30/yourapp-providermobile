import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../constants/colors.dart';
import '../../constants/typography.dart';
import '../../providers/auth_provider.dart';
import '../../providers/provider_state.dart';
import '../../providers/job_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning';
    if (h < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final prov = context.watch<ProviderState>();
    final job = context.watch<JobProvider>();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Header
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(_greeting(), style: AppTypography.caption),
              const SizedBox(height: 2),
              Text(auth.user?.name ?? 'Provider', style: AppTypography.h1),
            ]),
            GestureDetector(
              onTap: () {},
              child: Container(width: 44, height: 44, decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(22)), child: const Icon(Icons.notifications_outlined, color: AppColors.textPrimary)),
            ),
          ]),
          const SizedBox(height: 24),

          // Online toggle
          GestureDetector(
            onTap: () => prov.toggleOnline(!prov.isOnline),
            child: Container(
              width: double.infinity, padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: prov.isOnline ? AppColors.success.withOpacity(0.1) : AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: prov.isOnline ? AppColors.success : AppColors.border, width: 1.5),
              ),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(prov.isOnline ? 'You are online' : 'You are offline', style: AppTypography.h3.copyWith(color: prov.isOnline ? AppColors.success : AppColors.textSecondary)),
                  const SizedBox(height: 4),
                  Text(prov.isOnline ? 'Receiving job requests' : 'Tap to go online', style: AppTypography.caption),
                ]),
                Container(
                  width: 56, height: 32,
                  decoration: BoxDecoration(color: prov.isOnline ? AppColors.success : AppColors.textMuted, borderRadius: BorderRadius.circular(16)),
                  alignment: prov.isOnline ? Alignment.centerRight : Alignment.centerLeft,
                  padding: const EdgeInsets.all(3),
                  child: Container(width: 26, height: 26, decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(13))),
                ),
              ]),
            ),
          ),
          const SizedBox(height: 20),

          // Active job banner
          if (job.hasActiveJob) GestureDetector(
            onTap: () => context.push('/active-job'),
            child: Container(
              width: double.infinity, padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.primary)),
              child: Row(children: [
                const Icon(Icons.directions_run, color: AppColors.primary),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Active job', style: AppTypography.bodyLarge.copyWith(color: AppColors.primary)),
                  Text(job.activeJob!.status.replaceAll('_', ' '), style: AppTypography.caption),
                ])),
                const Icon(Icons.chevron_right, color: AppColors.primary),
              ]),
            ),
          ),
          const SizedBox(height: 20),

          // Stats
          Text('Performance', style: AppTypography.h3),
          const SizedBox(height: 12),
          Row(children: [
            _StatCard(value: '${prov.profile?.totalJobs ?? 0}', label: 'Total Jobs'),
            const SizedBox(width: 10),
            _StatCard(value: '★ ${(prov.profile?.ratingAvg ?? 0).toStringAsFixed(1)}', label: 'Rating'),
            const SizedBox(width: 10),
            _StatCard(value: '${(prov.profile?.completionRate ?? 0).toStringAsFixed(0)}%', label: 'Completion'),
          ]),
          const SizedBox(height: 24),

          // Tip
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.warningLight, borderRadius: BorderRadius.circular(12)),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Icon(Icons.lightbulb_outline, size: 20, color: AppColors.warning),
              const SizedBox(width: 10),
              Expanded(child: Text('Stay online during peak hours (8–11 AM, 5–8 PM) to receive more requests.', style: AppTypography.caption.copyWith(color: AppColors.textSecondary))),
            ]),
          ),
        ]),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value, label;
  const _StatCard({required this.value, required this.label});
  @override
  Widget build(BuildContext context) {
    return Expanded(child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14)),
      child: Column(children: [
        Text(value, style: AppTypography.h2),
        const SizedBox(height: 4),
        Text(label, style: AppTypography.caption.copyWith(fontSize: 11)),
      ]),
    ));
  }
}
