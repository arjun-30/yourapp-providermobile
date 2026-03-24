import '../config/api_client.dart';
import '../models/booking.dart';

class BookingService {
  Future<List<Booking>> list({int page = 1, int limit = 20, String? status}) async {
    final params = <String, dynamic>{'page': page, 'limit': limit};
    if (status != null) params['status'] = status;
    final res = await api.get('/bookings', queryParameters: params);
    return (res.data['data'] as List).map((j) => Booking.fromJson(j)).toList();
  }

  Future<Booking> getById(String id) async {
    final res = await api.get('/bookings/$id');
    return Booking.fromJson(res.data['data']);
  }

  Future<Booking> accept(String id) async {
    final res = await api.patch('/bookings/$id/accept');
    return Booking.fromJson(res.data['data']);
  }

  Future<void> reject(String id) async {
    await api.patch('/bookings/$id/reject');
  }

  Future<Booking> updateStatus(String id, String status) async {
    final res = await api.patch('/bookings/$id/status', data: {'status': status});
    return Booking.fromJson(res.data['data']);
  }

  Future<Booking> setQuote(String id, int amountRupees) async {
    final res = await api.patch('/bookings/$id/quote', data: {'amount': amountRupees});
    return Booking.fromJson(res.data['data']);
  }

  Future<void> cancel(String id, String reason) async {
    await api.patch('/bookings/$id/cancel', data: {'reason': reason});
  }
}
