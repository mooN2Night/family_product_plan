import 'package:family_product_plan/app/app_context_ext.dart';
import 'package:family_product_plan/app/ui_kit/app_bar.dart';
import 'package:family_product_plan/features/profile/domain/state/profile_bloc.dart';
import 'package:family_product_plan/features/profile/presentation/profile_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../components/profile_success_view.dart';

/// Экран профиля пользователя.
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

/// Виджет, отвечающий за отображение контента в зависимости от состояния.
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

          return ProfileSuccessView(user: user);
        },
      ),
    );
  }
}
