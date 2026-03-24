import 'package:socket_io_client/socket_io_client.dart' as io;
import '../constants/config.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  io.Socket? _socket;
  io.Socket? get socket => _socket;

  void connect(String token) {
    _socket = io.io(AppConfig.apiUrl, io.OptionBuilder()
      .setTransports(['websocket'])
      .setAuth({'token': token})
      .enableReconnection()
      .build());
    _socket!.connect();
  }

  void joinBooking(String bookingId) => _socket?.emit('join:booking', {'bookingId': bookingId});
  void leaveBooking(String bookingId) => _socket?.emit('leave:booking', {'bookingId': bookingId});
  void sendLocation(String bookingId, double lat, double lng) => _socket?.emit('location:send', {'bookingId': bookingId, 'lat': lat, 'lng': lng});

  void disconnect() { _socket?.disconnect(); _socket = null; }
}
