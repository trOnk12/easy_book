// lib/screens/service_details_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'service_detail_state.dart';
import 'service_detail_view_model.dart';
import '../../screens/booking_confirmation_screen.dart';

class ServiceDetailScreen extends ConsumerStatefulWidget {
  final String serviceId;
  final String title;
  final String duration;
  final String price;

  const ServiceDetailScreen({
    super.key,
    required this.serviceId,
    required this.title,
    required this.duration,
    required this.price,
  });

  @override
  ConsumerState<ServiceDetailScreen> createState() =>
      _ServiceDetailScreenState();
}

class _ServiceDetailScreenState
    extends ConsumerState<ServiceDetailScreen> {
  String selectedDateLabel = 'Dziś';
  String? selectedTimeLabel;

  // Hard-coded demo slots; you can later pull these from your VM or API.
  final Map<String, List<String>> availableSlots = {
    'Dziś': ['10:00', '11:30'],
    'Jutro': ['13:00', '15:30'],
    'Pn 22.04': ['09:00', '12:00', '14:00'],
  };

  bool get _canBook => selectedTimeLabel != null;

  DateTime _dateFromLabel(String label) {
    final now = DateTime.now();
    if (label == 'Dziś') return now;
    if (label == 'Jutro') return now.add(const Duration(days: 1));
    // e.g. "Pn 22.04"
    final parts = label.split(' ');
    if (parts.length == 2) {
      final parsed = DateFormat('dd.MM').parse(parts[1]);
      return DateTime(now.year, parsed.month, parsed.day);
    }
    return now;
  }

  TimeOfDay _timeOfDay(String s) {
    final parts = s.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  @override
  void initState() {
    super.initState();
    // initialize the VM with today
    ref
        .read(serviceDetailProvider(widget.serviceId).notifier)
        .updateDate(_dateFromLabel(selectedDateLabel));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(serviceDetailProvider(widget.serviceId));
    final vm = ref.read(serviceDetailProvider(widget.serviceId).notifier);

    // Listen for success/error and react
    ref.listen<ServiceDetailState>(
      serviceDetailProvider(widget.serviceId),
          (previous, next) {
        if (previous?.status != BookingStatus.success &&
            next.status == BookingStatus.success) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BookingConfirmationScreen(
                service: widget.title,
                date: selectedDateLabel,
                time: selectedTimeLabel!,
              ),
            ),
          );
        } else if (previous?.status != BookingStatus.error &&
            next.status == BookingStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(next.errorMessage ?? 'Wystąpił błąd')),
          );
        }
      },
    );

    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton.icon(
          icon: state.status == BookingStatus.loading
              ? const SizedBox(
            width: 16,
            height: 16,
            child:
            CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
          )
              : const Icon(Icons.calendar_today),
          label: Text('Zarezerwuj za ${widget.price}'),
          onPressed: _canBook && state.status != BookingStatus.loading
              ? () => vm.book(
            serviceTitle: widget.title,
            price: widget.price,
          )
              : null,
          style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(child: _buildDetails(vm)),
        ],
      ),
    );
  }

  SliverAppBar _buildAppBar() => SliverAppBar(
    expandedHeight: 220,
    pinned: true,
    flexibleSpace: FlexibleSpaceBar(
      title: Text(widget.title),
      background: Image.network(
        'https://via.placeholder.com/400x300',
        fit: BoxFit.cover,
      ),
    ),
  );

  Widget _buildDetails(ServiceDetailViewModel vm) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          '${widget.duration} • ${widget.price}',
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 16),
        const Text(
          'Opis usługi',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text('Deep tissue massage...'),
        const SizedBox(height: 24),
        _buildInfoSection(),
        const SizedBox(height: 32),
        _buildPerformer(),
        const SizedBox(height: 32),
        _buildReviews(),
        const SizedBox(height: 32),
        const Text(
          'Wybierz termin',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _buildDateChips(vm),
        const SizedBox(height: 12),
        _buildTimeChips(vm),
        const SizedBox(height: 24),
      ]),
    );
  }

  Widget _buildInfoSection() => Column(
    children: [
      Row(children: [
        const Icon(Icons.timer),
        const SizedBox(width: 8),
        Text('Czas: ${widget.duration}'),
      ]),
      const SizedBox(height: 8),
      Row(children: [
        const Icon(Icons.euro),
        const SizedBox(width: 8),
        Text('Cena: ${widget.price}'),
      ]),
      const SizedBox(height: 8),
      Row(children: const [
        Icon(Icons.place),
        SizedBox(width: 8),
        Text('Green Studio, ul. Zielona 3'),
      ]),
    ],
  );

  Widget _buildPerformer() => Row(children: [
    const CircleAvatar(
      radius: 24,
      backgroundImage: NetworkImage('https://via.placeholder.com/150'),
    ),
    const SizedBox(width: 12),
    Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
      Text('Anna Nowak', style: TextStyle(fontWeight: FontWeight.bold)),
      Row(children: [
        Icon(Icons.star, color: Colors.amber, size: 16),
        Icon(Icons.star, color: Colors.amber, size: 16),
        Icon(Icons.star, color: Colors.amber, size: 16),
        Icon(Icons.star, color: Colors.amber, size: 16),
        Icon(Icons.star_half, color: Colors.amber, size: 16),
        SizedBox(width: 4),
        Text('4.5 (32)', style: TextStyle(color: Colors.grey)),
      ]),
    ]),
  ]);

  Widget _buildReviews() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Opinie klientów',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 12),
      _buildReviewTile('Kasia W.', 'Świetna usługa, bardzo profesjonalna!'),
      _buildReviewTile('Tomasz M.', 'Miła atmosfera i dokładność wykonania.'),
      TextButton(onPressed: () {}, child: const Text('Zobacz wszystkie')),
    ],
  );

  Widget _buildReviewTile(String name, String review) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(children: [
        const Icon(Icons.person),
        const SizedBox(width: 8),
        Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
      ]),
      const SizedBox(height: 4),
      Row(children: const [
        Icon(Icons.star, color: Colors.amber),
        Icon(Icons.star, color: Colors.amber),
        Icon(Icons.star, color: Colors.amber),
        Icon(Icons.star, color: Colors.amber),
        Icon(Icons.star_border, color: Colors.amber),
      ]),
      const SizedBox(height: 4),
      Text(review),
      const Divider(height: 24),
    ],
  );

  Widget _buildDateChips(ServiceDetailViewModel vm) => SizedBox(
    height: 40,
    child: ListView(
      scrollDirection: Axis.horizontal,
      children: availableSlots.keys.map((label) {
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ChoiceChip(
            label: Text(label),
            selected: selectedDateLabel == label,
            onSelected: (_) {
              setState(() {
                selectedDateLabel = label;
                selectedTimeLabel = null;
              });
              vm.updateDate(_dateFromLabel(label));
            },
          ),
        );
      }).toList(),
    ),
  );

  Widget _buildTimeChips(ServiceDetailViewModel vm) => Wrap(
    spacing: 8,
    children: (availableSlots[selectedDateLabel] ?? []).map((time) {
      return ChoiceChip(
        label: Text(time),
        selected: selectedTimeLabel == time,
        onSelected: (_) {
          setState(() {
            selectedTimeLabel = time;
          });
          vm.updateTime(_timeOfDay(time));
        },
      );
    }).toList(),
  );
}
