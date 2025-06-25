// lib/features/service_detail/service_detail_state.dart

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Represents the current booking process state.
enum BookingStatus { idle, loading, success, error }

/// Holds all UI state for ServiceDetailScreen.
class ServiceDetailState extends Equatable {
  /// The date the user picked.
  final DateTime? selectedDate;

  /// The time the user picked.
  final TimeOfDay? selectedTime;

  /// The current booking call status.
  final BookingStatus status;

  /// Optional error message if booking failed.
  final String? errorMessage;

  const ServiceDetailState({
    this.selectedDate,
    this.selectedTime,
    this.status = BookingStatus.idle,
    this.errorMessage,
  });

  ServiceDetailState copyWith({
    DateTime? selectedDate,
    TimeOfDay? selectedTime,
    BookingStatus? status,
    String? errorMessage,
  }) {
    return ServiceDetailState(
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [selectedDate, selectedTime, status, errorMessage];
}
