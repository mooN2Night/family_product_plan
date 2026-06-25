part of 'products_bloc.dart';

/// Класс состояния для покупок.
class ProductsState extends Equatable {
  const ProductsState({this.isLoading = false, this.products = const []});

  /// Список покупок.
  final List<ProductEntity> products;

  /// Флаг загрузки.
  final bool isLoading;

  /// Метод для частичного обновления полей.
  ProductsState copyWith({List<ProductEntity>? products, bool? isLoading}) {
    return ProductsState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [products, isLoading];
}
