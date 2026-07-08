import 'package:family_product_plan/app/ui_kit/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/domain/state/auth_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.profile(actions: []),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () =>
                context.read<AuthBloc>().add(const AuthSignOutEvent()),
            child: Text('Выход'),
          ),
        ],
      ),
    );
  }
}
