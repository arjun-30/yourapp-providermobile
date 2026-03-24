class AppConfig {
  static const apiUrl = String.fromEnvironment('API_URL', defaultValue: 'http://10.0.2.127:3000');
  static const googleMapsKey = String.fromEnvironment('MAPS_KEY', defaultValue: '');
  static const locationIntervalMs = 5000;
  static const requestTimeoutSec = 120;
  static const otpResendSeconds = 30;
  static const otpLength = 6;
}
