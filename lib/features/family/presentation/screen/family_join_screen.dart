import 'package:family_product_plan/app/app_context_ext.dart';
import 'package:family_product_plan/app/ui_kit/app_bar.dart';
import 'package:family_product_plan/app/ui_kit/app_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/ui_kit/app_box.dart';
import '../../domain/state/family_join/family_join_bloc.dart';

class FamilyJoinScreen extends StatelessWidget {
  const FamilyJoinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final familyRepository = context.di.repositories.familyRepository;

    return BlocProvider(
      create: (context) => FamilyJoinBloc(familyRepository: familyRepository),
      child: FamilyJoinScreenView(),
    );
  }
}

class FamilyJoinScreenView extends StatefulWidget {
  const FamilyJoinScreenView({super.key});

  @override
  State<FamilyJoinScreenView> createState() => _FamilyJoinScreenViewState();
}

class _FamilyJoinScreenViewState extends State<FamilyJoinScreenView> {
  /// Контроллер для ввода кода семьи.
  late final TextEditingController _codeController;

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.profile(actions: []),
      body: BlocListener<FamilyJoinBloc, FamilyJoinState>(
        listener: (context, state) {
          switch (state) {
            case FamilyJoinSuccessState():
              AppSnackBar.showSuccess(
                context,
                message: 'Вы успешно присоединились к семье!',
              );

              context.pop();
            case FamilyJoinErrorState():
              AppSnackBar.showError(context, message: state.message);
            default:
              break;
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              HBox(40),
              TextField(
                controller: _codeController,
                decoration: const InputDecoration(
                  labelText: 'Код для вступления',
                ),
              ),
              HBox(40),
              FilledButton(
                onPressed: () {
                  final name = _codeController.text.trim();

                  if (name.isEmpty) return;

                  context.read<FamilyJoinBloc>().add(
                    FamilyJoinRequestedEvent(
                      joinCode: _codeController.text.trim(),
                    ),
                  );
                },
                child: const Text('Присоединиться'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }
}
