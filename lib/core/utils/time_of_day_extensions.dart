import 'package:flutter/material.dart';

extension TimeOfDayExtensions on TimeOfDay {
  /// Formats a TimeOfDay as a zero-padded “HH:mm” string.
  String to24hString() {
    final hours = hour.toString().padLeft(2, '0');
    final minutes = minute.toString().padLeft(2, '0');
    return '$hours:$minutes';
  }
}