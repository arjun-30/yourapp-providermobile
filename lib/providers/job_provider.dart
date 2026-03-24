import 'package:flutter/foundation.dart';
import '../models/booking.dart';
import '../models/incoming_request.dart';
import '../services/booking_service.dart';

class JobProvider extends ChangeNotifier {
  final _service = BookingService();

  Booking? _activeJob;
  IncomingRequest? _incomingRequest;
  DateTime? _requestExpiry;

  Booking? get activeJob => _activeJob;
  IncomingRequest? get incomingRequest => _incomingRequest;
  DateTime? get requestExpiry => _requestExpiry;
  bool get hasActiveJob => _activeJob != null;
  bool get hasIncoming => _incomingRequest != null;

  void setActiveJob(Booking? job) { _activeJob = job; notifyListeners(); }
  void setIncomingRequest(IncomingRequest? req) {
    _incomingRequest = req;
    _requestExpiry = req != null ? DateTime.now().add(const Duration(minutes: 2)) : null;
    notifyListeners();
  }
  void clearIncoming() { _incomingRequest = null; _requestExpiry = null; notifyListeners(); }

  void updateStatus(String status) {
    if (_activeJob != null) {
      _activeJob = Booking.fromJson({..._bookingToMap(_activeJob!), 'status': status});
      notifyListeners();
    }
  }

  void updateQuote(int quoted, int fee, int total) {
    if (_activeJob != null) {
      _activeJob = Booking.fromJson({..._bookingToMap(_activeJob!), 'quotedAmount': quoted, 'platformFee': fee, 'totalAmount': total});
      notifyListeners();
    }
  }

  Future<Booking> acceptJob(String bookingId) async {
    final booking = await _service.accept(bookingId);
    _activeJob = booking;
    clearIncoming();
    return booking;
  }

  Future<void> rejectJob(String bookingId) async {
    await _service.reject(bookingId);
    clearIncoming();
  }

  void reset() { _activeJob = null; _incomingRequest = null; _requestExpiry = null; notifyListeners(); }

  Map<String, dynamic> _bookingToMap(Booking b) => {
    'id': b.id, 'customerId': b.customerId, 'providerId': b.providerId, 'serviceId': b.serviceId,
    'description': b.description, 'photoUrl': b.photoUrl, 'status': b.status, 'isEmergency': b.isEmergency,
    'customerLat': b.customerLat, 'customerLng': b.customerLng, 'quotedAmount': b.quotedAmount,
    'platformFee': b.platformFee, 'totalAmount': b.totalAmount, 'paymentStatus': b.paymentStatus,
    'paymentMethod': b.paymentMethod, 'createdAt': b.createdAt, 'completedAt': b.completedAt,
  };
}
