import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/typography.dart';
import '../../services/provider_service.dart';
import '../../models/earnings.dart';

class EarningsScreen extends StatefulWidget {
  const EarningsScreen({super.key});
  @override State<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends State<EarningsScreen> {
  String _period = 'Daily';
  Map<String, dynamic>? _summary;
  bool _loading = true;

  @override void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() => _loading = true);
    try { _summary = await ProviderService().getEarnings(_period.toLowerCase()); } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  String _fmt(int paise) => '₹${(paise / 100).toStringAsFixed(0)}';

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Earnings', style: AppTypography.h1),
      const SizedBox(height: 16),
      SizedBox(height: 36, child: ListView(scrollDirection: Axis.horizontal, children: ['Daily', 'Weekly', 'Monthly'].map((p) => Padding(
        padding: const EdgeInsets.only(right: 8),
        child: GestureDetector(
          onTap: () { setState(() => _period = p); _load(); },
          child: Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), decoration: BoxDecoration(color: _period == p ? AppColors.primary : AppColors.surface, borderRadius: BorderRadius.circular(20)), child: Text(p, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _period == p ? Colors.white : AppColors.textSecondary))),
        ),
      )).toList())),
      const SizedBox(height: 20),
      if (_loading) const Center(child: CircularProgressIndicator())
      else Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16)),
        child: Column(children: [
          Text(_fmt(_summary?['netEarnings'] ?? 0), style: AppTypography.h1.copyWith(fontSize: 32, color: AppColors.success)),
          const SizedBox(height: 4),
          Text('Net earnings', style: AppTypography.caption),
          const SizedBox(height: 16),
          const Divider(color: AppColors.border),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(child: Column(children: [Text(_fmt(_summary?['totalEarnings'] ?? 0), style: AppTypography.bodyLarge), const SizedBox(height: 2), Text('Total', style: AppTypography.caption)])),
            Container(width: 1, height: 30, color: AppColors.border),
            Expanded(child: Column(children: [Text(_fmt(_summary?['platformFees'] ?? 0), style: AppTypography.bodyLarge), const SizedBox(height: 2), Text('Fees', style: AppTypography.caption)])),
            Container(width: 1, height: 30, color: AppColors.border),
            Expanded(child: Column(children: [Text('${_summary?['jobCount'] ?? 0}', style: AppTypography.bodyLarge), const SizedBox(height: 2), Text('Jobs', style: AppTypography.caption)])),
          ]),
        ]),
      ),
    ])));
  }
}
