// lib/screens/my_bookings_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../providers/booking_provider.dart';
import '../core/models/booking.dart';

class MyBookingsScreen extends ConsumerWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1) Check auth state first
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      // Not logged in: prompt to log in
      return Scaffold(
        appBar: AppBar(title: const Text('Moje rezerwacje')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock_outline, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                const Text(
                  'Musisz być zalogowany, aby zobaczyć swoje rezerwacje.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/login'),
                  child: const Text('Zaloguj się'),
                  style: ElevatedButton.styleFrom(minimumSize: const Size(180, 48)),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // 2) User is logged in: show real bookings
    final bookingsAsync = ref.watch(bookingListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Moje rezerwacje')),
      body: bookingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Błąd: ${e.toString()}')),
        data: (bookings) {
          if (bookings.isEmpty) {
            return _buildEmpty(context);
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: bookings.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (ctx, i) {
              final b = bookings[i];
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.event_available, size: 32),
                  title: Text(b.serviceName,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    '${b.date.toLocal().toIso8601String().substring(0,10)} • ${b.time}',
                  ),
                  trailing: b.status != 'cancelled'
                      ? IconButton(
                    icon: const Icon(Icons.cancel, color: Colors.red),
                    onPressed: () async {
                      final ok = await ref
                          .read(bookingControllerProvider.notifier)
                          .cancelBooking(b.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(ok
                                ? 'Anulowano rezerwację'
                                : 'Błąd podczas anulowania')),
                      );
                    },
                  )
                      : const Text('Anulowana',
                      style: TextStyle(color: Colors.grey)),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.calendar_today_outlined,
                size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'Nie masz jeszcze żadnych rezerwacji.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.search),
              label: const Text('Zarezerwuj usługę'),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/home',
                      (route) => false, // usuń wszystkie wcześniejsze trasy
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
