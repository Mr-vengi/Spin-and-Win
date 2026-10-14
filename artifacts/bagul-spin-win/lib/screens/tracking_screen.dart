import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/gift_order.dart';
import '../models/product.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';

class TrackingScreen extends StatelessWidget {
  const TrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(title: const Text('Gift tracking')),
      body: state.orders.isEmpty
          ? _EmptyTracking(
              onPlay: () => Navigator.pushReplacementNamed(context, '/levels'),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 26),
              itemCount: state.orders.length + 1,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                if (index == 0) return const _DeliveryNotice();
                final order = state.orders[index - 1];
                return _OrderCard(order: order);
              },
            ),
    );
  }
}

class _DeliveryNotice extends StatelessWidget {
  const _DeliveryNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.green,
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Row(
        children: [
          Icon(Icons.local_shipping_outlined, color: AppColors.gold, size: 28),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Max 5 to 7 Days for delivery',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order});

  final GiftOrder order;

  @override
  Widget build(BuildContext context) {
    final product = Product.byId(order.productId);
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.orange.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.orange.withValues(alpha: 0.13),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(product.icon, color: AppColors.green),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    Text(
                      'Order #${order.id.substring(order.id.length - 6)}',
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              _StatusPill(status: order.status),
            ],
          ),
          const SizedBox(height: 20),
          _StatusTimeline(currentIndex: order.statusIndex),
          const SizedBox(height: 14),
          const Text(
            'Max 5 to 7 Days for delivery',
            style: TextStyle(fontSize: 12, color: AppColors.muted),
          ),
          if (order.statusIndex < GiftOrder.statuses.length - 1) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () =>
                    context.read<AppState>().advanceOrder(order.id),
                icon: const Icon(Icons.update),
                label: const Text('Simulate next tracking update'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: const TextStyle(
          color: AppColors.green,
          fontWeight: FontWeight.w700,
          fontSize: 10,
        ),
      ),
    );
  }
}

class _StatusTimeline extends StatelessWidget {
  const _StatusTimeline({required this.currentIndex});

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(GiftOrder.statuses.length, (index) {
        final completed = index <= currentIndex;
        return Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  if (index > 0)
                    Expanded(
                      child: Container(
                        height: 2,
                        color: index <= currentIndex
                            ? AppColors.green
                            : const Color(0xFFE5DED1),
                      ),
                    )
                  else
                    const Expanded(child: SizedBox(height: 2)),
                  Container(
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: completed ? AppColors.green : AppColors.cream,
                      border: Border.all(
                        color: completed
                            ? AppColors.green
                            : const Color(0xFFCCBEA7),
                        width: 2,
                      ),
                    ),
                    child: completed
                        ? const Icon(Icons.check, size: 9, color: Colors.white)
                        : null,
                  ),
                  if (index < GiftOrder.statuses.length - 1)
                    Expanded(
                      child: Container(
                        height: 2,
                        color: index < currentIndex
                            ? AppColors.green
                            : const Color(0xFFE5DED1),
                      ),
                    )
                  else
                    const Expanded(child: SizedBox(height: 2)),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                GiftOrder.statuses[index],
                style: TextStyle(
                  color: completed ? AppColors.greenDeep : AppColors.muted,
                  fontSize: 9,
                  fontWeight: completed ? FontWeight.w700 : FontWeight.w400,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _EmptyTracking extends StatelessWidget {
  const _EmptyTracking({required this.onPlay});

  final VoidCallback onPlay;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.card_giftcard, size: 65, color: AppColors.orange),
            const SizedBox(height: 15),
            Text(
              'No gifts to track yet',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            const Text('Your won gifts will show up here.'),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: onPlay,
              child: const Text('Choose a level'),
            ),
          ],
        ),
      ),
    );
  }
}
