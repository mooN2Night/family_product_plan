import 'package:family_product_plan/features/card/domain/entity/card_entity.dart';

class CardDto {
  const CardDto({
    required this.id,
    required this.name,
    required this.number,
    required this.barcodeFormat,
    required this.code,
  });

  factory CardDto.fromJson(Map<String, dynamic> json) => CardDto(
    id: json['id'] as String,
    name: json['name'] as String,
    number: json['number'] as String,
    barcodeFormat: json['barcodeFormat'] as String,
    code: json['code'] as String,
  );

  final String id;
  final String name;
  final String number;
  final String barcodeFormat;
  final String code;

  CardEntity toEntity() => CardEntity(
    id: id,
    name: name,
    number: number,
    barcodeFormat: barcodeFormat,
    code: code,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'number': number,
    'barcodeFormat': barcodeFormat,
    'code': code,
  };
}
