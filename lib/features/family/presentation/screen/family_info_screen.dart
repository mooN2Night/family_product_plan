import 'package:family_product_plan/app/app_context_ext.dart';
import 'package:family_product_plan/features/family/domain/state/family_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/ui_kit/app_bar.dart';
import '../components/family_info_success_view.dart';

/// Экран информации о семье.
class FamilyInfoScreen extends StatelessWidget {
  const FamilyInfoScreen({required this.familyId, super.key});

  /// Уникальный идентификатор семьи.
  final String familyId;

  @override
  Widget build(BuildContext context) {
    final familyRepository = context.di.repositories.familyRepository;

    return BlocProvider(
      create: (context) =>
          FamilyBloc(familyRepository: familyRepository)
            ..add(FamilyWatchEvent(familyId: familyId)),
      child: FamilyInfoScreenView(),
    );
  }
}

/// Виджет, отвечающий за отображение содержимого в зависимости от состояния.
class FamilyInfoScreenView extends StatelessWidget {
  const FamilyInfoScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.profile(actions: []),
      body: BlocBuilder<FamilyBloc, FamilyState>(
        builder: (context, state) {
          switch (state) {
            case FamilyLoadingState():
            case FamilyCreatingState():
              return const Center(child: CircularProgressIndicator());

            case FamilyErrorState():
              return Center(child: Text(state.message));

            case FamilyLoadedState():
              return FamilyInfoSuccessView(
                family: state.family,
                members: state.members,
              );

            default:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
