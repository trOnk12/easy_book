class Booking {
  final String id;
  final String serviceName;
  final String userId;
  final String serviceId;
  final DateTime date;
  final String time;
  final String status;
  final String price;

  Booking({
    required this.id,
    required this.serviceName,
    required this.userId,
    required this.serviceId,
    required this.date,
    required this.time,
    required this.status,
    required this.price,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'service_name': serviceName,
    'user_id': userId,
    'service_id': serviceId,
    'date': date.toIso8601String(),
    'time': time,
    'status': status,
    'price': price,
  };

  static Booking fromMap(Map<String, dynamic> map) => Booking(
    id: map['id'],
    serviceName: map['service_name'],
    userId: map['user_id'],
    serviceId: map['service_id'],
    date: DateTime.parse(map['date']),
    time: map['time'],
    status: map['status'],
    price: map['price'],
  );
}
