import 'package:family_product_plan/app/app_context_ext.dart';
import 'package:family_product_plan/app/ui_kit/app_bar.dart';
import 'package:family_product_plan/app/ui_kit/app_box.dart';
import 'package:family_product_plan/app/ui_kit/app_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../domain/state/family_create/family_create_bloc.dart';

/// Экран создания семьи.
class FamilyCreateScreen extends StatelessWidget {
  const FamilyCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final familyRepository = context.di.repositories.familyRepository;

    return BlocProvider(
      create: (context) => FamilyCreateBloc(familyRepository: familyRepository),
      child: FamilyCreateScreenView(),
    );
  }
}

/// Содержимое экрана создания семьи.
class FamilyCreateScreenView extends StatefulWidget {
  const FamilyCreateScreenView({super.key});

  @override
  State<FamilyCreateScreenView> createState() => _FamilyCreateScreenViewState();
}

class _FamilyCreateScreenViewState extends State<FamilyCreateScreenView> {
  /// Контроллер названия семьи.
  late final TextEditingController _familyNameController;

  @override
  void initState() {
    super.initState();
    _familyNameController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FamilyCreateBloc, FamilyCreateState>(
      listener: (context, state) {
        switch (state) {
          case FamilyCreateSuccessState():
            AppSnackBar.showSuccess(
              context: context,
              message: 'Семья успешно создана',
            );

            context.pop();
          case FamilyCreateErrorState():
            AppSnackBar.showError(context, message: state.message);
          default:
            break;
        }
      },
      child: Scaffold(
        appBar: CustomAppBar.profile(actions: []),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              HBox(40),
              TextField(
                controller: _familyNameController,
                decoration: const InputDecoration(labelText: 'Название семьи'),
              ),
              HBox(40),
              BlocBuilder<FamilyCreateBloc, FamilyCreateState>(
                builder: (context, state) {
                  final isLoading = state is FamilyCreateLoadingState;

                  return FilledButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            final name = _familyNameController.text.trim();

                            if (name.isEmpty) return;

                            context.read<FamilyCreateBloc>().add(
                              FamilyCreateRequestedEvent(name: name),
                            );
                          },
                    child: isLoading
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Создать'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _familyNameController.dispose();
    super.dispose();
  }
}
