// lib/core/providers/auth_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide Provider;

final authUserProvider = Provider<User?>((ref) {
  return Supabase.instance.client.auth.currentUser;
});