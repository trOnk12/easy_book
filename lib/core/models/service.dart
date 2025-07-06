// lib/core/models/service.dart

class Service {
  final String id;
  final String title;
  final String description;
  final String duration;       // e.g. "60 min"
  final String price;          // e.g. "49.99"
  final String imageUrl;
  final String performerName;
  final double performerRating; // e.g. 4.5

  Service({
    required this.id,
    required this.title,
    required this.description,
    required this.duration,
    required this.price,
    required this.imageUrl,
    required this.performerName,
    required this.performerRating,
  });

  factory Service.fromMap(Map<String, dynamic> m) => Service(
    id: m['id'] as String,
    title: m['title'] as String,
    description: m['description'] as String,
    duration: m['duration'] as String,
    price: m['price'].toString(),
    imageUrl: m['image_url'] as String? ?? '',
    performerName: m['performer_name'] as String? ?? '',
    performerRating: (m['performer_rating'] as num?)?.toDouble() ?? 0.0,
  );
}
