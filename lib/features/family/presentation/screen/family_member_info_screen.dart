import 'package:family_product_plan/app/app_context_ext.dart';
import 'package:family_product_plan/app/ui_kit/app_bar.dart';
import 'package:family_product_plan/features/family/domain/entity/family_relation.dart';
import 'package:family_product_plan/features/family/domain/entity/family_role.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/state/family_member_bloc/family_member_info_bloc.dart';
import '../../domain/state/family_remove_member_bloc/family_remove_member_bloc.dart';
import '../components/family_member_info_success_view.dart';

class FamilyMemberInfoScreen extends StatelessWidget {
  const FamilyMemberInfoScreen({
    required this.userId,
    required this.familyId,
    required this.role,
    required this.relation,
    required this.canEditRelation,
    required this.isCurrentUser,
    super.key,
  });

  final String userId;
  final String familyId;
  final String role;
  final String relation;
  final bool canEditRelation;
  final bool isCurrentUser;

  @override
  Widget build(BuildContext context) {
    final familyRepository = context.di.repositories.familyRepository;
    final profileRepository = context.di.repositories.profileRepository;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => FamilyMemberInfoBloc(
            familyRepository: familyRepository,
            profileRepository: profileRepository,
          )..add(FamilyMemberInfoLoadEvent(userId: userId)),
        ),
        BlocProvider(
          create: (context) =>
              FamilyRemoveMemberBloc(familyRepository: familyRepository),
        ),
      ],
      child: FamilyMemberInfoScreenView(
        familyId: familyId,
        role: FamilyRole.fromString(role),
        relation: FamilyRelation.fromString(relation),
        canEditRelation: canEditRelation,
        isCurrentUser: isCurrentUser,
      ),
    );
  }
}

class FamilyMemberInfoScreenView extends StatelessWidget {
  const FamilyMemberInfoScreenView({
    required this.familyId,
    required this.role,
    required this.relation,
    required this.canEditRelation,
    required this.isCurrentUser,
    super.key,
  });

  final String familyId;
  final FamilyRole role;
  final FamilyRelation relation;
  final bool canEditRelation;
  final bool isCurrentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.profile(actions: []),
      body: BlocBuilder<FamilyMemberInfoBloc, FamilyMemberInfoState>(
        builder: (context, state) {
          if (state is! FamilyMemberInfoLoadedState) {
            return Center(
              child: Container(width: 100, height: 100, color: Colors.red),
            );
          }

          final user = state.profile;
          return FamilyMemberInfoSuccessView(
            familyId: familyId,
            user: user,
            role: role,
            relation: relation,
            canEditRelation: canEditRelation,
            isCurrentUser: isCurrentUser,
          );
        },
      ),
    );
  }
}
