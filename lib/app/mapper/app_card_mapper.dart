import '../../features/card/domain/entity/card_entity.dart';
import '../services/database/app_database.dart';

/// Преобразование модели Drift в доменную сущность.
extension CardMapper on Card {
  CardEntity toEntity() {
    return CardEntity(
      id: id,
      name: name,
      number: number,
      barcodeFormat: barcodeFormat,
      code: code,
    );
  }
}

/// Преобразование сущности в модель Drift.
extension CardEntityMapper on CardEntity {
  Card toDatabaseModel() {
    return Card(
      id: id,
      name: name,
      number: number,
      barcodeFormat: barcodeFormat,
      code: code,
    );
  }

  CardsCompanion toCompanion() {
    return CardsCompanion.insert(
      id: id,
      name: name,
      number: number,
      barcodeFormat: barcodeFormat,
      code: code,
    );
  }
}
