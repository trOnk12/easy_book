// lib/screens/my_bookings_screen.dart

import 'package:easy_book/core/auth_provider.dart';
import 'package:easy_book/core/models/booking.dart';
import 'package:easy_book/features/my_bookings/my_bookings_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyBookingsScreen extends ConsumerWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authUserProvider);
    if (user == null) {
      return const _NotLoggedInView();
    }

    final state = ref.watch(myBookingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Moje rezerwacje')),
      body: state.bookings.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Błąd: $error')),
        data: (List<Booking> bookings) {
          if (bookings.isEmpty) return const _EmptyView();

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              return _BookingListTile(booking: booking);
            },
          );
        },
      ),
    );
  }
}

class _BookingListTile extends ConsumerWidget {
  final Booking booking;

  const _BookingListTile({required this.booking});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(myBookingsProvider.notifier);

    return Card(
      child: ListTile(
        leading: const Icon(Icons.event_available),
        title: Text(
          booking.serviceName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('${booking.formattedDate} • ${booking.formattedTime}'),
        trailing:
            booking.status != 'cancelled'
                ? IconButton(
                  icon: const Icon(Icons.cancel, color: Colors.red),
                  onPressed: () async {
                    final ok = await viewModel.cancelBooking(booking.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          ok
                              ? 'Anulowano rezerwację'
                              : 'Błąd podczas anulowania',
                        ),
                      ),
                    );
                  },
                )
                : const Text('Anulowana', style: TextStyle(color: Colors.grey)),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 64,
              color: Theme.of(context).disabledColor,
            ),
            const SizedBox(height: 16),
            Text(
              'Nie masz jeszcze żadnych rezerwacji.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.search),
              label: const Text('Zarezerwuj usługę'),
              onPressed:
                  () => Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/home',
                    (_) => false,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotLoggedInView extends StatelessWidget {
  const _NotLoggedInView();

  @override
  Widget build(BuildContext context) {
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
              Text(
                'Musisz być zalogowany, aby zobaczyć swoje rezerwacje.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/login'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(180, 48),
                ),
                child: const Text('Zaloguj się'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
