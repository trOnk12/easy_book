import 'package:easy_book/screens/login_screen.dart';
import 'package:easy_book/screens/main_navigation_screen.dart';
import 'package:easy_book/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/welcome_screen.dart';
import 'config/client_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://wvlbbswarvdzrdwyvlyn.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Ind2bGJic3dhcnZkenJkd3l2bHluIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDU0MDc3NjQsImV4cCI6MjA2MDk4Mzc2NH0.vrRlR6hbk3wswA9-7g-COErG_njq-QsAbD1MJhm4vnI',
  );

  runApp(
    const ProviderScope(                         // ← wrap here
      child: MyApp(config: massageClient),
    ),
  );
}

class MyApp extends StatelessWidget {
  final ClientConfig config;

  const MyApp({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: config.appName,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: config.primaryColor),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => WelcomeScreen(config: config),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const MainNavigationScreen(),
      },
    );
  }
}