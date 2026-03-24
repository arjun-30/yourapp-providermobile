class IncomingRequest {
  final String bookingId;
  final String serviceId;
  final String serviceName;
  final String description;
  final String? photoUrl;
  final double customerLat;
  final double customerLng;
  final double distanceKm;
  final bool isEmergency;
  final String createdAt;

  IncomingRequest({required this.bookingId, required this.serviceId, required this.serviceName,
    required this.description, this.photoUrl, required this.customerLat, required this.customerLng,
    required this.distanceKm, required this.isEmergency, required this.createdAt});

  factory IncomingRequest.fromJson(Map<String, dynamic> json) => IncomingRequest(
    bookingId: json['bookingId'], serviceId: json['serviceId'], serviceName: json['serviceName'] ?? '',
    description: json['description'] ?? '', photoUrl: json['photoUrl'],
    customerLat: (json['customerLat'] ?? 0).toDouble(), customerLng: (json['customerLng'] ?? 0).toDouble(),
    distanceKm: (json['distanceKm'] ?? 0).toDouble(), isEmergency: json['isEmergency'] ?? false,
    createdAt: json['createdAt'] ?? '',
  );
}
