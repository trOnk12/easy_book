// lib/core/models/booking.dart

import 'package:intl/intl.dart';
import 'booking_status.dart';

/// A user’s booking for a given service, including the service’s title.
class Booking {
  final String id;
  final String serviceId;
  final String serviceName;
  final DateTime scheduledFor;
  final BookingStatus status;
  final int priceCents;

  Booking({
    required this.id,
    required this.serviceId,
    required this.serviceName,
    required this.scheduledFor,
    required this.status,
    required this.priceCents,
  });

  /// Builds a [Booking] from a Supabase row, which may include
  /// a joined `service` object under the key `"service"`.
  factory Booking.fromMap(Map<String, dynamic> map) {
    // Supabase “join” key:
    final serviceMap = map['service'] as Map<String, dynamic>?;

    return Booking(
      id: map['id'] as String,
      serviceId: map['service_id'] as String,
      serviceName: serviceMap != null
          ? serviceMap['title'] as String
          : (map['service_name'] as String? ?? '<Unknown>'),
      scheduledFor: DateTime.parse(map['scheduled_for'] as String).toUtc(),
      status: BookingStatusX.fromString(map['status'] as String),
      priceCents: (map['price_cents'] as num).toInt(),
    );
  }

  /// Converts this object into the shape expected by Supabase for insert/update.
  Map<String, dynamic> toMap() {
    final data = <String, dynamic>{
      'service_id': serviceId,
      'scheduled_for': scheduledFor.toUtc().toIso8601String(),
      'status': status.value,
      'price_cents': priceCents,
    };
    if (id.isNotEmpty) {
      data['id'] = id;
    }
    return data;
  }

  // ────────────────────────────────────────────────────────────────────────────
  // PRESENTATION HELPERS

  /// Formats date as “YYYY-MM-DD” in the device’s locale.
  String get formattedDate =>
      DateFormat('yyyy-MM-dd').format(scheduledFor.toLocal());

  /// Formats time as “HH:mm” (24-hour) in the device’s locale.
  String get formattedTime =>
      DateFormat('HH:mm').format(scheduledFor.toLocal());

  /// Formats price as a localized currency string, e.g. “€49.99”.
  String get formattedPrice {
    final euros = priceCents / 100;
    final formatter =
    NumberFormat.simpleCurrency(locale: 'pl_PL', name: '€');
    return formatter.format(euros);
  }
}
