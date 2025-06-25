// lib/features/service_list/service_list_state.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/service.dart';

/// Holds the async state of fetching the list of services.
class ServiceListState {
  final AsyncValue<List<Service>> services;

  const ServiceListState({
    this.services = const AsyncValue<List<Service>>.loading(),
  });

  ServiceListState copyWith({
    AsyncValue<List<Service>>? services,
  }) {
    return ServiceListState(
      services: services ?? this.services,
    );
  }
}
