import 'package:family_product_plan/app/app_context_ext.dart';
import 'package:family_product_plan/app/presentation/ui_kit/app_box.dart';
import 'package:family_product_plan/app/presentation/ui_kit/app_lost_focus_wrapper.dart';
import 'package:family_product_plan/app/services/permission_hendler/i_permission_handler.dart';
import 'package:family_product_plan/features/card/domain/entity/create_card_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/presentation/ui_kit/app_bar.dart';
import '../../../../app/presentation/ui_kit/app_snack_bar.dart';
import '../../../../app/utils/app_colors.dart';
import '../../domain/state/card_action/card_action_bloc.dart';
import '../../utils/card_scanner_result.dart';
import '../card_routes.dart';

class CardAddScreen extends StatelessWidget {
  const CardAddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLostFocusWrapper(child: const _CardAddView());
  }
}

class _CardAddView extends StatefulWidget {
  const _CardAddView();

  @override
  State<_CardAddView> createState() => _CardAddViewState();
}

class _CardAddViewState extends State<_CardAddView> {
  late final TextEditingController _nameController;
  late final TextEditingController _numberController;
  late final ValueNotifier<ScannedCardResult?> _result;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _numberController = TextEditingController();
    _result = ValueNotifier<ScannedCardResult?>(null);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final permissions = context.di.services.permissionHandler;

    return BlocListener<CardActionBloc, CardActionState>(
      listener: (context, state) {
        if (state is CardActionSuccessState) context.pop();
      },
      child: Scaffold(
        appBar: CustomAppBar.secondary(title: 'Добавить карту'),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          children: [
            Text('* Название магазина', style: textTheme.titleMedium),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                hint: Text(
                  'Например "Магнит"',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
            ),
            HBox(20),
            Text('Номер карты', style: textTheme.titleMedium),
            TextFormField(
              controller: _numberController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hint: Text(
                  '0000 0000 0000 0000',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
            ),
            Text(
              'неодязательное поле, его можно назвать на кассе если не работает qr код',
              style: textTheme.labelSmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            HBox(20),
            ValueListenableBuilder(
              valueListenable: _result,
              builder: (context, res, _) {
                return ElevatedButton(
                  onPressed: () async {
                    final permissionResult = await permissions
                        .requestCameraPermission();

                    if (!context.mounted) return;

                    switch (permissionResult) {
                      case AppPermissionResult.granted:
                        _result.value = await context
                            .pushNamed<ScannedCardResult>(
                              CardRoutes.cardScannerScreenName,
                            );
                      case AppPermissionResult.denied:
                        AppSnackBar.showError(
                          context,
                          message:
                              'Нужен доступ к камере, чтобы сканировать карты',
                        );
                      case AppPermissionResult.permanentlyDenied:
                        AppSnackBar.showInfo(
                          context,
                          message:
                              'Нужен доступ к камере, чтобы сканировать карты',
                          suffixIcon: Icon(Icons.settings_outlined),
                          onIconPressed: () => permissions.openSettings(),
                          displayDuration: const Duration(seconds: 5),
                        );
                    }
                  },
                  child: res == null
                      ? Text(
                          'Отсканировать карту',
                          style: textTheme.bodyLarge?.copyWith(
                            color: AppColors.primary,
                          ),
                        )
                      : Text(
                          'Карта успешно отсканирована!',
                          style: textTheme.bodyLarge?.copyWith(
                            color: Colors.green,
                          ),
                        ),
                );
              },
            ),
            HBox(20),
            ListenableBuilder(
              listenable: Listenable.merge([_nameController, _result]),
              builder: (context, _) {
                final isActive =
                    _nameController.text.isNotEmpty && _result.value != null;

                return ElevatedButton(
                  onPressed: isActive
                      ? () {
                          final card = CreateCardEntity(
                            name: _nameController.text,
                            number: _numberController.text,
                            barcodeFormat: _result.value!.format.toString(),
                            code: _result.value!.rawValue,
                          );

                          context.read<CardActionBloc>().add(
                            CardActionAddEvent(card: card),
                          );
                        }
                      : null,
                  child: Text(
                    'Сохранить',
                    style: TextStyle(
                      color: isActive ? AppColors.primary : Colors.grey,
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
    _nameController.dispose();
    _numberController.dispose();
    _result.dispose();
    super.dispose();
  }
}
