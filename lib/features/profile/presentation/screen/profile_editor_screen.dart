import 'package:family_product_plan/app/app_context_ext.dart';
import 'package:family_product_plan/app/ui_kit/app_bar.dart';
import 'package:family_product_plan/app/ui_kit/app_lost_focus_wrapper.dart';
import 'package:family_product_plan/features/profile/domain/state/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../components/profile_editor_success_view.dart';

/// Экрана профиля пользователя.
class ProfileEditorScreen extends StatelessWidget {
  const ProfileEditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileRepository = context.di.repositories.profileRepository;

    return BlocProvider(
      create: (context) =>
          ProfileBloc(profileRepository: profileRepository)
            ..add(const ProfileGetEvent()),
      child: AppLostFocusWrapper(child: _ProfileEditorScreenView()),
    );
  }
}

/// Виджет, отвечающий за отображение контента в зависимости от состояния.
class _ProfileEditorScreenView extends StatelessWidget {
  const _ProfileEditorScreenView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.profile(actions: []),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is! ProfileSuccessState) {
            return Center(
              child: Container(width: 100, height: 100, color: Colors.red),
            );
          }

          final user = state.user;
          return ProfileEditorSuccessView(user: user);
        },
      ),
    );
  }
}
