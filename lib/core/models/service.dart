// lib/core/models/service.dart
class Service {
  final String id;
  final String title;
  final String description;
  final String price;     // “120 zł”
  final String duration;  // “60 min”
  final String imageUrl;

  Service({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.duration,
    required this.imageUrl,
  });

  factory Service.fromMap(Map<String, dynamic> m) => Service(
    id: m['id'],
    title: m['title'],
    description: m['description'] ?? '',
    price: m['price'],
    duration: m['duration'],
    imageUrl: m['image_url'] ?? '',
  );
}
