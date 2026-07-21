import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/ui_kit/app_box.dart';
import '../../domain/entity/profile_user_entity.dart';
import '../../domain/state/profile_bloc.dart';

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

  // XFile? _image;

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
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          HBox(20),
          // TODO: нужен FirebaseStorage, за который нужно платить, пока отказываемся от этой темы
          // GestureDetector(
          //   onTap: () => _changeAvatar(context),
          //   child: CircleAvatar(
          //     backgroundImage: _image != null
          //         ? FileImage(File(_image!.path))
          //         : widget.user.avatarUrl != null
          //         ? NetworkImage(widget.user.avatarUrl!)
          //         : const AssetImage('assets/images/person_no_image.png')
          //               as ImageProvider,
          //   ),
          // ),
          // HBox(10),
          TextFormField(
            controller: _lastNameController,
            decoration: InputDecoration(label: Text('Фамилия')),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Введите фамилию';
              }

              return null;
            },
          ),
          HBox(10),
          TextFormField(
            controller: _firstNameController,
            decoration: InputDecoration(label: Text('Имя')),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Введите имя';
              }

              return null;
            },
          ),
          HBox(10),
          TextFormField(
            controller: _middleNameController,
            decoration: InputDecoration(label: Text('Отчество')),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Введите отчество';
              }

              return null;
            },
          ),
          HBox(10),
          DropdownButtonFormField<Gender>(
            initialValue: _gender,
            decoration: const InputDecoration(labelText: 'Пол'),
            items: Gender.values.map((gender) {
              return DropdownMenuItem(value: gender, child: Text(gender.title));
            }).toList(),
            onChanged: (gender) {
              if (gender == null) return;

              setState(() {
                _gender = gender;
              });
            },
          ),
          HBox(10),
          InkWell(
            onTap: _pickBirthDate,
            borderRadius: BorderRadius.circular(12),
            child: InputDecorator(
              decoration: const InputDecoration(labelText: 'Дата рождения'),
              child: Text(
                _birthDate == null
                    ? 'Не выбрана'
                    : DateFormat('dd.MM.yyyy').format(_birthDate!),
              ),
            ),
          ),
          HBox(10),
          FilledButton(onPressed: _save, child: const Text('Сохранить')),
        ],
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
  Future<void> _pickBirthDate() async {
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
  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    context.read<ProfileBloc>().add(
      ProfileUpdateEvent(
        user: widget.user.copyWith(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          middleName: _middleNameController.text.trim(),
          gender: _gender,
          birthDate: _birthDate,
        ),
      ),
    );

    context.pop();
  }

  // TODO: нужен FirebaseStorage, за который нужно платить, пока отказываемся от этой темы
  // Future<void> _changeAvatar(BuildContext context) async {
  //   final permissionHandler = context.di.services.permissionHandler;
  //   final imagePicker = context.di.services.imagePicker;
  //
  //   final granted = await permissionHandler.requestPhotosPermission();
  //
  //   if (!granted) return;
  //
  //   final file = await imagePicker.pickFromGallery();
  //
  //   if (file == null) return;
  //
  //   if (!context.mounted) return;
  //
  //   context.read<ProfileBloc>().add(ProfileAvatarChangedEvent(file: file));
  // }
}
