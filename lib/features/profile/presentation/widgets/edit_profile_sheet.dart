import 'dart:io';

import 'package:atlas_mobile_pi1/core/errors/auth_exception.dart';
import 'package:atlas_mobile_pi1/core/l10n/l10n_ext.dart';
import 'package:atlas_mobile_pi1/core/theme/app_colors.dart';
import 'package:atlas_mobile_pi1/core/theme/app_spacing.dart';
import 'package:atlas_mobile_pi1/core/utils/date_formatters.dart';
import 'package:atlas_mobile_pi1/features/auth/domain/entities/app_user.dart';
import 'package:atlas_mobile_pi1/features/auth/domain/enums/activity_level.dart';
import 'package:atlas_mobile_pi1/features/auth/domain/enums/gender.dart';
import 'package:atlas_mobile_pi1/features/auth/domain/repositories/user_repository.dart';
import 'package:atlas_mobile_pi1/features/auth/domain/username.dart';
import 'package:atlas_mobile_pi1/features/auth/presentation/validators/sign_up_validators.dart';
import 'package:atlas_mobile_pi1/features/profile/data/profile_banner_uploader.dart';
import 'package:atlas_mobile_pi1/ui/components/atlas_sheet.dart';
import 'package:atlas_mobile_pi1/ui/components/atlas_sheet_chrome.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

Future<void> showEditProfileSheet({
  required BuildContext context,
  required AppUser user,
  required Future<void> Function() onEditBanner,
}) {
  return showAtlasSheet<void>(
    context: context,
    builder: (_) => EditProfileSheet(
      user: user,
      onEditBanner: onEditBanner,
    ),
  );
}

class EditProfileSheet extends StatefulWidget {
  const EditProfileSheet({
    super.key,
    required this.user,
    required this.onEditBanner,
  });

  final AppUser user;
  final Future<void> Function() onEditBanner;

  @override
  State<EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<EditProfileSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _usernameController;
  late final TextEditingController _birthController;
  late final TextEditingController _heightController;
  late final TextEditingController _weightController;

  Gender? _gender;
  ActivityLevel? _activityLevel;
  String? _photoUrl;
  XFile? _pendingPhoto;
  bool _saving = false;

  final _uploader = ProfileMediaUploader();

  @override
  void initState() {
    super.initState();
    final user = widget.user;
    _nameController = TextEditingController(text: user.name ?? '');
    _usernameController = TextEditingController(
      text: Username.normalize(user.username),
    );
    _birthController = TextEditingController(
      text: user.birthDate == null
          ? ''
          : DateFormatters.formatDate(user.birthDate!),
    );
    _heightController = TextEditingController(
      text: user.height?.toString() ?? '',
    );
    _weightController = TextEditingController(
      text: user.weight?.toString() ?? '',
    );
    _gender = user.gender;
    _activityLevel = user.activityLevel;
    _photoUrl = user.photoUrl;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _birthController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    final file = await _uploader.pickImage(maxWidth: 1024, maxHeight: 1024);
    if (file == null || !mounted) return;
    setState(() => _pendingPhoto = file);
  }

  Future<void> _save() async {
    final l10n = context.l10n;
    if (!_formKey.currentState!.validate()) return;
    if (_gender == null || _activityLevel == null) {
      _formKey.currentState!.validate();
      return;
    }

    final birth = DateFormatters.parseDate(_birthController.text.trim());
    if (birth == null) return;

    final height = double.parse(
      _heightController.text.trim().replaceAll(',', '.'),
    );
    final weight = double.parse(
      _weightController.text.trim().replaceAll(',', '.'),
    );

    setState(() => _saving = true);
    final messenger = ScaffoldMessenger.of(context);
    final users = context.read<UserRepository>();

    try {
      var photoUrl = _photoUrl;
      if (_pendingPhoto != null) {
        photoUrl = await _uploader.uploadAvatar(
          uid: widget.user.id,
          file: _pendingPhoto!,
        );
      }

      await users.updateProfile(
        uid: widget.user.id,
        name: _nameController.text.trim(),
        username: _usernameController.text.trim(),
        birthDate: birth,
        gender: _gender!,
        height: height,
        weight: weight,
        activityLevel: _activityLevel!,
        photoUrl: photoUrl,
      );

      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.profileEditSaved)),
      );
      Navigator.of(context).maybePop();
    } on AuthException catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    } catch (_) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.profileEditError)),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final initial = _nameController.text.trim().isNotEmpty
        ? _nameController.text.trim()[0].toUpperCase()
        : '?';

    ImageProvider? avatarImage;
    if (_pendingPhoto != null) {
      avatarImage = FileImage(File(_pendingPhoto!.path));
    } else if (_photoUrl != null && _photoUrl!.isNotEmpty) {
      avatarImage = NetworkImage(_photoUrl!);
    }

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: AppSpacing.sheetInitial,
      minChildSize: AppSpacing.sheetMinContent,
      maxChildSize: AppSpacing.sheetMax,
      builder: (context, scrollController) {
        return Column(
          children: [
            const AtlasSheetHandle(),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.sheetPaddingH,
                AppSpacing.md,
                AppSpacing.sheetPaddingH,
                AppSpacing.sm,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.profileEditTitle,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                  AtlasSheetNavIcon(
                    onPressed: () => Navigator.of(context).maybePop(),
                    isDismiss: true,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.sheetPaddingH,
                    AppSpacing.sm,
                    AppSpacing.sheetPaddingH,
                    AppSpacing.sheetPaddingB,
                  ),
                  children: [
                    Center(
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: _saving ? null : _pickAvatar,
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  radius: 48,
                                  backgroundColor:
                                      AppColors.accentOf(context),
                                  backgroundImage: avatarImage,
                                  child: avatarImage == null
                                      ? Text(
                                          initial,
                                          style: TextStyle(
                                            fontSize: 32,
                                            color: AppColors.onAccentOf(
                                              context,
                                            ),
                                            fontWeight: FontWeight.w700,
                                          ),
                                        )
                                      : null,
                                ),
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: AppColors.component(context),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.camera_alt_rounded,
                                      size: 16,
                                      color: AppColors.textPrimary(context),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          TextButton(
                            onPressed: _saving ? null : _pickAvatar,
                            child: Text(l10n.profileEditPhoto),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    OutlinedButton.icon(
                      onPressed: _saving
                          ? null
                          : () async {
                              Navigator.of(context).maybePop();
                              await widget.onEditBanner();
                            },
                      icon: const Icon(Icons.wallpaper_rounded),
                      label: Text(l10n.profileCustomizeBanner),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    TextFormField(
                      controller: _nameController,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        labelText: l10n.signUpNameHint,
                        prefixIcon: const Icon(Icons.badge_outlined),
                      ),
                      validator: (v) => CreateUserValidators.names(v, l10n),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: _usernameController,
                      autocorrect: false,
                      enableSuggestions: false,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'[A-Za-z0-9._@]'),
                        ),
                        TextInputFormatter.withFunction((oldValue, newValue) {
                          final text = newValue.text.toLowerCase();
                          return newValue.copyWith(
                            text: text,
                            selection: TextSelection.collapsed(
                              offset: text.length,
                            ),
                          );
                        }),
                      ],
                      decoration: InputDecoration(
                        labelText: l10n.signUpUsernameHint,
                        prefixIcon: const Icon(Icons.alternate_email_rounded),
                      ),
                      validator: (v) =>
                          CreateUserValidators.username(v, l10n),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: _birthController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: l10n.signUpBirthHint,
                        prefixIcon: const Icon(Icons.calendar_month),
                      ),
                      validator: (v) => CreateUserValidators.age(v, l10n),
                      onTap: () async {
                        final now = DateTime.now();
                        final picked = await showDatePicker(
                          context: context,
                          firstDate: DateTime(1900),
                          lastDate: now,
                          initialDate: widget.user.birthDate ??
                              DateTime(now.year - 18),
                        );
                        if (picked != null) {
                          _birthController.text =
                              DateFormatters.formatDate(picked);
                        }
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    DropdownButtonFormField<Gender>(
                      // ignore: deprecated_member_use
                      value: _gender,
                      decoration: InputDecoration(
                        labelText: l10n.signUpGenderHint,
                        prefixIcon: const Icon(Icons.wc_rounded),
                      ),
                      items: Gender.values
                          .map(
                            (g) => DropdownMenuItem(
                              value: g,
                              child: Text(g.label(l10n)),
                            ),
                          )
                          .toList(),
                      onChanged: (v) => setState(() => _gender = v),
                      validator: (v) => CreateUserValidators.gender(v, l10n),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _heightController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            decoration: InputDecoration(
                              labelText: l10n.signUpHeightHint,
                              prefixIcon: const Icon(Icons.height),
                            ),
                            validator: (v) =>
                                CreateUserValidators.height(v, l10n),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: TextFormField(
                            controller: _weightController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            decoration: InputDecoration(
                              labelText: l10n.signUpWeightHint,
                              prefixIcon: const Icon(Icons.monitor_weight),
                            ),
                            validator: (v) =>
                                CreateUserValidators.weight(v, l10n),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    DropdownButtonFormField<ActivityLevel>(
                      // ignore: deprecated_member_use
                      value: _activityLevel,
                      decoration: InputDecoration(
                        labelText: l10n.signUpActivityHint,
                        prefixIcon: const Icon(Icons.directions_run),
                      ),
                      items: ActivityLevel.values
                          .map(
                            (a) => DropdownMenuItem(
                              value: a,
                              child: Text(a.label(l10n)),
                            ),
                          )
                          .toList(),
                      onChanged: (v) => setState(() => _activityLevel = v),
                      validator: (v) =>
                          CreateUserValidators.activityLevel(v, l10n),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    FilledButton(
                      onPressed: _saving ? null : _save,
                      child: _saving
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(l10n.profileEditSave),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
