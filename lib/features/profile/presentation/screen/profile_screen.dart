import 'package:family_product_plan/app/app_context_ext.dart';
import 'package:family_product_plan/app/ui_kit/app_bar.dart';
import 'package:family_product_plan/app/ui_kit/app_box.dart';
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

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                HBox(40),
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.greenAccent,
                  ),
                ),
                HBox(10),
                ProfileInfo(title: 'Имя:', description: user.firstName),
                HBox(5),
                ProfileInfo(title: 'Фамилия:', description: user.lastName),
                HBox(5),
                ProfileInfo(title: 'Отчество:', description: user.middleName),
                HBox(5),
                ProfileInfo(title: 'Пол:', description: user.gender.title),
                HBox(5),
                ProfileInfo(
                  title: 'Дата рождения:',
                  description: user.birthDate.toString(),
                ),
                HBox(5),
                ProfileInfo(title: 'Почта:', description: user.email),
                HBox(30),
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
                HBox(10),
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
            ),
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
