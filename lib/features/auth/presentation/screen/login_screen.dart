import 'package:family_product_plan/app/ui_kit/app_bar.dart';
import 'package:family_product_plan/app/ui_kit/app_box.dart';
import 'package:family_product_plan/app/ui_kit/app_snack_bar.dart';
import 'package:family_product_plan/features/auth/presentation/auth_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../domain/state/auth_bloc.dart';

/// Экран авторизации
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
          AppSnackBar.showError(context, message: state.message);
        }
      },
      child: Scaffold(
        appBar: CustomAppBar.login(),
        body: Stack(
          children: [
            Center(
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
                            AuthSignInEvent(
                              email: _emailController.text.trim(),
                              password: _passwordController.text,
                            ),
                          );
                        },
                        child: Text('Авторизироваться'),
                      ),
                      HBox(10),
                      TextButton(
                        onPressed: () =>
                            context.pushNamed(AuthRoutes.registerScreenName),
                        child: Text('Нет аккаунта? Зарегестрируйся'),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            BlocBuilder<AuthBloc, AuthState>(
              buildWhen: (previous, current) =>
                  previous.runtimeType != current.runtimeType,
              builder: (_, state) {
                if (state is! AuthLoadingState) {
                  return const SizedBox.shrink();
                }

                return Positioned.fill(
                  child: AbsorbPointer(
                    child: ColoredBox(
                      color: Colors.black.withValues(alpha: 0.15),
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                  ),
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
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
