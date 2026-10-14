import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class BrandMark extends StatelessWidget {
  const BrandMark({this.compact = false, super.key});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: compact ? 38 : 46,
          height: compact ? 38 : 46,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [AppColors.gold, AppColors.orangeDeep],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Icon(
            Icons.casino,
            color: AppColors.greenDeep,
            size: compact ? 22 : 27,
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'BAGUL',
              style: TextStyle(
                color: AppColors.greenDeep,
                fontSize: compact ? 21 : 27,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
                height: 1,
              ),
            ),
            Text(
              'SPIN & WIN REAL GIFTS',
              style: TextStyle(
                color: AppColors.greenDeep.withValues(alpha: 0.8),
                fontSize: compact ? 8 : 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.7,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
