import 'package:atlas_mobile_pi1/core/l10n/l10n_ext.dart';
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
        subtitle: context.l10n.widgetNotLogged,
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

/// Título + subtítulo padrão dos widgets da Home.
class HomeWidgetChrome extends StatelessWidget {
  const HomeWidgetChrome({
    super.key,
    required this.title,
    this.subtitle,
  });

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.textPrimary(context);
    final secondary = AppColors.textSecondary(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: primary,
            fontWeight: FontWeight.w700,
            fontSize: 15,
            letterSpacing: -0.2,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 2),
          Text(
            subtitle!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: secondary,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ],
    );
  }
}

/// Design: valor grande, título, linha de status.
class HomeTileNumber extends StatelessWidget {
  const HomeTileNumber({
    super.key,
    required this.value,
    required this.title,
    this.subtitle,
    this.unit,
    this.footer,
  });

  final String value;
  final String title;
  final String? subtitle;
  final String? unit;

  /// Linha extra abaixo do subtítulo (ex.: melhor streak).
  final String? footer;

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.textPrimary(context);
    final secondary = AppColors.textSecondary(context);

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
                        color: primary,
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
                        color: secondary,
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
            style: TextStyle(
              color: primary,
              fontWeight: FontWeight.w700,
              fontSize: 16,
              letterSpacing: -0.2,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(
              subtitle!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: secondary,
                fontSize: 13,
              ),
            ),
          ],
          if (footer != null) ...[
            const SizedBox(height: 2),
            Text(
              footer!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: secondary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
