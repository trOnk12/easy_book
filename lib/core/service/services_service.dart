import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/service.dart';

class ServiceService {
  final SupabaseClient _client;
  ServiceService(this._client);

  /// Fetches the service details by ID.
  Future<Service> fetchServiceById(String id) async {
    final resp = await _client
        .from('services')
        .select()
        .eq('id', id)
        .single();
    if (resp.error != null) throw resp.error!;
    return Service.fromMap(resp.data as Map<String, dynamic>);
  }

  /// Fetches available slots for a service,
  /// grouping them into human‐readable date labels → times.
  Future<Map<String, List<String>>> fetchAvailableSlots(
      String serviceId) async {
    final resp = await _client
        .from('service_slots')
        .select()
        .eq('service_id', serviceId)
        .order('slot', ascending: true);
    if (resp.error != null) throw resp.error!;
    final List rows = resp.data as List;

    // Map<DateLabel, List<HH:mm>>
    final slots = <String, List<String>>{};
    for (var row in rows.cast<Map<String, dynamic>>()) {
      final dt = DateTime.parse(row['slot'] as String).toLocal();
      final dateLabel = DateFormat('EEE dd.MM', 'pl_PL').format(dt);
      final timeLabel = DateFormat('HH:mm').format(dt);
      slots.putIfAbsent(dateLabel, () => []).add(timeLabel);
    }
    return slots;
  }

  /// Fetches all services from Supabase
  Future<List<Service>> fetchAllServices() async {
    final response = await _client
        .from('services')
        .select()
        .order('title', ascending: true);

    if (response.error != null) {
      throw response.error!;
    }

    final List data = response as List;
    return data.map((e) => Service.fromMap(e)).toList();
  }
}
