import '../config/api_client.dart';
import '../models/provider_profile.dart';

class ProviderService {
  Future<ProviderProfile> getMe() async {
    final res = await api.get('/providers/me');
    return ProviderProfile.fromJson(res.data['data']);
  }

  Future<void> register({required String serviceId, String? bio, required int experienceYears, required String idProofUrl}) async {
    await api.post('/providers/register', data: {'serviceId': serviceId, 'bio': bio, 'experienceYears': experienceYears, 'idProofUrl': idProofUrl});
  }

  Future<void> toggleOnline(bool online, {double? lat, double? lng}) async {
    await api.patch('/providers/me/online', data: {'isOnline': online, if (lat != null) 'lat': lat, if (lng != null) 'lng': lng});
  }

  Future<void> updateLocation(double lat, double lng) async {
    await api.patch('/providers/me/location', data: {'lat': lat, 'lng': lng});
  }

  Future<Map<String, dynamic>> getStats() async {
    final res = await api.get('/providers/me/stats');
    return res.data['data'];
  }

  Future<Map<String, dynamic>> getEarnings(String period) async {
    final res = await api.get('/providers/me/earnings', queryParameters: {'period': period});
    return res.data['data'];
  }

  Future<void> uploadDocument(String type, String url) async {
    await api.post('/providers/me/documents', data: {'type': type, 'url': url});
  }
}
