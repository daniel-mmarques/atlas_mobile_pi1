import 'package:atlas_mobile_pi1/core/navigation/app_routes.dart';
import 'package:atlas_mobile_pi1/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:flutter_test/flutter_test.dart';

/// Smoke checks for password-reset wiring (no live Firebase call).
///
/// Manual E2E (email + Firebase hosted page) is documented in README.
void main() {
  test('forgot-password route constant is defined', () {
    expect(AppRoutes.forgotPassword, '/forgot-password');
  });

  test('ForgotPasswordPage accepts initial email from sign-in', () {
    const page = ForgotPasswordPage(initialEmail: 'user@example.com');
    expect(page.initialEmail, 'user@example.com');
  });
}
