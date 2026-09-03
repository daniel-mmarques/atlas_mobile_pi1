enum ConversationType {
  dm,
  coach,
  community,
  general,
}

extension ConversationTypeStorage on ConversationType {
  String get storageName => name;

  static ConversationType fromStorage(String? value) => switch (value) {
        'coach' => ConversationType.coach,
        'community' => ConversationType.community,
        'general' => ConversationType.general,
        _ => ConversationType.dm,
      };
}
