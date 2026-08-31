import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../../app/utils/app_colors.dart';
import '../../../domain/entity/card_entity.dart';

/// Рендерит код карты — QR или штрихкод, в зависимости от формата,
/// с которым карта была отсканирована (см. [CardAddScreen._scanCard]).
class CardCodeImage extends StatelessWidget {
  const CardCodeImage({required this.card, this.size, super.key});

  final CardEntity card;

  /// Сторона квадрата для QR. Для штрихкодов не используется — они сами
  /// растягиваются на доступную ширину через [FittedBox].
  final double? size;

  @override
  Widget build(BuildContext context) {
    if (_isQrFormat(card.barcodeFormat)) {
      return QrImageView(
        data: card.code,
        backgroundColor: Colors.white,
        size: size,
      );
    }

    return FittedBox(
      child: BarcodeWidget(
        barcode: Barcode.fromType(_mapToBarcodeType(card.barcodeFormat)),
        data: card.code,
        drawText: false,
        color: AppColors.textPrimary,
      ),
    );
  }

  static bool _isQrFormat(String barcodeFormat) =>
      barcodeFormat.toLowerCase().contains('qrcode');

  /// `barcodeFormat` в [CardEntity] сейчас хранится как `.toString()`
  /// значения `BarcodeFormat` из `mobile_scanner` (например
  /// `"BarcodeFormat.code128"`) — поэтому матчим по вхождению подстроки,
  /// не по точному равенству. Стоит завести отдельный enum на уровне
  /// домена и хранить `.name`, но это уже отдельная правка модели.
  static BarcodeType _mapToBarcodeType(String barcodeFormat) {
    final normalized = barcodeFormat.toLowerCase();

    if (normalized.contains('code128')) return BarcodeType.Code128;
    if (normalized.contains('code39')) return BarcodeType.Code39;
    if (normalized.contains('codabar')) return BarcodeType.Codabar;
    if (normalized.contains('ean13')) return BarcodeType.CodeEAN13;
    if (normalized.contains('ean8')) return BarcodeType.CodeEAN8;
    if (normalized.contains('upca')) return BarcodeType.CodeUPCA;
    if (normalized.contains('itf14')) return BarcodeType.CodeITF14;

    return BarcodeType.Code128;
  }
}
