import 'package:family_product_plan/app/app_context_ext.dart';
import 'package:family_product_plan/app/ui_kit/app_bar.dart';
import 'package:family_product_plan/app/ui_kit/app_box.dart';
import 'package:family_product_plan/features/family/domain/state/family_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

class FamilyCreateScreenView extends StatefulWidget {
  const FamilyCreateScreenView({super.key});

  @override
  State<FamilyCreateScreenView> createState() => _FamilyCreateScreenViewState();
}

class _FamilyCreateScreenViewState extends State<FamilyCreateScreenView> {
  late final TextEditingController _familyNameController;

  @override
  void initState() {
    super.initState();
    _familyNameController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                return FilledButton(
                  onPressed: state.isLoading
                      ? null
                      : () {
                          final name = _familyNameController.text.trim();

                          if (name.isEmpty) return;

                          context.read<FamilyBloc>().add(
                            FamilyCreateEvent(name: name),
                          );
                        },
                  child: state.isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Создать'),
                );
              },
            ),
          ],
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
