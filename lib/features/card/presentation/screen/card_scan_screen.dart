import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// Результат сканирования карты — то, что реально закодировано
/// в штрихкоде/QR, плюс формат, в котором это было закодировано.
///
/// Важно: rawValue — это именно "сырая" строка со сканера
/// (например "E7005000698309358T483276"), а не отформатированный
/// номер, который может показывать приложение магазина.
class ScannedCardResult {
  const ScannedCardResult({required this.rawValue, required this.format});

  final String rawValue;
  final BarcodeFormat format;

  @override
  String toString() =>
      'ScannedCardResult(rawValue: $rawValue, format: $format)';
}

class CardScannerScreen extends StatefulWidget {
  const CardScannerScreen({super.key});

  @override
  State<CardScannerScreen> createState() => _CardScannerScreenState();
}

class _CardScannerScreenState extends State<CardScannerScreen> {
  final MobileScannerController _controller = MobileScannerController(
    // Разрешаем сканеру ловить все распространённые форматы карт лояльности,
    // а не только QR — иначе штрихкоды типа Code128/Codabar/EAN13 не поймает.
    formats: const [
      BarcodeFormat.qrCode,
      BarcodeFormat.code128,
      BarcodeFormat.code39,
      BarcodeFormat.codabar,
      BarcodeFormat.ean13,
      BarcodeFormat.ean8,
      BarcodeFormat.itf,
    ],
  );

  // Флаг нужен, чтобы не среагировать на один и тот же код несколько раз
  // подряд, пока экран не успел закрыться после первого срабатывания.
  bool _handled = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_handled) return;

    final barcode = capture.barcodes.firstOrNull;
    final rawValue = barcode?.rawValue;

    if (barcode == null || rawValue == null || rawValue.isEmpty) return;

    _handled = true;

    context.pop(ScannedCardResult(rawValue: rawValue, format: barcode.format));
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
            onDetect: _onDetect,
            // errorBuilder: (context, error, child) {
            //   return _CameraErrorView(error: error);
            // },
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
