// lib/providers/service_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/models/service.dart';

final servicesProvider = FutureProvider<List<Service>>((ref) async {
  final data = await Supabase.instance.client
      .from('services')
      .select<List<Map<String, dynamic>>>();

  return data.map(Service.fromMap).toList();
});
