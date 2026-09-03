import 'package:atlas_mobile_pi1/features/home/domain/entities/home_widget.dart';
import 'package:atlas_mobile_pi1/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

extension HomeWidgetTypeUi on HomeWidgetType {
  String label(AppLocalizations l10n) => switch (this) {
        HomeWidgetType.streak => l10n.widgetStreak,
        HomeWidgetType.weeklyVolume => l10n.widgetVolume,
        HomeWidgetType.frequency => l10n.widgetFrequency,
        HomeWidgetType.personalRecords => l10n.widgetPrs,
        HomeWidgetType.avgDuration => l10n.widgetDuration,
      };

  String subtitle(AppLocalizations l10n) => switch (this) {
        HomeWidgetType.streak => l10n.widgetStreakSubtitle,
        HomeWidgetType.weeklyVolume => l10n.widgetVolumeSubtitle,
        HomeWidgetType.frequency => l10n.widgetFrequencySubtitle,
        HomeWidgetType.personalRecords => l10n.widgetPrsSubtitle,
        HomeWidgetType.avgDuration => l10n.widgetDurationSubtitle,
      };

  String sheetFooterTitle(AppLocalizations l10n) => switch (this) {
        HomeWidgetType.streak => l10n.widgetAddStreak,
        HomeWidgetType.weeklyVolume => l10n.widgetAddVolume,
        HomeWidgetType.frequency => l10n.widgetAddFrequency,
        HomeWidgetType.personalRecords => l10n.widgetAddPrs,
        HomeWidgetType.avgDuration => l10n.widgetAddDuration,
      };

  String sheetFooterSubtitle(AppLocalizations l10n) => switch (this) {
        HomeWidgetType.streak => l10n.widgetTrackStreak,
        HomeWidgetType.weeklyVolume => l10n.widgetTrackVolume,
        HomeWidgetType.frequency => l10n.widgetTrackFrequency,
        HomeWidgetType.personalRecords => l10n.widgetTrackPrs,
        HomeWidgetType.avgDuration => l10n.widgetTrackDuration,
      };

  IconData get icon => switch (this) {
        HomeWidgetType.streak => Icons.local_fire_department_rounded,
        HomeWidgetType.weeklyVolume => Icons.bar_chart_rounded,
        HomeWidgetType.frequency => Icons.calendar_today_rounded,
        HomeWidgetType.personalRecords => Icons.emoji_events_rounded,
        HomeWidgetType.avgDuration => Icons.timer_outlined,
      };

  String previewValue(AppLocalizations l10n) => switch (this) {
        HomeWidgetType.streak => '0',
        HomeWidgetType.weeklyVolume => '0 ${l10n.commonKg}',
        HomeWidgetType.frequency => '0',
        HomeWidgetType.personalRecords => '0',
        HomeWidgetType.avgDuration => '0 ${l10n.commonMin}',
      };

  String emptyStatus(AppLocalizations l10n) => l10n.widgetNotLogged;
}

extension HomeWidgetStyleUi on HomeWidgetStyle {
  String label(AppLocalizations l10n) => switch (this) {
        HomeWidgetStyle.number => l10n.widgetStyleNumber,
        HomeWidgetStyle.chart => l10n.widgetStyleChart,
        HomeWidgetStyle.list => l10n.widgetStyleList,
        HomeWidgetStyle.calendar => l10n.widgetStyleCalendar,
      };

  IconData get icon => switch (this) {
        HomeWidgetStyle.number => Icons.looks_one_outlined,
        HomeWidgetStyle.chart => Icons.show_chart_rounded,
        HomeWidgetStyle.list => Icons.view_list_rounded,
        HomeWidgetStyle.calendar => Icons.grid_view_rounded,
      };
}
