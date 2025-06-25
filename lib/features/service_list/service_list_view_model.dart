// lib/features/service_list/service_list_view_model.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/service_provider.dart';
import 'service_list_state.dart';

/// Exposes a notifier that fetches and holds the list of services.
final serviceListProvider = StateNotifierProvider.autoDispose<
    ServiceListViewModel,
    ServiceListState>(
      (ref) => ServiceListViewModel(ref),
);

class ServiceListViewModel extends StateNotifier<ServiceListState> {
  final Ref _ref;

  ServiceListViewModel(this._ref) : super(const ServiceListState()) {
    loadServices();
  }

  /// Loads services by reading the existing FutureProvider
  Future<void> loadServices() async {
    state = state.copyWith(services: const AsyncValue.loading());
    try {
      final services = await _ref.read(servicesProvider.future);
      state = state.copyWith(services: AsyncValue.data(services));
    } catch (e, st) {
      state = state.copyWith(services: AsyncValue.error(e, st));
    }
  }
}
