// lib/screens/service_detail_screen.dart

import 'package:easy_book/core/models/booking_status.dart';
import 'package:easy_book/core/models/service.dart';
import 'package:easy_book/features/service_detail/service_detail_view_model.dart';
import 'package:easy_book/screens/booking_confirmation_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'service_detail_state.dart';


class ServiceDetailScreen extends ConsumerStatefulWidget {
  final String serviceId;

  const ServiceDetailScreen({
    Key? key,
    required this.serviceId,
  }) : super(key: key);

  @override
  ConsumerState<ServiceDetailScreen> createState() =>
      _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends ConsumerState<ServiceDetailScreen> {
  String? _selectedDateLabel;
  String? _selectedTimeLabel;

  @override
  void initState() {
    super.initState();
    // Automatically pick the first date once slots load
    ref.listen<AsyncValue<Map<String, List<String>>>>(
      serviceDetailProvider(widget.serviceId).select((s) => s.slots),
          (_, slots) => slots.whenData((map) {
        final firstDate = map.keys.firstOrNull;
        if (firstDate != null) {
          setState(() {
            _selectedDateLabel = firstDate;
            _selectedTimeLabel = null;
          });
          ref
              .read(serviceDetailProvider(widget.serviceId).notifier)
              .updateSelectedDate(_parseDate(firstDate));
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final detailState = ref.watch(serviceDetailProvider(widget.serviceId));
    final viewModel = ref.read(serviceDetailProvider(widget.serviceId).notifier);
    final serviceState = detailState.service;
    final slotsState = detailState.slots;

    // 1) Full-page loading
    if (serviceState.isLoading || slotsState.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // 2) Full-page error
    if (serviceState.hasError || slotsState.hasError) {
      final error = serviceState.hasError
          ? serviceState.error
          : slotsState.error;
      return Scaffold(
        appBar: AppBar(title: const Text('Szczegóły usługi')),
        body: Center(child: Text(error.toString())),
      );
    }

    // 3) Both loaded ⇒ safe to call `.value!`
    final Service service = serviceState.value!;
    final Map<String, List<String>> slotsByDate = slotsState.value!;

    // 4) Listen for booking result
    ref.listen<ServiceDetailState>(
      serviceDetailProvider(widget.serviceId),
          (previous, next) {
        if (previous?.status != BookingStatus.confirmed &&
            next.status == BookingStatus.confirmed) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => BookingConfirmationScreen(
              service: service.title,
              date: _selectedDateLabel!,
              time: _selectedTimeLabel!,
            ),
          ));
        } else if (previous?.status != BookingStatus.cancelled &&
            next.status == BookingStatus.cancelled) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(next.errorMessage ?? 'Wystąpił błąd')),
          );
        }
      },
    );

    return Scaffold(
      bottomNavigationBar: _BookButton(
        isLoading: detailState.status == BookingStatus.pending,
        isEnabled:
        _selectedDateLabel != null && _selectedTimeLabel != null,
        onPressed: () {
          viewModel.createBookingSlot(
            serviceName: service.title,
            priceCents: (double.parse(service.price) * 100).toInt(),
          );
        },
      ),
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(service.title),
              background: Image.network(service.imageUrl, fit: BoxFit.cover),
            ),
          ),
        ],
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${service.duration} • ${service.price}',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.grey)),
              const SizedBox(height: 24),
              Text(service.description),
              const SizedBox(height: 32),
              const Text('Wybierz termin',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _SlotPicker(
                slotsByDate: slotsByDate,
                selectedDate: _selectedDateLabel,
                selectedTime: _selectedTimeLabel,
                onDateSelected: (label) {
                  setState(() {
                    _selectedDateLabel = label;
                    _selectedTimeLabel = null;
                  });
                  viewModel.updateSelectedDate(_parseDate(label));
                },
                onTimeSelected: (label) {
                  setState(() => _selectedTimeLabel = label);
                  viewModel.updateSelectedTime(_parseTime(label));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  DateTime _parseDate(String label) {
    final now = DateTime.now();
    if (label == 'Dziś') return now;
    if (label == 'Jutro') return now.add(const Duration(days: 1));
    final parts = label.split(' ');
    if (parts.length == 2) {
      final parsed = DateFormat('dd.MM').parse(parts[1]);
      return DateTime(now.year, parsed.month, parsed.day);
    }
    return now;
  }

  TimeOfDay _parseTime(String label) {
    final parts = label.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }
}

class _BookButton extends StatelessWidget {
  final bool isLoading;
  final bool isEnabled;
  final VoidCallback onPressed;

  const _BookButton({
    Key? key,
    required this.isLoading,
    required this.isEnabled,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton.icon(
        icon: isLoading
            ? const SizedBox(
          width: 16,
          height: 16,
          child:
          CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
        )
            : const Icon(Icons.calendar_today),
        label: Text(isLoading ? 'Przetwarzanie…' : 'Zarezerwuj'),
        onPressed: isEnabled && !isLoading ? onPressed : null,
        style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
      ),
    );
  }
}

class _SlotPicker extends StatelessWidget {
  final Map<String, List<String>> slotsByDate;
  final String? selectedDate;
  final String? selectedTime;
  final ValueChanged<String> onDateSelected;
  final ValueChanged<String> onTimeSelected;

  const _SlotPicker({
    Key? key,
    required this.slotsByDate,
    required this.selectedDate,
    required this.selectedTime,
    required this.onDateSelected,
    required this.onTimeSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemCount: slotsByDate.length,
            itemBuilder: (context, i) {
              final dateLabel = slotsByDate.keys.elementAt(i);
              return ChoiceChip(
                label: Text(dateLabel),
                selected: dateLabel == selectedDate,
                onSelected: (_) => onDateSelected(dateLabel),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        if (selectedDate != null)
          Wrap(
            spacing: 8,
            children: slotsByDate[selectedDate!]!
                .map((timeLabel) => ChoiceChip(
              label: Text(timeLabel),
              selected: timeLabel == selectedTime,
              onSelected: (_) => onTimeSelected(timeLabel),
            ))
                .toList(),
          ),
      ],
    );
  }
}
