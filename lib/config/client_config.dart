import 'package:flutter/material.dart';

class ClientConfig {
  final String appName;
  final String welcomeMessage;
  final String logoAsset;
  final Color primaryColor;

  const ClientConfig({
    required this.appName,
    required this.welcomeMessage,
    required this.logoAsset,
    required this.primaryColor,
  });
}

// Example client: massage studio
const massageClient = ClientConfig(
  appName: 'EasyBook – Massage Zen',
  welcomeMessage: 'Book time just for yourself',
  logoAsset: 'assets/logo_massage.png',
  primaryColor: Color(0xFF3366FF),
);

// Another example: yoga studio
const yogaClient = ClientConfig(
  appName: 'EasyBook – YogaFlow',
  welcomeMessage: 'Your calm ritual starts here',
  logoAsset: 'assets/logo_yoga.png',
  primaryColor: Color(0xFF4CAF50),
);