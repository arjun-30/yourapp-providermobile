import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../constants/colors.dart';
import '../../constants/typography.dart';
import '../../providers/job_provider.dart';

class IncomingRequestScreen extends StatefulWidget {
  const IncomingRequestScreen({super.key});
  @override State<IncomingRequestScreen> createState() => _IncomingRequestScreenState();
}

class _IncomingRequestScreenState extends State<IncomingRequestScreen> {
  int _secondsLeft = 120;
  Timer? _timer;
  bool _accepting = false;
  bool _rejecting = false;

  @override
  void initState() {
    super.initState();
    HapticFeedback.heavyImpact();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_secondsLeft <= 0) { _timer?.cancel(); if (mounted) context.pop(); return; }
      setState(() => _secondsLeft--);
    });
  }

  @override void dispose() { _timer?.cancel(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final job = context.watch<JobProvider>();
    final req = job.incomingRequest;
    if (req == null) { WidgetsBinding.instance.addPostFrameCallback((_) { if (mounted) context.pop(); }); return const SizedBox(); }

    final mins = _secondsLeft ~/ 60;
    final secs = _secondsLeft % 60;

    return Scaffold(
      body: SafeArea(child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        // Timer
        Container(
          width: 100, height: 100,
          decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.primaryLight, border: Border.all(color: AppColors.primary, width: 3)),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text('$mins:${secs.toString().padLeft(2, '0')}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.primary)),
            Text('to respond', style: AppTypography.caption.copyWith(fontSize: 11)),
          ]),
        ),
        const SizedBox(height: 28),
        // Details card
        Container(
          width: double.infinity, padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (req.isEmergency) Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), margin: const EdgeInsets.only(bottom: 10), decoration: BoxDecoration(color: AppColors.errorLight, borderRadius: BorderRadius.circular(8)), child: Text('⚡ Emergency', style: AppTypography.badge.copyWith(color: AppColors.error))),
            Text(req.serviceName, style: AppTypography.h2),
            const SizedBox(height: 8),
            Text(req.description, style: AppTypography.body.copyWith(color: AppColors.textSecondary), maxLines: 3, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 16),
            Divider(color: AppColors.border),
            const SizedBox(height: 8),
            Row(children: [const Icon(Icons.location_on_outlined, size: 16, color: AppColors.primary), const SizedBox(width: 6), Text('${req.distanceKm.toStringAsFixed(1)} km away', style: AppTypography.bodyLarge)]),
          ]),
        ),
        const SizedBox(height: 28),
        // Buttons
        Row(children: [
          Expanded(child: OutlinedButton(onPressed: _accepting ? null : () async {
            setState(() => _rejecting = true);
            await job.rejectJob(req.bookingId);
            if (mounted) context.pop();
          }, child: _rejecting ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Reject'))),
          const SizedBox(width: 12),
          Expanded(child: ElevatedButton(onPressed: _rejecting ? null : () async {
            setState(() => _accepting = true);
            try {
              await job.acceptJob(req.bookingId);
              if (mounted) context.go('/active-job');
            } catch (e) { if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()))); }
            if (mounted) setState(() => _accepting = false);
          }, child: _accepting ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text('Accept'))),
        ]),
      ]))),
    );
  }
}
