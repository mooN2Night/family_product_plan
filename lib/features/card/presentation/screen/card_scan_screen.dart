import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../app/presentation/ui_kit/app_snack_bar.dart';
import '../../utils/card_scanner_result.dart';

class CardScannerScreen extends StatefulWidget {
  const CardScannerScreen({super.key});

  @override
  State<CardScannerScreen> createState() => _CardScannerScreenState();
}

class _CardScannerScreenState extends State<CardScannerScreen> {
  final MobileScannerController _controller = MobileScannerController();

  /// Форматы, для которых у нас есть виджет для генерации кода обратно
  static const _supportedFormats = {
    BarcodeFormat.qrCode,
    BarcodeFormat.code128,
    BarcodeFormat.code39,
    BarcodeFormat.codabar,
    BarcodeFormat.ean13,
    BarcodeFormat.ean8,
    BarcodeFormat.upcA,
    BarcodeFormat.itf14,
  };

  /// Флаг нужен, чтобы не среагировать на один и тот же код несколько раз подряд,
  /// пока экран не успел закрыться после первого срабатывания.
  bool _handled = false;

  /// Чтобы не спамить снекбарами каждый кадр, пока пользователь всё ещё держит
  /// камеру наведённой на неподдерживаемый код.
  DateTime? _lastUnsupportedWarningAt;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BuildContext context, BarcodeCapture capture) {
    if (_handled) return;

    final barcode = capture.barcodes.firstOrNull;
    final rawValue = barcode?.rawValue;

    if (barcode == null || rawValue == null || rawValue.isEmpty) return;

    if (!_supportedFormats.contains(barcode.format)) {
      _showUnsupportedFormatWarning(context, barcode.format);
      return;
    }

    _handled = true;

    context.pop(ScannedCardResult(rawValue: rawValue, format: barcode.format));
  }

  void _showUnsupportedFormatWarning(
    BuildContext context,
    BarcodeFormat format,
  ) {
    final now = DateTime.now();

    if (_lastUnsupportedWarningAt != null &&
        now.difference(_lastUnsupportedWarningAt!) <
            const Duration(seconds: 2)) {
      return;
    }

    _lastUnsupportedWarningAt = now;

    AppSnackBar.showInfo(
      context,
      message: 'Данный формат пока не поддерживается',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Сканирование карты'),
        actions: [
          IconButton(
            onPressed: () => _controller.toggleTorch(),
            icon: ValueListenableBuilder(
              valueListenable: _controller,
              builder: (context, state, child) {
                final torchOn = state.torchState == TorchState.on;
                return Icon(torchOn ? Icons.flash_on : Icons.flash_off);
              },
            ),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: (capture) => _onDetect(context, capture),
            errorBuilder: (context, error) => _CameraErrorView(error: error),
          ),
          // Полупрозрачная рамка-подсказка, куда наводить карту.
          IgnorePointer(
            child: Center(
              child: Container(
                width: 280,
                height: 180,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 32,
            child: Text(
              'Наведите камеру на штрихкод или QR-код карты',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CameraErrorView extends StatelessWidget {
  const _CameraErrorView({required this.error});

  final MobileScannerException error;

  @override
  Widget build(BuildContext context) {
    final message = switch (error.errorCode) {
      MobileScannerErrorCode.permissionDenied =>
        'Нет доступа к камере. Разрешите доступ в настройках приложения.',
      _ =>
        'Не удалось открыть камеру: ${error.errorDetails?.message ?? error.errorCode}',
    };

    return ColoredBox(
      color: Colors.black,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            message,
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
