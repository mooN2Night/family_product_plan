import 'package:family_product_plan/features/card/domain/entity/card_entity.dart';

class CardDto {
  const CardDto({required this.id, required this.name, required this.number});

  final String id;
  final String name;
  final String number;

  CardEntity toEntity() => CardEntity(id: id, name: name, number: number);
}
