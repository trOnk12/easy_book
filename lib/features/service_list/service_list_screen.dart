// lib/screens/service_list_screen.dart

import 'package:easy_book/core/models/service.dart';
import 'package:easy_book/features/service_detail/service_details_screen.dart';
import 'package:easy_book/features/service_list/service_list_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ServiceListScreen extends ConsumerWidget {
  const ServiceListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(serviceListProvider.notifier);
    final state = ref.watch(serviceListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Usługi')),
      body: state.services.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _ErrorView(
          error: error.toString(),
          onRetry: viewModel.loadServices,
        ),
        data: (List<Service> services) {
          if (services.isEmpty) {
            return const _EmptyView();
          }
          return RefreshIndicator(
            onRefresh: viewModel.loadServices,
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: services.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final service = services[index];
                return ServiceListItem(
                  service: service,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ServiceDetailScreen(
                          serviceId: service.id,
                          title: service.title,
                          duration: service.duration,
                          price: service.price,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class ServiceListItem extends StatelessWidget {
  final Service service;
  final VoidCallback onTap;

  const ServiceListItem({
    Key? key,
    required this.service,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: service.imageUrl.isNotEmpty
            ? Image.network(
          service.imageUrl,
          width: 56,
          height: 56,
          fit: BoxFit.cover,
          semanticLabel: '${service.title} image',
        )
            : const Icon(
          Icons.spa,
          size: 40,
          semanticLabel: 'Default service icon',
        ),
        title: Text(
          service.title,
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${service.duration} • ${service.price}',
          style: textTheme.bodyMedium,
        ),
        trailing: const Icon(Icons.chevron_right, semanticLabel: 'Go to details'),
        onTap: onTap,
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String error;
  final Future<void> Function() onRetry;

  const _ErrorView({
    Key? key,
    required this.error,
    required this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Wystąpił błąd:\n$error', textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Spróbuj ponownie'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Brak dostępnych usług',
            style: textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
