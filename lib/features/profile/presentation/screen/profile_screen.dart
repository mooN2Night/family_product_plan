import 'package:family_product_plan/app/app_context_ext.dart';
import 'package:family_product_plan/app/ui_kit/app_bar.dart';
import 'package:family_product_plan/app/ui_kit/app_box.dart';
import 'package:family_product_plan/features/family/presentation/family_routes.dart';
import 'package:family_product_plan/features/profile/domain/state/profile_bloc.dart';
import 'package:family_product_plan/features/profile/presentation/profile_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/domain/state/auth_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileRepository = context.di.repositories.profileRepository;

    return BlocProvider(
      create: (context) =>
          ProfileBloc(profileRepository: profileRepository)
            ..add(ProfileWatchEvent()),
      child: _ProfileScreenView(),
    );
  }
}

class _ProfileScreenView extends StatelessWidget {
  const _ProfileScreenView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.profile(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () =>
                  context.pushNamed(ProfileRoutes.profileEditorScreenName),
              child: Icon(Icons.settings),
            ),
          ),
          // WBox(16),
        ],
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is! ProfileSuccessState) {
            return Center(
              child: Column(
                children: [Container(width: 50, height: 50, color: Colors.red)],
              ),
            );
          }

          final user = state.user;

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            children: [
              HBox(40),
              // TODO: нужен FirebaseStorage, за который нужно платить, пока отказываемся от этой темы
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 40),
              //   child: AspectRatio(
              //     aspectRatio: 1,
              //     child: Container(
              //       decoration: const BoxDecoration(
              //         shape: BoxShape.circle,
              //         color: Colors.greenAccent,
              //       ),
              //       child: Padding(
              //         padding: const EdgeInsets.all(40),
              //         child: Image.asset(
              //           'assets/images/person_no_image.png',
              //           fit: BoxFit.contain,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              // HBox(20),
              ProfileInfo(
                title: 'Фамилия:',
                description: user.lastName.isNotEmpty
                    ? user.lastName
                    : 'Не указано',
              ),
              HBox(5),
              ProfileInfo(
                title: 'Имя:',
                description: user.firstName.isNotEmpty
                    ? user.firstName
                    : 'Не указано',
              ),
              HBox(5),
              if (user.middleName.isNotEmpty) ...[
                ProfileInfo(title: 'Отчество:', description: user.middleName),
                HBox(5),
              ],
              ProfileInfo(title: 'Пол:', description: user.gender.title),
              if (user.formatedBirthDate != null) ...[
                HBox(5),
                ProfileInfo(
                  title: 'Дата рождения:',
                  description: user.formatedBirthDate!,
                ),
              ],
              if (user.age != null) ...[
                HBox(5),
                ProfileInfo(title: 'Возраст:', description: user.age!),
              ],
              HBox(5),
              ProfileInfo(title: 'Почта:', description: user.email),
              HBox(40),
              Text('У вас пока нет семьи'),
              HBox(5),
              FilledButton(
                onPressed: () =>
                    context.pushNamed(FamilyRoutes.familyCreateScreenName),
                child: Text('Создать семью'),
              ),
              HBox(40),
              Align(
                alignment: Alignment.bottomLeft,
                child: TextButton(
                  onPressed: () =>
                      context.read<AuthBloc>().add(const AuthSignOutEvent()),
                  style: ButtonStyle(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: WidgetStatePropertyAll(EdgeInsets.zero),
                    minimumSize: const WidgetStatePropertyAll(Size.zero),
                  ),
                  child: Text('Выйти из аккаунта'),
                ),
              ),
              HBox(20),
              Align(
                alignment: Alignment.bottomLeft,
                child: TextButton(
                  // TODO: Сделать модалку с проверкой пароля и удалить после этого аккаунт
                  onPressed: () => context.read<AuthBloc>().add(
                    const AuthDeleteAccountEvent(password: '123123'),
                  ),
                  style: ButtonStyle(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: WidgetStatePropertyAll(EdgeInsets.zero),
                    minimumSize: const WidgetStatePropertyAll(Size.zero),
                  ),
                  child: Text(
                    'Удалить аккаунта',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class ProfileInfo extends StatelessWidget {
  const ProfileInfo({
    required this.title,
    required this.description,
    super.key,
  });

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: TextStyle(fontSize: 14)),
        WBox(5),
        Text(
          description,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
