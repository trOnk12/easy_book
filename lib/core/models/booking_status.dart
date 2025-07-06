// lib/core/models/booking_status.dart

/// Represents the lifecycle status of a booking.
enum BookingStatus {
  pending,
  confirmed,
  cancelled,
}

extension BookingStatusX on BookingStatus {
  /// The exact string stored in the database.
  String get value => toString().split('.').last;

  /// Parses a raw string from the database into the enum.
  /// Defaults to [BookingStatus.pending] if the input is unrecognized.
  static BookingStatus fromString(String raw) {
    return BookingStatus.values.firstWhere(
          (e) => e.value == raw,
      orElse: () => BookingStatus.pending,
    );
  }
}
