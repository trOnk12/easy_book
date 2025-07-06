// lib/features/service_detail/service_detail_view_model.dart

import 'package:easy_book/core/service/booking_service.dart';
import 'package:easy_book/core/service/services_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/models/booking.dart';
import '../../core/models/booking_status.dart';
import '../../core/service/service_provider.dart'; // exports ServiceServiceProvider & bookingServiceProvider
import 'service_detail_state.dart';

/// Provides one ViewModel per serviceId.
final serviceDetailProvider = StateNotifierProvider.family<
    ServiceDetailViewModel,
    ServiceDetailState,
    String>(
      (ref, serviceId) {
    final serviceSvc = ref.read(serviceServiceProvider);
    final bookingSvc = ref.read(bookingServiceProvider);
    return ServiceDetailViewModel(serviceSvc, bookingSvc, serviceId)
      ..loadService()
      ..loadSlots();
  },
);

class ServiceDetailViewModel extends StateNotifier<ServiceDetailState> {
  final ServiceService _serviceService;
  final BookingService _bookingService;
  final String _serviceId;

  ServiceDetailViewModel(
      this._serviceService,
      this._bookingService,
      this._serviceId,
      ) : super(const ServiceDetailState());

  Future<void> loadService() async {
    state = state.copyWith(service: const AsyncValue.loading());
    try {
      final svc = await _serviceService.fetchServiceById(_serviceId);
      state = state.copyWith(service: AsyncValue.data(svc));
    } catch (e, st) {
      state = state.copyWith(service: AsyncValue.error(e, st));
    }
  }

  Future<void> loadSlots() async {
    state = state.copyWith(slots: const AsyncValue.loading());
    try {
      final slotMap =
      await _serviceService.fetchAvailableSlots(_serviceId);
      state = state.copyWith(slots: AsyncValue.data(slotMap));
    } catch (e, st) {
      state = state.copyWith(slots: AsyncValue.error(e, st));
    }
  }

  void updateSelectedDate(DateTime date) {
    state = state.copyWith(
      selectedDate: date,
      selectedTime: null,
      status: BookingStatus.pending,
      errorMessage: null,
    );
  }

  void updateSelectedTime(TimeOfDay time) {
    state = state.copyWith(
      selectedTime: time,
      status: BookingStatus.pending,
      errorMessage: null,
    );
  }

  Future<void> createBookingSlot({
    required String serviceName,
    required int priceCents,
  }) async {
    final date = state.selectedDate;
    final time = state.selectedTime;
    if (date == null || time == null) return;

    state = state.copyWith(status: BookingStatus.pending, errorMessage: null);

    try {
      // combine date & time, then UTC
      final localDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
      final scheduledForUtc = localDateTime.toUtc();

      final booking = Booking(
        id: '',
        serviceId: _serviceId,
        serviceName: serviceName,
        scheduledFor: scheduledForUtc,
        status: BookingStatus.pending,
        priceCents: priceCents,
      );

      final success = await _bookingService.createBooking(booking);
      state = state.copyWith(
        status:
        success ? BookingStatus.confirmed : BookingStatus.cancelled,
        errorMessage:
        success ? null : 'Nie udało się utworzyć rezerwacji.',
      );
    } catch (e, st) {
      state = state.copyWith(
        status: BookingStatus.cancelled,
        errorMessage: e.toString(),
      );
    }
  }
}
