final class ProductCreateDto {
  const ProductCreateDto({
    required this.productName,
    required this.productManufacturer,
    required this.isToBuy,
  });

  final String productName;
  final String productManufacturer;
  final bool isToBuy;

  Map<String, dynamic> toJson() {
    return {
      'productName': productName,
      'productManufacturer': productManufacturer,
      'isToBuy': isToBuy,
    };
  }
}
