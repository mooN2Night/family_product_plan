import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../../app/presentation/ui_kit/app_box.dart';
import '../../../../../app/presentation/ui_kit/app_snack_bar.dart';
import '../../../domain/entity/profile_user_entity.dart';
import '../../../domain/state/profile_update/profile_update_bloc.dart';

/// Виджет отображения успешно загруженных данных пользователя.
class ProfileEditorSuccessView extends StatefulWidget {
  const ProfileEditorSuccessView({required this.user, super.key});

  /// Пользователь.
  final ProfileUserEntity user;

  @override
  State<ProfileEditorSuccessView> createState() =>
      _ProfileEditorSuccessViewState();
}

class _ProfileEditorSuccessViewState extends State<ProfileEditorSuccessView> {
  /// Контроллер имени
  late final TextEditingController _lastNameController;

  /// Контроллер фамилии
  late final TextEditingController _firstNameController;

  /// Контроллер отчества
  late final TextEditingController _middleNameController;

  /// Пол
  late Gender _gender;

  /// Дата рождения
  DateTime? _birthDate;

  /// Ключ для формы
  late final GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _lastNameController = TextEditingController(text: widget.user.lastName);
    _firstNameController = TextEditingController(text: widget.user.firstName);
    _middleNameController = TextEditingController(text: widget.user.middleName);

    _gender = widget.user.gender;
    _birthDate = widget.user.birthDate;

    _formKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocListener<ProfileUpdateBloc, ProfileUpdateState>(
      listener: (context, state) {
        if (state is ProfileUpdateSuccessState) {
          context.pop();
        }

        if (state is ProfileUpdateErrorState) {
          AppSnackBar.showError(context, message: state.message);
        }
      },
      child: Form(
        key: _formKey,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 140),
          children: [
            const _ProfileSectionTitle(
              icon: Icons.person_outline,
              title: 'Личные данные',
            ),
            HBox(12),
            _ProfileFieldGroup(
              children: [
                _ProfileTextField(
                  controller: _lastNameController,
                  label: 'Фамилия',
                  icon: Icons.badge_outlined,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Введите фамилию';
                    }

                    return null;
                  },
                ),
                _ProfileFieldDivider(),
                _ProfileTextField(
                  controller: _firstNameController,
                  label: 'Имя',
                  icon: Icons.person_outline,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Введите имя';
                    }

                    return null;
                  },
                ),
                _ProfileFieldDivider(),
                _ProfileTextField(
                  controller: _middleNameController,
                  label: 'Отчество',
                  icon: Icons.person_outline,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Введите отчество';
                    }

                    return null;
                  },
                ),
              ],
            ),
            HBox(28),
            const _ProfileSectionTitle(
              icon: Icons.info_outline,
              title: 'Основная информация',
            ),
            HBox(12),
            _ProfileFieldGroup(
              children: [
                _ProfileDropdownField(
                  gender: _gender,
                  onChanged: (gender) {
                    setState(() {
                      _gender = gender;
                    });
                  },
                ),
                const _ProfileFieldDivider(),
                _ProfileDateField(
                  birthDate: _birthDate,
                  onTap: () => _pickBirthDate(context),
                ),
              ],
            ),
            HBox(32),
            SizedBox(
              height: 56,
              child: BlocBuilder<ProfileUpdateBloc, ProfileUpdateState>(
                builder: (context, state) {
                  final isLoading = state is ProfileUpdateLoadingState;

                  return FilledButton(
                    onPressed: isLoading ? null : () => _save(context),
                    style: FilledButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: isLoading
                        ? CircularProgressIndicator()
                        : Text(
                            'Сохранить изменения',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _lastNameController.dispose();
    _firstNameController.dispose();
    _middleNameController.dispose();
  }

  /// Метод для отображения пикера даты рождения
  Future<void> _pickBirthDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (date == null) return;

    setState(() {
      _birthDate = date;
    });
  }

  /// Метод для сохранения настроек пользователя.
  Future<void> _save(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    context.read<ProfileUpdateBloc>().add(
      ProfileUpdateRequestedEvent(
        user: widget.user.copyWith(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          middleName: _middleNameController.text.trim(),
          gender: _gender,
          birthDate: _birthDate,
        ),
      ),
    );
  }
}

class _ProfileSectionTitle extends StatelessWidget {
  const _ProfileSectionTitle({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Icon(icon, size: 20, color: colorScheme.primary),
        const WBox(8),
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _ProfileFieldGroup extends StatelessWidget {
  const _ProfileFieldGroup({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.35),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );
  }
}

class _ProfileFieldDivider extends StatelessWidget {
  const _ProfileFieldDivider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      indent: 16,
      endIndent: 16,
      color: Theme.of(
        context,
      ).colorScheme.outlineVariant.withValues(alpha: 0.4),
    );
  }
}

class _ProfileTextField extends StatelessWidget {
  const _ProfileTextField({
    required this.controller,
    required this.label,
    required this.icon,
    required this.validator,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? Function(String?) validator;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: TextFormField(
        controller: controller,
        validator: validator,
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, size: 21, color: colorScheme.onSurfaceVariant),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}

class _ProfileDropdownField extends StatelessWidget {
  const _ProfileDropdownField({required this.gender, required this.onChanged});

  final Gender gender;
  final ValueChanged<Gender> onChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: DropdownButtonFormField<Gender>(
        initialValue: gender,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.wc_outlined,
            size: 21,
            color: colorScheme.onSurfaceVariant,
          ),
          labelText: 'Пол',
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
        items: Gender.values.map((gender) {
          return DropdownMenuItem(value: gender, child: Text(gender.title));
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            onChanged(value);
          }
        },
      ),
    );
  }
}

class _ProfileDateField extends StatelessWidget {
  const _ProfileDateField({required this.birthDate, required this.onTap});

  final DateTime? birthDate;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 21,
              color: colorScheme.onSurfaceVariant,
            ),
            const WBox(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Дата рождения',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const HBox(3),
                  Text(
                    birthDate == null
                        ? 'Не выбрана'
                        : DateFormat('dd.MM.yyyy').format(birthDate!),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}
