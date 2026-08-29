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
