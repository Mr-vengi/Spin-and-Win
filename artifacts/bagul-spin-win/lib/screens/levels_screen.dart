import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_state.dart';
import '../theme/app_theme.dart';

class LevelsScreen extends StatelessWidget {
  const LevelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 28),
      children: [
        Text(
          'Choose your spin',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 5),
        Text(
          'Pick an entry level and try your luck. Your balance is ₹${state.user?.balance ?? 0}.',
          style: const TextStyle(color: AppColors.muted),
        ),
        const SizedBox(height: 21),
        _LevelCard(
          level: 'LEVEL 1',
          fee: 20,
          subtitle: 'A guaranteed gift on every spin',
          icon: Icons.bolt,
          accent: const Color(0xFF12A483),
          guaranteed: true,
        ),
        const SizedBox(height: 13),
        _LevelCard(
          level: 'LEVEL 2',
          fee: 50,
          subtitle: 'Bigger prizes. Guaranteed win.',
          icon: Icons.stars,
          accent: const Color(0xFF3984E9),
          guaranteed: true,
        ),
        const SizedBox(height: 13),
        _LevelCard(
          level: 'LEVEL 3',
          fee: 100,
          subtitle: 'Go for the grand prize',
          icon: Icons.workspace_premium,
          accent: const Color(0xFFE98C24),
          guaranteed: false,
          featured: true,
        ),
        if (state.freeSpins > 0) ...[
          const SizedBox(height: 22),
          _LevelCard(
            level: 'FREE SPIN',
            fee: 0,
            subtitle:
                '${state.freeSpins} free ${state.freeSpins == 1 ? 'spin' : 'spins'} earned from referrals',
            icon: Icons.card_giftcard,
            accent: AppColors.green,
            guaranteed: true,
            isFreeSpin: true,
          ),
        ],
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.orange.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Row(
            children: [
              Icon(Icons.info_outline, color: AppColors.green),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Entry fees are deducted before the wheel starts. Level 3 can land on Try Again.',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LevelCard extends StatelessWidget {
  const _LevelCard({
    required this.level,
    required this.fee,
    required this.subtitle,
    required this.icon,
    required this.accent,
    required this.guaranteed,
    this.featured = false,
    this.isFreeSpin = false,
  });

  final String level;
  final int fee;
  final String subtitle;
  final IconData icon;
  final Color accent;
  final bool guaranteed;
  final bool featured;
  final bool isFreeSpin;

  void _start(BuildContext context) {
    final config = SpinConfig(
      entryFee: fee,
      guaranteedWin: guaranteed,
      isFreeSpin: isFreeSpin,
    );
    if (!context.read<AppState>().startLevel(config)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Insufficient Balance')));
      return;
    }
    Navigator.pushNamed(context, '/spin-wheel', arguments: config);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: featured ? AppColors.green : Colors.white,
      borderRadius: BorderRadius.circular(21),
      child: InkWell(
        onTap: () => _start(context),
        borderRadius: BorderRadius.circular(21),
        child: Padding(
          padding: const EdgeInsets.all(17),
          child: Row(
            children: [
              Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(17),
                ),
                child: Icon(
                  icon,
                  color: featured ? AppColors.gold : accent,
                  size: 29,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      level,
                      style: TextStyle(
                        fontSize: 11,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w800,
                        color: featured ? AppColors.gold : accent,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: featured ? Colors.white70 : AppColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    isFreeSpin ? 'FREE' : '₹$fee',
                    style: TextStyle(
                      color: featured ? Colors.white : AppColors.greenDeep,
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward,
                    color: featured ? AppColors.gold : AppColors.green,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
