import 'package:atlas_mobile_pi1/core/errors/auth_exception.dart';
import 'package:atlas_mobile_pi1/core/l10n/l10n_ext.dart';
import 'package:atlas_mobile_pi1/core/theme/app_colors.dart';
import 'package:atlas_mobile_pi1/core/theme/app_spacing.dart';
import 'package:atlas_mobile_pi1/features/auth/domain/repositories/user_repository.dart';
import 'package:atlas_mobile_pi1/features/auth/presentation/validators/sign_up_validators.dart';
import 'package:atlas_mobile_pi1/services/auth_service.dart';
import 'package:atlas_mobile_pi1/ui/components/app_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

/// Dialog for users who completed profile before username existed.
Future<bool> showClaimUsernameDialog(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (_) => const _ClaimUsernameDialog(),
  );
  return result == true;
}

class _ClaimUsernameDialog extends StatefulWidget {
  const _ClaimUsernameDialog();

  @override
  State<_ClaimUsernameDialog> createState() => _ClaimUsernameDialogState();
}

class _ClaimUsernameDialogState extends State<_ClaimUsernameDialog> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final auth = context.read<AuthService>();
    final uid = auth.user?.uid;
    if (uid == null) return;

    setState(() {
      _saving = true;
      _error = null;
    });

    final l10n = context.l10n;

    try {
      final username = _controller.text.trim();
      final repo = context.read<UserRepository>();
      final available = await repo.isUsernameAvailable(
        username,
        excludeUid: uid,
      );
      if (!mounted) return;
      if (!available) {
        setState(() => _error = l10n.validationUsernameTaken);
        return;
      }

      await repo.claimUsername(
        uid: uid,
        username: username,
      );
      if (mounted) Navigator.pop(context, true);
    } on AuthException catch (e) {
      setState(() => _error = e.message);
    } catch (_) {
      setState(() => _error = l10n.errorGeneric);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Text(l10n.claimUsernameTitle),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Seu @ é único e será usado em mensagens e na rede social.',
              style: TextStyle(
                color: AppColors.textSecondary(context),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            TextFormField(
              controller: _controller,
              autofocus: true,
              autocorrect: false,
              enableSuggestions: false,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _submit(),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9._@]')),
                TextInputFormatter.withFunction((oldValue, newValue) {
                  final text = newValue.text.toLowerCase();
                  return newValue.copyWith(
                    text: text,
                    selection: TextSelection.collapsed(offset: text.length),
                  );
                }),
              ],
              decoration: InputDecoration(
                hintText: l10n.signUpUsernameHint,
                prefixIcon: const Icon(Icons.alternate_email_rounded),
                errorText: _error,
              ),
              validator: (value) => CreateUserValidators.username(value, l10n),
            ),
          ],
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: AppActionButton(
            label: _saving ? l10n.saving : l10n.claimUsernameSave,
            onTap: _saving ? null : _submit,
          ),
        ),
      ],
    );
  }
}
