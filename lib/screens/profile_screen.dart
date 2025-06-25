import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (user != null) ...[
              Text('Zalogowany jako:', style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 8),
              Text(user.email ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
              const Spacer(),
              ElevatedButton.icon(
                icon: const Icon(Icons.logout),
                label: const Text('Wyloguj'),
                onPressed: () async {
                  await Supabase.instance.client.auth.signOut();
                  Navigator.pushReplacementNamed(context, '/');
                },
                style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
              ),
            ] else ...[
              const Spacer(),
              const Text('Nie jesteś zalogowany.'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/login'),
                child: const Text('Zaloguj się'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
