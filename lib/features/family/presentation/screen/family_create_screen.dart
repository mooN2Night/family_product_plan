import 'package:family_product_plan/app/app_context_ext.dart';
import 'package:family_product_plan/app/ui_kit/app_bar.dart';
import 'package:family_product_plan/app/ui_kit/app_box.dart';
import 'package:family_product_plan/app/ui_kit/app_snack_bar.dart';
import 'package:family_product_plan/features/family/domain/state/family_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Экран создания семьи.
class FamilyCreateScreen extends StatelessWidget {
  const FamilyCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final familyRepository = context.di.repositories.familyRepository;

    return BlocProvider(
      create: (context) => FamilyBloc(familyRepository: familyRepository),
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
    return BlocListener<FamilyBloc, FamilyState>(
      listener: (context, state) {
        switch (state) {
          case FamilyCreatedState():
            AppSnackBar.showSuccess(
              context: context,
              message: 'Семья успешно создана',
            );

            context.pop();
          case FamilyErrorState():
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
              BlocBuilder<FamilyBloc, FamilyState>(
                builder: (context, state) {
                  final isLoading = state is FamilyCreatingState;

                  return FilledButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            final name = _familyNameController.text.trim();

                            if (name.isEmpty) return;

                            context.read<FamilyBloc>().add(
                              FamilyCreateEvent(name: name),
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
