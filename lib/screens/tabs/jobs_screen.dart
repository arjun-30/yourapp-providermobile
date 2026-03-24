import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/typography.dart';
import '../../services/booking_service.dart';
import '../../models/booking.dart';
import 'package:intl/intl.dart';

class JobsScreen extends StatefulWidget {
  const JobsScreen({super.key});
  @override State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  String _filter = 'All';
  List<Booking> _jobs = [];
  bool _loading = true;

  @override void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final status = _filter == 'Active' ? 'active' : _filter == 'Done' ? 'done' : null;
      _jobs = await BookingService().list(status: status);
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Column(children: [
      Padding(padding: const EdgeInsets.fromLTRB(20, 16, 20, 8), child: Align(alignment: Alignment.centerLeft, child: Text('My Jobs', style: AppTypography.h1))),
      SizedBox(height: 36, child: ListView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 20), children: ['All', 'Active', 'Done'].map((f) => Padding(
        padding: const EdgeInsets.only(right: 8),
        child: GestureDetector(
          onTap: () { setState(() => _filter = f); _load(); },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(color: _filter == f ? AppColors.primary : AppColors.surface, borderRadius: BorderRadius.circular(20)),
            child: Text(f, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _filter == f ? Colors.white : AppColors.textSecondary)),
          ),
        ),
      )).toList())),
      Expanded(child: _loading
        ? const Center(child: CircularProgressIndicator())
        : _jobs.isEmpty
          ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.work_outline, size: 48, color: AppColors.textMuted), const SizedBox(height: 12), Text('No jobs yet', style: AppTypography.body.copyWith(color: AppColors.textMuted))]))
          : RefreshIndicator(onRefresh: _load, child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _jobs.length,
              itemBuilder: (_, i) {
                final j = _jobs[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Padding(padding: const EdgeInsets.all(14), child: Row(children: [
                    CircleAvatar(radius: 21, backgroundColor: AppColors.primaryLight, child: Text(j.serviceId.substring(0, 2).toUpperCase(), style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 12))),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(j.description, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTypography.bodyLarge),
                      const SizedBox(height: 2),
                      Text(DateFormat('d MMM yyyy').format(DateTime.parse(j.createdAt)), style: AppTypography.caption),
                    ])),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: j.status == 'paid' ? AppColors.successLight : j.status == 'cancelled' ? AppColors.errorLight : AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(j.status.replaceAll('_', ' '), style: AppTypography.badge.copyWith(color: j.status == 'paid' ? AppColors.success : j.status == 'cancelled' ? AppColors.error : AppColors.primary)),
                    ),
                  ])),
                );
              },
            )),
      ),
    ]));
  }
}
