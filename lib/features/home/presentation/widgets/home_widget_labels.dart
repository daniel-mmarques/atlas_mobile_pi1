import 'package:atlas_mobile_pi1/features/home/domain/entities/home_widget.dart';
import 'package:flutter/material.dart';

extension HomeWidgetTypeUi on HomeWidgetType {
  String get label => switch (this) {
        HomeWidgetType.streak => 'Streak',
        HomeWidgetType.weeklyVolume => 'Volume',
        HomeWidgetType.frequency => 'Frequência',
        HomeWidgetType.personalRecords => 'PRs',
        HomeWidgetType.avgDuration => 'Duração',
      };

  String get subtitle => switch (this) {
        HomeWidgetType.streak => 'Dias consecutivos treinado',
        HomeWidgetType.weeklyVolume => 'Volume total por semana',
        HomeWidgetType.frequency => 'Treinos na semana e no mês',
        HomeWidgetType.personalRecords => 'Melhores cargas recentes',
        HomeWidgetType.avgDuration => 'Tempo médio por treino',
      };

  String get sheetFooterTitle => switch (this) {
        HomeWidgetType.streak => 'Add a streak to your dashboard',
        HomeWidgetType.weeklyVolume => 'Add weekly volume to your dashboard',
        HomeWidgetType.frequency => 'Add frequency to your dashboard',
        HomeWidgetType.personalRecords => 'Add PRs to your dashboard',
        HomeWidgetType.avgDuration => 'Add duration to your dashboard',
      };

  String get sheetFooterSubtitle => switch (this) {
        HomeWidgetType.streak => 'Track how consistent you stay.',
        HomeWidgetType.weeklyVolume => 'See how much work you put in.',
        HomeWidgetType.frequency => 'Follow how often you train.',
        HomeWidgetType.personalRecords => 'Celebrate your best lifts.',
        HomeWidgetType.avgDuration => 'Know how long sessions last.',
      };

  IconData get icon => switch (this) {
        HomeWidgetType.streak => Icons.local_fire_department_rounded,
        HomeWidgetType.weeklyVolume => Icons.bar_chart_rounded,
        HomeWidgetType.frequency => Icons.calendar_today_rounded,
        HomeWidgetType.personalRecords => Icons.emoji_events_rounded,
        HomeWidgetType.avgDuration => Icons.timer_outlined,
      };

  String get previewValue => switch (this) {
        HomeWidgetType.streak => '0',
        HomeWidgetType.weeklyVolume => '0 kg',
        HomeWidgetType.frequency => '0',
        HomeWidgetType.personalRecords => '0',
        HomeWidgetType.avgDuration => '0 min',
      };

  String get emptyStatus => 'Not logged';
}

extension HomeWidgetStyleUi on HomeWidgetStyle {
  String get label => switch (this) {
        HomeWidgetStyle.number => 'Número',
        HomeWidgetStyle.chart => 'Gráfico',
        HomeWidgetStyle.list => 'Lista',
        HomeWidgetStyle.calendar => 'Calendário',
      };

  IconData get icon => switch (this) {
        HomeWidgetStyle.number => Icons.looks_one_outlined,
        HomeWidgetStyle.chart => Icons.show_chart_rounded,
        HomeWidgetStyle.list => Icons.view_list_rounded,
        HomeWidgetStyle.calendar => Icons.grid_view_rounded,
      };
}
