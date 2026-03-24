import 'package:flutter/foundation.dart';
import '../models/provider_profile.dart';
import '../services/provider_service.dart';

class ProviderState extends ChangeNotifier {
  final _service = ProviderService();

  ProviderProfile? _profile;
  bool _isOnline = false;
  bool _isApproved = false;

  ProviderProfile? get profile => _profile;
  bool get isOnline => _isOnline;
  bool get isApproved => _isApproved;

  Future<void> loadProfile() async {
    try {
      _profile = await _service.getMe();
      _isOnline = _profile!.isOnline;
      _isApproved = _profile!.isApproved;
      notifyListeners();
    } catch (_) {}
  }

  Future<void> toggleOnline(bool online, {double? lat, double? lng}) async {
    await _service.toggleOnline(online, lat: lat, lng: lng);
    _isOnline = online;
    notifyListeners();
  }

  void setProfile(ProviderProfile p) { _profile = p; _isApproved = p.isApproved; _isOnline = p.isOnline; notifyListeners(); }
}
