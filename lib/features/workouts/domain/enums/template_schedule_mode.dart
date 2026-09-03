enum TemplateScheduleMode {
  none,
  weekdays,
  frequency;

  String toJson() => name;

  static TemplateScheduleMode fromJson(String? value) {
    if (value == null || value.isEmpty) return TemplateScheduleMode.none;
    return TemplateScheduleMode.values.firstWhere(
      (e) => e.name == value,
      orElse: () => TemplateScheduleMode.none,
    );
  }
}
