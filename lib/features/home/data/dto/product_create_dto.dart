/// DTO для создания нового продукта.
final class ProductCreateDto {
  const ProductCreateDto({
    required this.productName,
    required this.productManufacturer,
    required this.isToBuy,
    this.quantity,
    this.description,
  });

  /// Название продукта.
  final String productName;

  /// Производитель продукта.
  final String productManufacturer;

  /// Количество продукта.
  ///
  /// Например: `2 л`, `3 шт`, `500 г`.
  final String? quantity;

  /// Дополнительное описание продукта.
  final String? description;

  /// Признак необходимости покупки продукта.
  final bool isToBuy;

  /// Преобразует объект в JSON.
  Map<String, dynamic> toJson() {
    return {
      'productName': productName,
      'productManufacturer': productManufacturer,
      'quantity': quantity,
      'description': description,
      'isToBuy': isToBuy,
    };
  }
}
