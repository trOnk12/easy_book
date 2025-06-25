import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_book/core/models/booking.dart';
import 'package:easy_book/core/service/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final bookingControllerProvider =
StateNotifierProvider<BookingController, AsyncValue<void>>(
      (ref) => BookingController(),
);

class BookingController extends StateNotifier<AsyncValue<void>> {
  BookingController() : super(const AsyncValue.data(null));

  /// Attempts to create a booking.
  /// Returns true if the insert succeeded, false otherwise.
  Future<bool> createBooking({
    required Booking booking,
  }) async {
    state = const AsyncValue.loading();
    try {
      // Ensure we have an authenticated user
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        throw Exception('Not authenticated');
      }

      // You may want to enforce that booking.userId == user.id here,
      // or rely on your `addBooking` implementation to attach it.
      await addBooking(booking);

      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  /// Cancels an existing booking by ID. Returns `true` on success.
  Future<bool> cancelBooking(String bookingId) async {
    state = const AsyncValue.loading();
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) throw Exception("Not authenticated");

      final res = await Supabase.instance.client
          .from('bookings')
          .update({'status': 'cancelled'})
          .eq('id', bookingId);

      if (res.error != null) throw res.error!;

      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

final bookingListProvider = FutureProvider<List<Booking>>((ref) async {
  final userId = Supabase.instance.client.auth.currentUser?.id;
  if (userId == null) throw Exception("User not logged in");

  final response = await Supabase.instance.client
      .from('bookings')
      .select()
      .eq('user_id', userId)
      .order('date', ascending: true);

  return (response as List).map((e) => Booking.fromMap(e)).toList();
});
