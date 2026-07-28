/// DTO для создания нового продукта.
final class ProductCreateDto {
  const ProductCreateDto({
    required this.productName,
    required this.productManufacturer,
    required this.isToBuy,
  });

  /// Название продукта.
  final String productName;

  /// Производитель продукта.
  final String productManufacturer;

  /// Признак необходимости покупки продукта.
  final bool isToBuy;

  /// Преобразует объект в JSON.
  Map<String, dynamic> toJson() {
    return {
      'productName': productName,
      'productManufacturer': productManufacturer,
      'isToBuy': isToBuy,
    };
  }
}
