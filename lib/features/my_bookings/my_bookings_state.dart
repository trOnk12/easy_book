// lib/features/my_bookings/my_bookings_state.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/booking.dart';

class MyBookingsState {
  final AsyncValue<List<Booking>> bookings;

  const MyBookingsState({this.bookings = const AsyncValue.loading()});

  MyBookingsState copyWith({AsyncValue<List<Booking>>? bookings}) {
    return MyBookingsState(
      bookings: bookings ?? this.bookings,
    );
  }
}
