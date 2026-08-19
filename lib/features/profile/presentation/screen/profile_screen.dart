import 'package:family_product_plan/app/app_context_ext.dart';
import 'package:family_product_plan/features/profile/domain/state/profile/profile_bloc.dart';
import 'package:family_product_plan/features/profile/presentation/profile_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/presentation/ui_kit/app_bar.dart';
import '../components/views/profile_success_view.dart';

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
      appBar: CustomAppBar.secondary(
        title: 'Профиль',
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () =>
                  context.pushNamed(ProfileRoutes.profileEditorScreenName),
              child: Icon(Icons.settings_outlined),
            ),
          ),
          // WBox(16),
        ],
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          return switch (state) {
            ProfileLoadingState() => const Center(
              child: CircularProgressIndicator(),
            ),
            ProfileErrorState() => Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(state.message, textAlign: TextAlign.center),
              ),
            ),
            ProfileSuccessState() => ProfileSuccessView(user: state.user),
            _ => const SizedBox.shrink(),
          };
        },
      ),
    );
  }
}
