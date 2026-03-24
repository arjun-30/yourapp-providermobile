import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../constants/colors.dart';
import '../../constants/typography.dart';
import '../../providers/job_provider.dart';
import '../../services/booking_service.dart';

class SetQuoteScreen extends StatefulWidget {
  final String bookingId;
  const SetQuoteScreen({super.key, required this.bookingId});
  @override State<SetQuoteScreen> createState() => _SetQuoteScreenState();
}

class _SetQuoteScreenState extends State<SetQuoteScreen> {
  final _controller = TextEditingController();
  bool _loading = false;
  String _error = '';

  int get _amount => int.tryParse(_controller.text) ?? 0;
  double get _fee => _amount * 0.10;
  double get _total => _amount + _fee;
  bool get _isValid => _amount >= 1 && _amount <= 100000;

  Future<void> _submit() async {
    if (!_isValid) { setState(() => _error = 'Enter an amount between ₹1 and ₹1,00,000.'); return; }
    setState(() { _loading = true; _error = ''; });
    try {
      final booking = await BookingService().setQuote(widget.bookingId, _amount);
      if (mounted) { context.read<JobProvider>().updateQuote(booking.quotedAmount!, booking.platformFee!, booking.totalAmount!); context.pop(); }
    } catch (e) { setState(() => _error = e.toString()); }
    finally { if (mounted) setState(() => _loading = false); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Set your quote')),
      body: Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('How much will this service cost?', style: AppTypography.h2),
        const SizedBox(height: 6),
        Text('Enter your charge. 10% platform fee is added for the customer.', style: AppTypography.caption),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: _error.isEmpty ? AppColors.border : AppColors.error, width: 2)),
          child: Row(children: [
            Text('₹', style: TextStyle(fontSize: 36, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
            const SizedBox(width: 4),
            Expanded(child: TextField(controller: _controller, autofocus: true, keyboardType: TextInputType.number, maxLength: 6, style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w800), decoration: const InputDecoration(border: InputBorder.none, counterText: '', hintText: '0'), onChanged: (_) => setState(() => _error = ''))),
          ]),
        ),
        if (_error.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 8), child: Text(_error, style: TextStyle(color: AppColors.error, fontSize: 13))),
        if (_amount > 0) Container(
          margin: const EdgeInsets.only(top: 24), padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14)),
          child: Column(children: [
            _Row('Your charge', '₹$_amount'),
            _Row('Platform fee (10%)', '₹${_fee.toStringAsFixed(0)}'),
            const Divider(height: 24, color: AppColors.border),
            _Row('Customer pays', '₹${_total.toStringAsFixed(0)}', bold: true),
            _Row('You receive', '₹$_amount', color: AppColors.success),
          ]),
        ),
        const Spacer(),
        SizedBox(width: double.infinity, child: ElevatedButton(
          onPressed: _isValid && !_loading ? _submit : null,
          child: _loading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : Text('Send quote — ₹$_amount + fee'),
        )),
        const SizedBox(height: 16),
      ])),
    );
  }
}

class _Row extends StatelessWidget {
  final String label, value;
  final bool bold;
  final Color? color;
  const _Row(this.label, this.value, {this.bold = false, this.color});
  @override Widget build(BuildContext context) => Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
    Text(label, style: TextStyle(fontSize: bold ? 15 : 14, fontWeight: bold ? FontWeight.w700 : FontWeight.w400, color: color ?? (bold ? AppColors.textPrimary : AppColors.textSecondary))),
    Text(value, style: TextStyle(fontSize: bold ? 18 : 14, fontWeight: bold ? FontWeight.w800 : FontWeight.w600, color: color ?? AppColors.textPrimary)),
  ]));
}
