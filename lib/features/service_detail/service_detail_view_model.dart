// lib/features/service_detail/service_detail_view_model.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/models/booking.dart';
import '../../providers/booking_provider.dart';
import 'service_detail_state.dart';

/// A StateNotifierProvider.family so each screen instance gets its own VM + state.
final serviceDetailProvider = StateNotifierProvider
    .family<ServiceDetailViewModel, ServiceDetailState, String>(
      (ref, serviceId) => ServiceDetailViewModel(ref, serviceId),
);

/// The ViewModel handling all logic for ServiceDetailScreen.
class ServiceDetailViewModel extends StateNotifier<ServiceDetailState> {
  final Ref _ref;
  final String _serviceId;

  ServiceDetailViewModel(this._ref, this._serviceId)
      : super(const ServiceDetailState());

  /// Called when the user picks a new date.
  void updateDate(DateTime date) {
    state = state.copyWith(
      selectedDate: date,
      selectedTime: null,
      status: BookingStatus.idle,
      errorMessage: null,
    );
  }

  /// Called when the user picks a new time.
  void updateTime(TimeOfDay time) {
    state = state.copyWith(
      selectedTime: time,
      status: BookingStatus.idle,
      errorMessage: null,
    );
  }

  /// Initiates the booking API call.
  ///
  /// [serviceTitle] and [price] come from the UI.
  Future<void> book({
    required String serviceTitle,
    required String price,
  }) async {
    // Guard: need both date & time
    if (state.selectedDate == null || state.selectedTime == null) return;

    state = state.copyWith(status: BookingStatus.loading, errorMessage: null);

    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final dt = DateTime(
        state.selectedDate!.year,
        state.selectedDate!.month,
        state.selectedDate!.day,
        state.selectedTime!.hour,
        state.selectedTime!.minute,
      );

      final booking = Booking(
        id: '',
        userId: user.id,
        serviceName: "test",
        serviceId: _serviceId,
        date: dt,
        time:
        '${state.selectedTime!.hour.toString().padLeft(2, '0')}:${state.selectedTime!.minute.toString().padLeft(2, '0')}',
        status: 'pending',
        price: price,
      );

      final success = await _ref
          .read(bookingControllerProvider.notifier)
          .createBooking(booking: booking);

      if (success) {
        state = state.copyWith(status: BookingStatus.success);
      } else {
        final err = _ref.read(bookingControllerProvider).error?.toString() ??
            'Unknown error';
        state = state.copyWith(
            status: BookingStatus.error, errorMessage: err);
      }
    } catch (e) {
      state = state.copyWith(
          status: BookingStatus.error, errorMessage: e.toString());
    }
  }
}
