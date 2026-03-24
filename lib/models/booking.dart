class Booking {
  final String id;
  final String customerId;
  final String? providerId;
  final String serviceId;
  final String description;
  final String? photoUrl;
  final String status;
  final bool isEmergency;
  final double customerLat;
  final double customerLng;
  final int? quotedAmount;
  final int? platformFee;
  final int? totalAmount;
  final String paymentStatus;
  final String? paymentMethod;
  final String createdAt;
  final String? completedAt;

  Booking({required this.id, required this.customerId, this.providerId, required this.serviceId,
    required this.description, this.photoUrl, required this.status, required this.isEmergency,
    required this.customerLat, required this.customerLng, this.quotedAmount, this.platformFee,
    this.totalAmount, required this.paymentStatus, this.paymentMethod, required this.createdAt, this.completedAt});

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
    id: json['id'], customerId: json['customerId'], providerId: json['providerId'],
    serviceId: json['serviceId'], description: json['description'], photoUrl: json['photoUrl'],
    status: json['status'], isEmergency: json['isEmergency'] ?? false,
    customerLat: (json['customerLat'] ?? 0).toDouble(), customerLng: (json['customerLng'] ?? 0).toDouble(),
    quotedAmount: json['quotedAmount'], platformFee: json['platformFee'], totalAmount: json['totalAmount'],
    paymentStatus: json['paymentStatus'] ?? 'unpaid', paymentMethod: json['paymentMethod'],
    createdAt: json['createdAt'] ?? '', completedAt: json['completedAt'],
  );
}
