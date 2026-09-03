enum SetIntensityMode {
  none,
  rpe,
  rir;

  String get storageName => name;

  static SetIntensityMode fromStorage(String? value) {
    return switch (value) {
      'rpe' => SetIntensityMode.rpe,
      'rir' => SetIntensityMode.rir,
      _ => SetIntensityMode.none,
    };
  }
}
