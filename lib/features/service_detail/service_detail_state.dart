// lib/features/service_detail/service_detail_state.dart

import 'package:flutter/material.dart';
import '../../core/models/service.dart';
import '../../core/models/booking_status.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ServiceDetailState {
  final AsyncValue<Service> service;
  final AsyncValue<Map<String, List<String>>> slots;
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final BookingStatus status;
  final String? errorMessage;

  const ServiceDetailState({
    this.service = const AsyncValue.loading(),
    this.slots = const AsyncValue.loading(),
    this.selectedDate,
    this.selectedTime,
    this.status = BookingStatus.idle,
    this.errorMessage,
  });

  ServiceDetailState copyWith({
    AsyncValue<Service>? service,
    AsyncValue<Map<String, List<String>>>? slots,
    DateTime? selectedDate,
    TimeOfDay? selectedTime,
    BookingStatus? status,
    String? errorMessage,
  }) {
    return ServiceDetailState(
      service: service ?? this.service,
      slots: slots ?? this.slots,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}
