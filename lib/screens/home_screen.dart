import 'package:flutter/material.dart';
import 'package:easy_book/features/service_list/service_list_screen.dart';

/// Home przekierowuje tylko do katalogu usług.
/// Filtry i featured możesz dorobić później – na MVP wystarczy lista.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ServiceListScreen();   // <-- cała logika w osobnym pliku
  }
}
