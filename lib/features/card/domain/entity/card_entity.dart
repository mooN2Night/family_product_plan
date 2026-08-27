import 'package:equatable/equatable.dart';
import 'package:family_product_plan/features/card/data/dto/card_dto.dart';

class CardEntity extends Equatable {
  const CardEntity({
    required this.id,
    required this.name,
    required this.number,
  });

  final String id;
  final String name;
  final String number;

  CardDto toEntity() => CardDto(id: id, name: name, number: number);

  @override
  List<Object?> get props => [id, name, number];
}
