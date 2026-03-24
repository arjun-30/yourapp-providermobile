import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/socket_service.dart';

class AuthProvider extends ChangeNotifier {
  final _storage = const FlutterSecureStorage();
  final _authService = AuthService();

  User? _user;
  String? _token;
  bool _isLoading = true;

  User? get user => _user;
  String? get token => _token;
  bool get isAuthenticated => _token != null;
  bool get isLoading => _isLoading;

  Future<void> loadToken() async {
    _token = await _storage.read(key: 'token');
    final userJson = await _storage.read(key: 'user');
    if (userJson != null) _user = User.fromJson(jsonDecode(userJson));
    if (_token != null) SocketService().connect(_token!);
    _isLoading = false;
    notifyListeners();
  }

  Future<String> sendOtp(String phone) => _authService.sendOtp(phone);

  Future<void> verifyOtp(String phone, String otp) async {
    final result = await _authService.verifyOtp(phone, otp);
    _token = result.token;
    _user = result.user;
    await _storage.write(key: 'token', value: _token);
    await _storage.write(key: 'user', value: jsonEncode({'id': _user!.id, 'phone': _user!.phone, 'name': _user!.name, 'avatarUrl': _user!.avatarUrl, 'role': _user!.role, 'isVerified': _user!.isVerified}));
    SocketService().connect(_token!);
    notifyListeners();
  }

  Future<void> logout() async {
    try { await _authService.logout(); } catch (_) {}
    SocketService().disconnect();
    await _storage.deleteAll();
    _token = null;
    _user = null;
    notifyListeners();
  }
}
