import 'package:flutter/material.dart';

class BookingConfirmationScreen extends StatelessWidget {
  final String service;
  final String date;
  final String time;

  const BookingConfirmationScreen({
    super.key,
    required this.service,
    required this.date,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Potwierdzenie"),
        automaticallyImplyLeading: false, // Brak strzałki „wstecz”
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle_outline,
                  color: Colors.green, size: 80),
              const SizedBox(height: 24),
              Text(
                "Dziękujemy za rezerwację!",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                "Zarezerwowano usługę:",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 8),
              Text(
                service,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                "$date o $time",
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                icon: const Icon(Icons.home),
                label: const Text("Wróć do strony głównej"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                ),
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
