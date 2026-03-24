import '../config/api_client.dart';
import '../models/user.dart';

class AuthService {
  Future<String> sendOtp(String phone) async {
    final res = await api.post('/auth/send-otp', data: {'phone': phone});
    return res.data['data']['requestId'] ?? '';
  }

  Future<({String token, User user})> verifyOtp(String phone, String otp) async {
    final res = await api.post('/auth/verify-otp', data: {'phone': phone, 'otp': otp, 'role': 'provider'});
    final d = res.data['data'];
    return (token: d['token'], user: User.fromJson(d['user']));
  }

  Future<void> logout() async {
    await api.post('/auth/logout');
  }

  Future<void> updateFcmToken(String token) async {
    await api.put('/auth/fcm-token', data: {'fcmToken': token});
  }
}
