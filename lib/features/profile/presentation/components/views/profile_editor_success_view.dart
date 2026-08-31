import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../../app/presentation/ui_kit/app_actions_tile.dart';
import '../../../../../app/presentation/ui_kit/app_box.dart';
import '../../../../../app/presentation/ui_kit/app_dropdown_field.dart';
import '../../../../../app/presentation/ui_kit/app_field_group.dart';
import '../../../../../app/presentation/ui_kit/app_snack_bar.dart';
import '../../../../../app/presentation/ui_kit/app_text_field.dart';
import '../../../../../app/utils/app_colors.dart';
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
  late final ValueNotifier<Gender> _genderNotifier;

  /// Дата рождения
  late final ValueNotifier<DateTime?> _birthDateNotifier;

  /// Ключ для формы
  late final GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _lastNameController = TextEditingController(text: widget.user.lastName);
    _firstNameController = TextEditingController(text: widget.user.firstName);
    _middleNameController = TextEditingController(text: widget.user.middleName);

    _genderNotifier = ValueNotifier<Gender>(widget.user.gender);
    _birthDateNotifier = ValueNotifier<DateTime?>(widget.user.birthDate);

    _formKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileUpdateBloc, ProfileUpdateState>(
      listener: (context, state) {
        if (state is ProfileUpdateSuccessState) context.pop();

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
            AppFieldGroup(
              children: [
                AppTextField(
                  controller: _lastNameController,
                  label: 'Фамилия',
                  icon: Icons.badge_outlined,
                  autofocus: _lastNameController.text.isEmpty ? true : false,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Введите фамилию';
                    }

                    return null;
                  },
                ),
                const AppFieldDivider(),
                AppTextField(
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
                const AppFieldDivider(),
                AppTextField(
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
            const HBox(16),
            AppFieldGroup(
              children: [
                ValueListenableBuilder<Gender>(
                  valueListenable: _genderNotifier,
                  builder: (context, gender, _) {
                    return AppDropdownField<Gender>(
                      icon: Icons.flag_outlined,
                      label: 'Приоритет',
                      value: gender,
                      items: Gender.values,
                      itemLabelBuilder: (item) => item.title,
                      onChanged: (value) {
                        if (value == null) return;

                        _genderNotifier.value = value;
                      },
                    );
                  },
                ),
                const AppFieldDivider(),
                ValueListenableBuilder(
                  valueListenable: _birthDateNotifier,
                  builder: (context, date, _) {
                    return AppActionTile(
                      icon: Icons.calendar_month_outlined,
                      label: 'Срок выполнения',
                      // во второй ветке — 'Дата задачи'
                      value: date == null
                          ? 'Не выбрана'
                          : DateFormat('dd.MM.yyyy').format(date),
                      trailingIcon: Icons.calendar_month,
                      onTap: () => _pickBirthDate(context),
                    );
                  },
                ),
              ],
            ),
            HBox(28),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: BlocBuilder<ProfileUpdateBloc, ProfileUpdateState>(
                builder: (context, state) {
                  final isLoading = state is ProfileUpdateLoadingState;

                  return ElevatedButton(
                    onPressed: isLoading ? null : () => _save(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
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
    _lastNameController.dispose();
    _firstNameController.dispose();
    _middleNameController.dispose();

    _genderNotifier.dispose();
    _birthDateNotifier.dispose();
    super.dispose();
  }

  /// Метод для отображения пикера даты рождения
  Future<void> _pickBirthDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: _birthDateNotifier.value ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (date == null) return;

    setState(() {
      _birthDateNotifier.value = date;
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
          gender: _genderNotifier.value,
          birthDate: _birthDateNotifier.value,
        ),
      ),
    );
  }
}
