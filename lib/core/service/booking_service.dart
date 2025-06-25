import 'package:easy_book/core/models/booking.dart';

class BookingService {
  static final List<Booking> bookings = [];

  static void addBooking(Booking booking) {
    bookings.add(booking);
  }
}