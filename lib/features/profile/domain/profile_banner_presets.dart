import 'package:flutter/material.dart';

class ProfileBannerPreset {
  const ProfileBannerPreset({
    required this.id,
    required this.colors,
  });

  final String id;
  final List<Color> colors;

  LinearGradient get gradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: colors.length == 1 ? [colors.first, colors.first] : colors,
      );
}

abstract class ProfileBannerPresets {
  static const defaultId = 'aurora';

  static const all = <ProfileBannerPreset>[
    ProfileBannerPreset(
      id: 'aurora',
      colors: [Color(0xFF0B3D3A), Color(0xFF1FA2A0), Color(0xFF7ED6C5)],
    ),
    ProfileBannerPreset(
      id: 'ocean',
      colors: [Color(0xFF0B1F3A), Color(0xFF1B6CA8), Color(0xFF5BC0EB)],
    ),
    ProfileBannerPreset(
      id: 'sunset',
      colors: [Color(0xFF4A1942), Color(0xFFE36414), Color(0xFFF4A261)],
    ),
    ProfileBannerPreset(
      id: 'forest',
      colors: [Color(0xFF1B4332), Color(0xFF2D6A4F), Color(0xFF95D5B2)],
    ),
    ProfileBannerPreset(
      id: 'violet',
      colors: [Color(0xFF2D1B4E), Color(0xFF6C3BAA), Color(0xFFB388EB)],
    ),
    ProfileBannerPreset(
      id: 'ember',
      colors: [Color(0xFF2B0A0A), Color(0xFF9B2226), Color(0xFFE85D04)],
    ),
    ProfileBannerPreset(
      id: 'slate',
      colors: [Color(0xFF1C1C1E), Color(0xFF3A3A3C), Color(0xFF8E8E93)],
    ),
    ProfileBannerPreset(
      id: 'sand',
      colors: [Color(0xFF3D2C1E), Color(0xFFC9A66B), Color(0xFFE8D5B7)],
    ),
  ];

  static ProfileBannerPreset byId(String? id) {
    return all.firstWhere(
      (p) => p.id == id,
      orElse: () => all.first,
    );
  }
}
