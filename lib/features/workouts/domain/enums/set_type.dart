enum SetType {
  warmUp,
  work,
  failure,
  drop,
  backoff;

  String toJson() => switch (this) {
        SetType.warmUp => 'warm_up',
        SetType.work => 'work',
        SetType.failure => 'failure',
        SetType.drop => 'drop',
        SetType.backoff => 'backoff',
      };

  static SetType fromJson(String? value) {
    switch (value) {
      case 'warm_up':
      case 'warmUp':
        return SetType.warmUp;
      case 'failure':
        return SetType.failure;
      case 'drop':
        return SetType.drop;
      case 'backoff':
        return SetType.backoff;
      case 'work':
      default:
        return SetType.work;
    }
  }
}
