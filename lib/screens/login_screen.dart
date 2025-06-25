import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _pass  = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() => _isLoading = true);
    final res = await Supabase.instance.client.auth.signInWithPassword(
      email: _email.text,
      password: _pass.text,
    );
    setState(() => _isLoading = false);
    if (res.session != null) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed')),
      );
    }
  }

  @override
  Widget build(BuildContext c) {
    return Scaffold(
      appBar: AppBar(title: const Text('Logowanie')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _email, decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: 12),
            TextField(controller: _pass, obscureText: true, decoration: const InputDecoration(labelText: 'Hasło')),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _login,
              child: _isLoading
                  ? const SizedBox(height:24, width:24, child: CircularProgressIndicator(strokeWidth:2,color:Colors.white))
                  : const Text('Zaloguj'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/register'),
              child: const Text('Nie masz konta? Zarejestruj się'),
            )
          ],
        ),
      ),
    );
  }
}
