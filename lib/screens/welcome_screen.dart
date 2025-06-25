import 'package:easy_book/shared/theme/app_strings.dart';
import 'package:flutter/material.dart';
import '../config/client_config.dart';

class WelcomeScreen extends StatelessWidget {
  final ClientConfig config;

  const WelcomeScreen({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              // Image.asset(
              //   config.logoAsset,
              //   height: 100,
              // ),w
              const SizedBox(height: 24),
              Text(
                config.welcomeMessage,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.onBackground,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(flex: 3),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/login'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: config.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(AppStrings.login),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/home'),
                child: const Text(AppStrings.guest),
              ),
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}