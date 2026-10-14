import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../providers/app_state.dart';
import '../theme/app_theme.dart';

class ReferScreen extends StatelessWidget {
  const ReferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final code = state.user?.referralCode ?? 'BAGUL345';
    final progress = state.referralCount % 3;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 23, 20, 26),
      children: [
        Text(
          'Gift a friend a spin',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 5),
        const Text(
          'Invite your people. Earn a free spin together.',
          style: TextStyle(color: AppColors.muted),
        ),
        const SizedBox(height: 21),
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: AppColors.green,
            borderRadius: BorderRadius.circular(23),
            boxShadow: const [
              BoxShadow(
                color: Color(0x24144035),
                blurRadius: 16,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              const Icon(Icons.card_giftcard, size: 46, color: AppColors.gold),
              const SizedBox(height: 9),
              const Text(
                'YOUR REFERRAL CODE',
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    code,
                    style: const TextStyle(
                      color: AppColors.gold,
                      fontSize: 27,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Copy code',
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: code));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Referral code copied.')),
                      );
                    },
                    icon: const Icon(Icons.copy, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 9),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    SharePlus.instance.share(
                      ShareParams(
                        subject: 'Come spin with me on Bagul!',
                        text:
                            'Join me on Bagul Spin & Win and use my referral code $code for a chance to win real gifts.',
                      ),
                    );
                  },
                  icon: const Icon(Icons.share),
                  label: const Text('Share on WhatsApp'),
                  style: FilledButton.styleFrom(
                    foregroundColor: AppColors.greenDeep,
                    backgroundColor: AppColors.cream,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 19),
        Container(
          padding: const EdgeInsets.all(19),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.orange.withValues(alpha: 0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Refer 3 friends',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 4),
              const Text(
                'Get 1 free spin when three friends join with your code.',
              ),
              const SizedBox(height: 15),
              Row(
                children: List.generate(
                  3,
                  (index) => Expanded(
                    child: Container(
                      height: 8,
                      margin: EdgeInsets.only(right: index == 2 ? 0 : 7),
                      decoration: BoxDecoration(
                        color: index < progress
                            ? AppColors.green
                            : const Color(0xFFEDE6D9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '${state.referralCount} friends recorded · ${state.freeSpins} free spins available',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.green,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        OutlinedButton.icon(
          onPressed: () => _recordDemoFriend(context),
          icon: const Icon(Icons.person_add_alt_1),
          label: const Text('Record a friend (local demo)'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.green,
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
        const SizedBox(height: 7),
        const Text(
          'Referral counts are stored on this device for demo purposes; they are not verified with a server.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.muted, fontSize: 10),
        ),
      ],
    );
  }

  static Future<void> _recordDemoFriend(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Record a demo referral?'),
        content: const Text(
          'This only updates the local preview. It does not verify a real signup.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Record'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    final earned = context.read<AppState>().recordReferral();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          earned
              ? 'Three referrals reached — you earned a free spin!'
              : 'Referral recorded on this device.',
        ),
      ),
    );
  }
}
