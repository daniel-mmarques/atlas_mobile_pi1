import 'package:atlas_mobile_pi1/core/theme/app_colors.dart';
import 'package:atlas_mobile_pi1/features/home/domain/entities/home_widget.dart';
import 'package:atlas_mobile_pi1/features/home/presentation/widgets/tiles/duration_tile.dart';
import 'package:atlas_mobile_pi1/features/home/presentation/widgets/tiles/frequency_tile.dart';
import 'package:atlas_mobile_pi1/features/home/presentation/widgets/tiles/prs_tile.dart';
import 'package:atlas_mobile_pi1/features/home/presentation/widgets/tiles/streak_tile.dart';
import 'package:atlas_mobile_pi1/features/home/presentation/widgets/tiles/volume_tile.dart';
import 'package:flutter/material.dart';

class HomeWidgetTile extends StatelessWidget {
  const HomeWidgetTile({
    super.key,
    required this.instance,
    this.userId,
  });

  final HomeWidgetInstance instance;
  final String? userId;

  @override
  Widget build(BuildContext context) {
    if (userId == null) {
      return HomeTileNumber(
        value: '0',
        title: instance.name,
        subtitle: 'Not logged',
      );
    }

    return switch (instance.type) {
      HomeWidgetType.streak => StreakTile(
          userId: userId!,
          style: instance.style,
          name: instance.name,
        ),
      HomeWidgetType.weeklyVolume => VolumeTile(
          userId: userId!,
          style: instance.style,
          name: instance.name,
        ),
      HomeWidgetType.frequency => FrequencyTile(
          userId: userId!,
          style: instance.style,
          name: instance.name,
        ),
      HomeWidgetType.personalRecords => PrsTile(
          userId: userId!,
          style: instance.style,
          name: instance.name,
        ),
      HomeWidgetType.avgDuration => DurationTile(
          userId: userId!,
          style: instance.style,
          name: instance.name,
        ),
    };
  }
}

/// Design from mock: big value, title name, muted status line.
class HomeTileNumber extends StatelessWidget {
  const HomeTileNumber({
    super.key,
    required this.value,
    required this.title,
    this.subtitle,
    this.unit,
  });

  final String value;
  final String title;
  final String? subtitle;
  final String? unit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 28, top: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  value,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.8,
                        height: 1,
                      ),
                ),
                if (unit != null) ...[
                  const SizedBox(width: 4),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Text(
                      unit!,
                      style: TextStyle(
                        color: AppColors.textSecondary(context),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(
              subtitle!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppColors.textSecondary(context),
                fontSize: 13,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
