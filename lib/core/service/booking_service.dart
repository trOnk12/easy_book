// lib/core/service/booking_service.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/booking.dart';

/// Encapsulates all Supabase operations for bookings.
class BookingService {
  final SupabaseClient _client;

  BookingService(this._client);

  /// Fetches the current user’s bookings, including the joined service title.
  Future<List<Booking>> fetchUserBookings() async {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw Exception('Not authenticated');
    }

    // Join the `services` table to retrieve each service’s title
    final response = await _client
        .from('bookings')
        .select('*, service:services(id, title)')
        .eq('user_id', user.id)
        .order('scheduled_for', ascending: true);

    if (response.error != null) {
      throw response.error!;
    }

    final data = response as List;
    return data
        .map((row) => Booking.fromMap(row as Map<String, dynamic>))
        .toList();
  }

  /// Cancels a booking by setting its status to `cancelled`.
  Future<bool> cancelBooking(String bookingId) async {
    final response = await _client
        .from('bookings')
        .update({'status': 'cancelled'})
        .eq('id', bookingId);

    return response.error == null;
  }

  /// Creates a new booking. Relies on Supabase session to set `user_id`.
  Future<bool> createBooking(Booking booking) async {
    final insertMap = booking.toMap()..remove('id');
    final response =
    await _client.from('bookings').insert(insertMap);
    return response.error == null;
  }
}
