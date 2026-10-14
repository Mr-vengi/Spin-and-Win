import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/gift_order.dart';
import '../models/product.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/brand_mark.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final user = state.user;
    final firstName = (user?.name ?? 'Player').split(' ').first;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton.filledTonal(
                style: IconButton.styleFrom(backgroundColor: AppColors.cream),
                onPressed: () => _openQuickMenu(context),
                icon: const Icon(Icons.tune_rounded),
              ),
              const Spacer(),
              const Hero(tag: 'bagul-brand', child: BrandMark(compact: true)),
              const Spacer(),
              InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () =>
                    Navigator.pushReplacementNamed(context, '/profile'),
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.green,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.person, color: AppColors.gold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 19),
          AnimatedContainer(
            duration: const Duration(milliseconds: 320),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.fromLTRB(17, 13, 12, 12),
            decoration: BoxDecoration(
              color: AppColors.green,
              borderRadius: BorderRadius.circular(19),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x260F352B),
                  blurRadius: 14,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '₹ ${user?.balance ?? 345}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 29,
                          fontWeight: FontWeight.w800,
                          height: 1.1,
                        ),
                      ),
                      Text(
                        'Your Balance  ·  Hey, $firstName',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                _WalletButton(
                  icon: Icons.south_west,
                  label: 'Top up',
                  onPressed: () {
                    context.read<AppState>().topUp();
                    _toast(context, '₹100 added to your demo balance.');
                  },
                ),
                const SizedBox(width: 7),
                _WalletButton(
                  icon: Icons.north_east,
                  label: 'Withdraw',
                  onPressed: () {
                    final success = context.read<AppState>().withdraw();
                    _toast(
                      context,
                      success
                          ? '₹100 withdrawn.'
                          : 'You need at least ₹100 to withdraw.',
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          _PromoBanner(
            onTap: () => Navigator.pushReplacementNamed(context, '/levels'),
          ),
          const SizedBox(height: 22),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pick your level',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
              TextButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, '/levels'),
                child: const Text('See all'),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: const [
              Expanded(
                child: _LevelMiniCard(level: 'LEVEL 1', fee: '₹20'),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _LevelMiniCard(level: 'LEVEL 2', fee: '₹50'),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _LevelMiniCard(level: 'LEVEL 3', fee: '₹100'),
              ),
            ],
          ),
          const SizedBox(height: 22),
          _SectionHeading(
            title: 'Your gifts',
            trailing: TextButton(
              onPressed: () => Navigator.pushNamed(context, '/tracking'),
              child: const Text('Track gifts'),
            ),
          ),
          if (state.orders.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.greenDeep,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.card_giftcard,
                    color: AppColors.gold,
                    size: 32,
                  ),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Your first gift is waiting',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Play a level to find out what you win.',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.gold,
                    size: 15,
                  ),
                ],
              ),
            )
          else
            _LatestGiftCard(order: state.orders.first),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.greenDeep,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.local_shipping_outlined,
                  color: AppColors.gold,
                  size: 30,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Real gifts, delivered to your door',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pushNamed(context, '/tracking'),
                  icon: const Icon(Icons.arrow_forward, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static void _toast(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  static void _openQuickMenu(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.cream,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Quick menu',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                ),
              ),
              _MenuItem(
                icon: Icons.person_outline,
                title: 'Profile',
                onTap: () => _openRoute(sheetContext, context, '/profile'),
              ),
              _MenuItem(
                icon: Icons.location_on_outlined,
                title: 'Delivery address',
                onTap: () => _openRoute(sheetContext, context, '/address'),
              ),
              _MenuItem(
                icon: Icons.local_shipping_outlined,
                title: 'Gift tracking',
                onTap: () => _openRoute(sheetContext, context, '/tracking'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void _openRoute(BuildContext sheet, BuildContext page, String route) {
    Navigator.pop(sheet);
    Navigator.pushNamed(page, route);
  }
}

class _WalletButton extends StatelessWidget {
  const _WalletButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        minimumSize: const Size(72, 37),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.ink,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [Icon(icon, size: 13), const SizedBox(width: 4), Text(label)],
      ),
    );
  }
}

class _PromoBanner extends StatelessWidget {
  const _PromoBanner({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 166,
      decoration: BoxDecoration(
        color: AppColors.greenDeep,
        borderRadius: BorderRadius.circular(21),
        boxShadow: const [
          BoxShadow(
            color: Color(0x30134639),
            blurRadius: 14,
            offset: Offset(0, 7),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -8,
            top: 9,
            child: SizedBox(
              width: 160,
              height: 145,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: const Size(126, 126),
                    painter: _MiniWheelPainter(),
                  ),
                  const Positioned(
                    right: 7,
                    bottom: 4,
                    child: Icon(
                      Icons.redeem,
                      color: Color(0xFFFF6B9B),
                      size: 63,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 21, 18, 16),
            child: SizedBox(
              width: 180,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Spin to win\nreal gifts',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'serif',
                      fontSize: 24,
                      height: 1.08,
                    ),
                  ),
                  const Spacer(),
                  FilledButton(
                    onPressed: onTap,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.cream,
                      foregroundColor: AppColors.greenDeep,
                      minimumSize: const Size(108, 36),
                      padding: const EdgeInsets.symmetric(horizontal: 13),
                    ),
                    child: const Text(
                      'Order now',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniWheelPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide / 2;
    const colors = [
      AppColors.orange,
      AppColors.gold,
      Color(0xFF19A990),
      Color(0xFFEE5662),
      Color(0xFF5087E8),
      Color(0xFFE8B348),
    ];
    final paint = Paint()..style = PaintingStyle.fill;
    for (var i = 0; i < 8; i++) {
      paint.color = colors[i % colors.length];
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -3.14159 / 2 + i * 3.14159 / 4,
        3.14159 / 4,
        true,
        paint,
      );
    }
    canvas.drawCircle(center, 9, Paint()..color = AppColors.cream);
    canvas.drawCircle(center, 5, Paint()..color = AppColors.gold);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _LevelMiniCard extends StatelessWidget {
  const _LevelMiniCard({required this.level, required this.fee});

  final String level;
  final String fee;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: () => Navigator.pushReplacementNamed(context, '/levels'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 13),
        decoration: BoxDecoration(
          color: AppColors.cream,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppColors.orange.withValues(alpha: 0.28)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              level,
              style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.6,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              fee,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.title, this.trailing});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

class _LatestGiftCard extends StatelessWidget {
  const _LatestGiftCard({required this.order});

  final GiftOrder order;

  @override
  Widget build(BuildContext context) {
    final product = Product.byId(order.productId);
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: AppColors.greenDeep,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(Icons.card_giftcard, color: AppColors.gold, size: 31),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  order.status,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.gold),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: AppColors.green),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
