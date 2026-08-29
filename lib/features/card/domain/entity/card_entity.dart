import 'package:equatable/equatable.dart';
import 'package:family_product_plan/features/card/data/dto/card_dto.dart';

class CardEntity extends Equatable {
  const CardEntity({
    required this.id,
    required this.name,
    required this.number,
    required this.barcodeFormat,
    required this.code,
  });

  final String id;
  final String name;
  final String number;
  final String barcodeFormat;
  final String code;

  CardDto toDto() => CardDto(
    id: id,
    name: name,
    number: number,
    barcodeFormat: barcodeFormat,
    code: code,
  );

  @override
  List<Object?> get props => [id, name, number, barcodeFormat, code];
}
