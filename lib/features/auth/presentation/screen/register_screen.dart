import 'package:family_product_plan/features/auth/domain/state/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/ui_kit/app_bar.dart';
import '../../../../app/ui_kit/app_box.dart';

/// Экран регистрации
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  /// Контроллер для поля почты
  late final TextEditingController _emailController;

  /// Контроллер для поля пароля
  late final TextEditingController _passwordController;

  /// Ключ для формы
  late final GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _formKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthErrorState) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        appBar: CustomAppBar.register(),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Введите email';
                      }

                      return null;
                    },
                  ),
                  HBox(15),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Пароль'),
                    validator: (value) {
                      if (value == null || value.length < 6) {
                        return 'Минимум 6 символов';
                      }

                      return null;
                    },
                  ),
                  HBox(40),
                  TextButton(
                    onPressed: () {
                      if (!_formKey.currentState!.validate()) return;

                      context.read<AuthBloc>().add(
                        AuthSignUpEvent(
                          email: _emailController.text.trim(),
                          password: _passwordController.text,
                        ),
                      );
                    },
                    child: Text('Зарегестрироваться'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
