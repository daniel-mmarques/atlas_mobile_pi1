import 'package:atlas_mobile_pi1/core/theme/app_theme.dart';
import 'package:atlas_mobile_pi1/core/theme/app_theme_id.dart';
import 'package:atlas_mobile_pi1/ui/components/app_action_button.dart';
import 'package:atlas_mobile_pi1/ui/components/platinum_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Material _materialOf(WidgetTester tester, Key key) {
  return tester.widget<Material>(
    find.descendant(
      of: find.byKey(key),
      matching: find.byType(Material),
    ),
  );
}

void main() {
  group('Legibilidade — botões enabled vs disabled', () {
    for (final themeId in AppThemeId.values) {
      testWidgets('AppActionButton muda visual no tema ${themeId.name}',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppThemes.of(themeId),
            home: Scaffold(
              body: SizedBox(
                width: 400,
                child: Column(
                  children: [
                    AppActionButton(
                      key: const Key('action-enabled'),
                      label: 'Continuar',
                      icon: Icons.arrow_forward_rounded,
                      onTap: () {},
                      emphasized: true,
                    ),
                    const SizedBox(height: 12),
                    AppActionButton(
                      key: const Key('action-disabled'),
                      label: 'Continuar',
                      icon: Icons.arrow_forward_rounded,
                      onTap: null,
                      emphasized: true,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        expect(tester.takeException(), isNull);

        final enabled = _materialOf(tester, const Key('action-enabled'));
        final disabled = _materialOf(tester, const Key('action-disabled'));

        expect(enabled.color, isNotNull);
        expect(disabled.color, isNotNull);
        expect(enabled.color, isNot(equals(disabled.color)));
      });

      testWidgets('AppIconButton muda visual no tema ${themeId.name}',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppThemes.of(themeId),
            home: Scaffold(
              body: Row(
                children: [
                  AppIconButton(
                    key: const Key('icon-enabled'),
                    icon: Icons.tune_rounded,
                    onPressed: () {},
                  ),
                  const SizedBox(width: 12),
                  AppIconButton(
                    key: const Key('icon-disabled'),
                    icon: Icons.tune_rounded,
                    onPressed: null,
                  ),
                ],
              ),
            ),
          ),
        );

        expect(tester.takeException(), isNull);

        final enabled = _materialOf(tester, const Key('icon-enabled'));
        final disabled = _materialOf(tester, const Key('icon-disabled'));

        expect(enabled.color, isNotNull);
        expect(disabled.color, isNotNull);
        expect(enabled.color, isNot(equals(disabled.color)));
      });
    }
  });
}
