import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../constants/colors.dart';
import '../../constants/typography.dart';
import '../../providers/job_provider.dart';
import '../../services/booking_service.dart';

const _statusActions = [
  ('accepted', 'confirmed', 'Confirm Job'),
  ('confirmed', 'on_the_way', 'Start Travelling'),
  ('on_the_way', 'arrived', 'Mark Arrived'),
  ('arrived', 'in_progress', 'Start Service'),
  ('in_progress', 'completed', 'Complete Service'),
];

class ActiveJobScreen extends StatefulWidget {
  const ActiveJobScreen({super.key});
  @override State<ActiveJobScreen> createState() => _ActiveJobScreenState();
}

class _ActiveJobScreenState extends State<ActiveJobScreen> {
  bool _updating = false;

  @override
  Widget build(BuildContext context) {
    final job = context.watch<JobProvider>();
    final booking = job.activeJob;
    if (booking == null) return Scaffold(body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [const CircularProgressIndicator(), const SizedBox(height: 16), Text('Loading...', style: AppTypography.body)])));

    final action = _statusActions.where((a) => a.$1 == booking.status).firstOrNull;
    final canQuote = booking.status == 'arrived' || booking.status == 'in_progress';
    final hasQuote = booking.quotedAmount != null;

    return Scaffold(
      body: Column(children: [
        // Map
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.35,
          child: GoogleMap(
            initialCameraPosition: CameraPosition(target: LatLng(booking.customerLat, booking.customerLng), zoom: 15),
            markers: {Marker(markerId: const MarkerId('customer'), position: LatLng(booking.customerLat, booking.customerLng), icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet))},
            myLocationEnabled: true,
            zoomControlsEnabled: false,
          ),
        ),
        // Panel
        Expanded(child: SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Status badge
          Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(8)), child: Text(booking.status.replaceAll('_', ' ').toUpperCase(), style: AppTypography.badge.copyWith(color: AppColors.primary))),
          const SizedBox(height: 16),
          // Customer info
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Customer', style: AppTypography.caption.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(booking.description, style: AppTypography.body, maxLines: 2, overflow: TextOverflow.ellipsis),
            ]),
          ),
          // Quote
          if (hasQuote) Container(
            margin: const EdgeInsets.only(top: 12), padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.successLight, borderRadius: BorderRadius.circular(12)),
            child: Column(children: [
              Text('Quote sent', style: AppTypography.caption.copyWith(color: AppColors.success, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text('₹${((booking.totalAmount ?? 0) / 100).toStringAsFixed(0)}', style: AppTypography.h1.copyWith(color: AppColors.success)),
            ]),
          ),
          if (canQuote && !hasQuote) Padding(padding: const EdgeInsets.only(top: 12), child: OutlinedButton(onPressed: () => context.push('/set-quote?bookingId=${booking.id}'), child: const Text('Set Quote'))),
          // Action button
          if (action != null) Padding(padding: const EdgeInsets.only(top: 16), child: SizedBox(width: double.infinity, child: ElevatedButton(
            onPressed: _updating ? null : () async {
              setState(() => _updating = true);
              try {
                await BookingService().updateStatus(booking.id, action.$2);
                job.updateStatus(action.$2);
                if (action.$2 == 'completed' && mounted) {
                  showDialog(context: context, builder: (_) => AlertDialog(title: const Text('Service complete!'), content: const Text('The customer will now be asked to pay.'), actions: [TextButton(onPressed: () { Navigator.pop(context); job.reset(); context.go('/'); }, child: const Text('OK'))]));
                }
              } catch (e) { if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()))); }
              if (mounted) setState(() => _updating = false);
            },
            child: _updating ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : Text(action.$3),
          ))),
          // Cancel
          if (booking.status != 'completed') Center(child: TextButton.icon(
            onPressed: () => showDialog(context: context, builder: (_) => AlertDialog(
              title: const Text('Cancel job?'),
              actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('No')), TextButton(onPressed: () async { Navigator.pop(context); await BookingService().cancel(booking.id, 'Provider cancelled'); job.reset(); if (mounted) context.go('/'); }, child: const Text('Yes, cancel', style: TextStyle(color: AppColors.error)))],
            )),
            icon: const Icon(Icons.cancel_outlined, color: AppColors.error, size: 18),
            label: Text('Cancel this job', style: TextStyle(color: AppColors.error, fontSize: 14)),
          )),
        ]))),
      ]),
    );
  }
}
