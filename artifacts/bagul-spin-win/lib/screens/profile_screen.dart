import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_state.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final user = state.user;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 23, 20, 26),
      children: [
        Text(
          'Your profile',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(19),
          decoration: BoxDecoration(
            color: AppColors.green,
            borderRadius: BorderRadius.circular(21),
          ),
          child: Row(
            children: [
              Container(
                width: 62,
                height: 62,
                decoration: const BoxDecoration(
                  color: AppColors.gold,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person,
                  size: 36,
                  color: AppColors.greenDeep,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.name ?? 'Bagul player',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      user?.email.isNotEmpty == true
                          ? user!.email
                          : 'Local demo profile',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 17),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.account_balance_wallet_outlined,
                color: AppColors.green,
              ),
              const SizedBox(width: 11),
              const Expanded(
                child: Text(
                  'Wallet balance',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              Text(
                '₹${user?.balance ?? 0}',
                style: const TextStyle(
                  color: AppColors.green,
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _ProfileAction(
          icon: Icons.location_on_outlined,
          title: 'Delivery address',
          subtitle: state.hasAddress
              ? state.address['fullAddress']!
              : 'Add an address to claim a gift',
          onTap: () => Navigator.pushNamed(context, '/address'),
        ),
        _ProfileAction(
          icon: Icons.local_shipping_outlined,
          title: 'Gift tracking',
          subtitle:
              '${state.orders.length} ${state.orders.length == 1 ? 'gift' : 'gifts'}',
          onTap: () => Navigator.pushNamed(context, '/tracking'),
        ),
        _ProfileAction(
          icon: Icons.card_giftcard_outlined,
          title: 'Referral code',
          subtitle: user?.referralCode ?? 'BAGUL345',
          onTap: () => Navigator.pushReplacementNamed(context, '/refer'),
        ),
        const SizedBox(height: 15),
        OutlinedButton.icon(
          onPressed: () {
            context.read<AppState>().logout();
            Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
          },
          icon: const Icon(Icons.logout),
          label: const Text('Log out'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.green,
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Profile, balance, referrals, and gift orders are stored locally on this device.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.muted, fontSize: 11),
        ),
      ],
    );
  }
}

class _ProfileAction extends StatelessWidget {
  const _ProfileAction({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 9),
      color: Colors.white,
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: AppColors.green),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
