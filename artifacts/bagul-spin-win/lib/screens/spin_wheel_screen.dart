import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';

class SpinWheelScreen extends StatefulWidget {
  const SpinWheelScreen({required this.config, super.key});

  final SpinConfig config;

  @override
  State<SpinWheelScreen> createState() => _SpinWheelScreenState();
}

class _SpinWheelScreenState extends State<SpinWheelScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  Animation<double>? _spinAnimation;
  Product? _result;
  bool _spinning = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4700),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _spin() async {
    if (_spinning) return;
    final state = context.read<AppState>();
    final prize = state.choosePrize(guaranteedWin: widget.config.guaranteedWin);
    final prizeIndex = Product.wheelProducts.indexOf(prize);
    const slice = math.pi * 2 / 8;
    final centerAngle = -math.pi / 2 + prizeIndex * slice + slice / 2;
    var target = -math.pi / 2 - centerAngle + math.pi * 2 * 6;
    while (target < 0) {
      target += math.pi * 2;
    }

    setState(() {
      _result = prize;
      _spinning = true;
      _spinAnimation = Tween<double>(begin: 0, end: target).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
      );
    });
    _controller.reset();
    await _controller.forward();
    if (!mounted) return;
    setState(() => _spinning = false);
    await _showResult(prize);
  }

  Future<void> _showResult(Product prize) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => Dialog(
        backgroundColor: AppColors.cream,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 27, 24, 22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 78,
                height: 78,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.gold,
                ),
                child: Icon(
                  prize.isRetry ? Icons.refresh : Icons.card_giftcard,
                  color: AppColors.greenDeep,
                  size: 42,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                prize.isRetry ? 'Better luck next time!' : 'Congratulations!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                prize.isRetry
                    ? 'The wheel has another surprise for you.'
                    : 'You won ${prize.name}!',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.muted),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    if (prize.isRetry) {
                      Navigator.pushReplacementNamed(context, '/levels');
                      return;
                    }
                    final appState = context.read<AppState>();
                    appState.setPendingPrize(prize);
                    if (appState.hasAddress) {
                      appState.claimPendingPrize();
                      Navigator.pushReplacementNamed(context, '/tracking');
                    } else {
                      Navigator.pushNamed(context, '/address');
                    }
                  },
                  child: Text(prize.isRetry ? 'Back to levels' : 'Claim gift'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final diameter = math.min(MediaQuery.sizeOf(context).width - 48, 350.0);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your lucky spin'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _spinning ? null : () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 22),
          child: Column(
            children: [
              Text(
                widget.config.isFreeSpin
                    ? 'Your referral reward is ready'
                    : 'Level entry · ₹${widget.config.entryFee}',
                style: const TextStyle(
                  color: AppColors.green,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 18),
              Expanded(
                child: Center(
                  child: SizedBox(
                    width: diameter,
                    height: diameter + 15,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          top: 0,
                          child: Icon(
                            Icons.arrow_drop_down,
                            color: AppColors.ink,
                            size: 43,
                            shadows: const [
                              Shadow(
                                color: Colors.white,
                                blurRadius: 2,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 15,
                          child: SizedBox(
                            width: diameter,
                            height: diameter,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.gold,
                                  width: 6,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x330C3F33),
                                    blurRadius: 22,
                                    offset: Offset(0, 11),
                                  ),
                                ],
                              ),
                              child: AnimatedBuilder(
                                animation:
                                    _spinAnimation ??
                                    const AlwaysStoppedAnimation(0),
                                builder: (context, child) => Transform.rotate(
                                  angle: _spinAnimation?.value ?? 0,
                                  child: child,
                                ),
                                child: CustomPaint(
                                  painter: _PrizeWheelPainter(
                                    Product.wheelProducts,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (_result != null && !_spinning)
                Text(
                  _result!.isRetry
                      ? 'Spin again next time'
                      : 'You landed on ${_result!.name}',
                  style: const TextStyle(
                    color: AppColors.green,
                    fontWeight: FontWeight.w700,
                  ),
                )
              else
                const Text('Take a breath and give the wheel a spin.'),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton.icon(
                  onPressed: _spinning ? null : _spin,
                  icon: Icon(_spinning ? Icons.hourglass_top : Icons.casino),
                  label: Text(_spinning ? 'SPINNING…' : 'SPIN'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.ink,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
            ],
          ),
        ),
      ),
    );
  }
}

class _PrizeWheelPainter extends CustomPainter {
  _PrizeWheelPainter(this.products);

  final List<Product> products;
  static const _colors = [
    Color(0xFF168C76),
    Color(0xFFE9B947),
    Color(0xFFEF7C35),
    Color(0xFF245AA7),
    Color(0xFFE75D64),
    Color(0xFF197E9C),
    Color(0xFFF1A33B),
    Color(0xFF226650),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide / 2;
    final slice = math.pi * 2 / products.length;
    final rect = Rect.fromCircle(center: center, radius: radius);
    final fill = Paint()..style = PaintingStyle.fill;
    final line = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = AppColors.gold;

    for (var i = 0; i < products.length; i++) {
      final start = -math.pi / 2 + i * slice;
      fill.color = _colors[i % _colors.length];
      canvas.drawArc(rect, start, slice, true, fill);
      canvas.drawArc(rect, start, slice, true, line);

      final label = TextPainter(
        text: TextSpan(
          text: products[i].shortName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 9,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.25,
          ),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
        maxLines: 2,
      )..layout(maxWidth: radius * 0.68);
      final angle = start + slice / 2;
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(angle + math.pi / 2);
      label.paint(canvas, Offset(-label.width / 2, -radius * 0.72));
      canvas.restore();
    }

    canvas.drawCircle(center, radius * 0.17, Paint()..color = AppColors.gold);
    canvas.drawCircle(center, radius * 0.105, Paint()..color = AppColors.cream);
    canvas.drawCircle(center, radius * 0.055, Paint()..color = AppColors.green);
  }

  @override
  bool shouldRepaint(covariant _PrizeWheelPainter oldDelegate) => false;
}
