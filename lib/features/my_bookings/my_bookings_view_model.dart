// lib/features/my_bookings/my_bookings_view_model.dart

import 'package:easy_book/core/service/booking_service.dart';
import 'package:easy_book/core/service/service_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'my_bookings_state.dart';

final myBookingsProvider =
StateNotifierProvider<MyBookingsViewModel, MyBookingsState>(
      (ref) => MyBookingsViewModel(ref.read(bookingServiceProvider))..loadBookings(),
);

class MyBookingsViewModel extends StateNotifier<MyBookingsState> {
  final BookingService _service;

  MyBookingsViewModel(this._service) : super(const MyBookingsState());

  Future<void> loadBookings() async {
    state = state.copyWith(bookings: const AsyncValue.loading());
    try {
      final list = await _service.fetchUserBookings();
      state = state.copyWith(bookings: AsyncValue.data(list));
    } catch (e, st) {
      state = state.copyWith(bookings: AsyncValue.error(e, st));
    }
  }

  Future<bool> cancelBooking(String bookingId) async {
    final ok = await _service.cancelBooking(bookingId);
    if (ok) await loadBookings();
    return ok;
  }
}
