import 'package:easy_book/core/service/service_provider.dart';
import 'package:easy_book/core/service/services_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'service_list_state.dart';


final serviceListProvider = StateNotifierProvider.autoDispose<
    ServiceListViewModel,
    ServiceListState>(
      (ref) => ServiceListViewModel(ref.read(serviceServiceProvider))..loadServices(),
);

class ServiceListViewModel extends StateNotifier<ServiceListState> {
  final ServiceService _service;

  ServiceListViewModel(this._service) : super(const ServiceListState());

  Future<void> loadServices() async {
    state = state.copyWith(services: const AsyncValue.loading());
    try {
      final services = await _service.fetchAllServices();
      state = state.copyWith(services: AsyncValue.data(services));
    } catch (e, st) {
      state = state.copyWith(services: AsyncValue.error(e, st));
    }
  }
}
