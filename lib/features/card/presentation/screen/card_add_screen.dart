import 'package:family_product_plan/app/app_context_ext.dart';
import 'package:family_product_plan/app/presentation/ui_kit/app_box.dart';
import 'package:family_product_plan/app/presentation/ui_kit/app_lost_focus_wrapper.dart';
import 'package:family_product_plan/app/services/permission_hendler/i_permission_handler.dart';
import 'package:family_product_plan/features/card/domain/entity/create_card_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/presentation/ui_kit/app_bar.dart';
import '../../../../app/presentation/ui_kit/app_field_group.dart';
import '../../../../app/presentation/ui_kit/app_snack_bar.dart';
import '../../../../app/presentation/ui_kit/app_text_field.dart';
import '../../../../app/utils/app_colors.dart';
import '../../domain/state/card_action/card_action_bloc.dart';
import '../../utils/card_scanner_result.dart';
import '../card_routes.dart';
import '../components/card_scan_result.dart';

class CardAddScreen extends StatelessWidget {
  const CardAddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppLostFocusWrapper(child: _CardAddView());
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
    return BlocListener<CardActionBloc, CardActionState>(
      listener: (context, state) {
        if (state is CardActionSuccessState) context.pop();
      },
      child: Scaffold(
        appBar: CustomAppBar.secondary(title: 'Добавить карту'),
        body: ListView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          children: [
            AppFieldGroup(
              children: [
                AppTextField(
                  icon: Icons.storefront_outlined,
                  label: 'Название магазина',
                  controller: _nameController,
                  hint: 'Например: Магнит',
                  autofocus: true,
                ),
                const AppFieldDivider(),
                AppTextField(
                  icon: Icons.pin_outlined,
                  label: 'Номер карты',
                  controller: _numberController,
                  hint: '0000 0000 0000 0000',
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
            const HBox(6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'Номер карты - необязательное поле, его можно назвать на кассе, если не сработает QR-код',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ),
            HBox(16),
            ValueListenableBuilder<ScannedCardResult?>(
              valueListenable: _result,
              builder: (context, result, _) {
                return AppScanResultCard(
                  result: result,
                  onScan: () => _scanCard(context),
                );
              },
            ),
            HBox(28),
            ListenableBuilder(
              listenable: Listenable.merge([_nameController, _result]),
              builder: (context, _) {
                final isActive =
                    _nameController.text.isNotEmpty && _result.value != null;

                return SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      disabledBackgroundColor: AppColors.textDisabled,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: const Text(
                      'Сохранить',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
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

  Future<void> _scanCard(BuildContext context) async {
    final permissions = context.di.services.permissionHandler;
    final permissionResult = await permissions.requestCameraPermission();

    if (!context.mounted) return;

    switch (permissionResult) {
      case AppPermissionResult.granted:
        final result = await context.pushNamed<ScannedCardResult>(
          CardRoutes.cardScannerScreenName,
        );

        if (result != null) {
          _result.value = result;

          if (context.mounted) {
            AppSnackBar.showSuccess(context, message: 'Карта отсканирована');
          }
        }
      case AppPermissionResult.denied:
        AppSnackBar.showError(
          context,
          message: 'Нужен доступ к камере, чтобы сканировать карты',
        );
      case AppPermissionResult.permanentlyDenied:
        AppSnackBar.showInfo(
          context,
          message: 'Нужен доступ к камере, чтобы сканировать карты',
          suffixIcon: const Icon(Icons.settings_outlined),
          onIconPressed: () => permissions.openSettings(),
          displayDuration: const Duration(seconds: 5),
        );
    }
  }
}
