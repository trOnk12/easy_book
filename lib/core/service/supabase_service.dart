import 'package:easy_book/core/models/booking.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


final supabase = Supabase.instance.client;

Future<void> addBooking(Booking booking) async {
  final response = await supabase.from('bookings').insert(booking.toMap());
  if (response.error != null) {
    throw response.error!;
  }
}

Future<List<Booking>> fetchBookings() async {
  final response = await supabase.from('bookings').select().order('date', ascending: true);
  if (response.error != null) {
    throw response.error!;
  }

  return (response.data as List).map((e) => Booking.fromMap(e)).toList();
}