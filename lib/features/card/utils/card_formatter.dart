import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

/// Форматирует ввод номера карты в маску `0000 0000 0000 0000`: оставляет
/// только цифры, разбивает их по 4 через пробел, ограничивает 16 цифрами.
class CardNumberInputFormatter extends TextInputFormatter {
  const CardNumberInputFormatter();

  static const _groupSize = 4;
  static const _maxDigits = 16;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text
        .replaceAll(RegExp(r'\D'), '')
        .characters
        .take(_maxDigits)
        .join();

    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && i % _groupSize == 0) buffer.write(' ');
      buffer.write(digits[i]);
    }

    final formatted = buffer.toString();

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
