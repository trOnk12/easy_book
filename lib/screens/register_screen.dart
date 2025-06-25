import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _email = TextEditingController();
  final _pass  = TextEditingController();
  bool _isLoading = false;

  Future<void> _register() async {
    setState(() => _isLoading = true);
    final res = await Supabase.instance.client.auth.signUp(
      email: _email.text,
      password: _pass.text,
    );
    setState(() => _isLoading = false);
    if (res.user != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sprawdź e-mail, aby potwierdzić konto')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration failed')),
      );
    }
  }

  @override
  Widget build(BuildContext c) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rejestracja')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _email, decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: 12),
            TextField(controller: _pass, obscureText: true, decoration: const InputDecoration(labelText: 'Hasło')),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _register,
              child: _isLoading
                  ? const SizedBox(height:24, width:24, child: CircularProgressIndicator(strokeWidth:2,color:Colors.white))
                  : const Text('Zarejestruj'),
            ),
          ],
        ),
      ),
    );
  }
}
