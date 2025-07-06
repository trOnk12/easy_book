
import 'package:easy_book/core/service/services_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'booking_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide Provider;


final bookingServiceProvider = Provider<BookingService>((ref) {
  return BookingService(Supabase.instance.client);
});

/// A singleton provider for ServiceService.
final serviceServiceProvider = Provider<ServiceService>((ref) {
  return ServiceService(Supabase.instance.client);
});