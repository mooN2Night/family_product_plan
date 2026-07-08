import 'package:family_product_plan/app/mapper/app_product_mapper.dart';
import '../../domain/entity/product_entity.dart';
import '../../domain/repository/i_home_repository.dart';
import '../data_source/local/i_products_local_data_source.dart';

/// Реализация репозитория для работы с главной страницей.
final class HomeRepository implements IHomeRepository {
  HomeRepository({required IProductsLocalDataSource localDataSource})
    : _localDataSource = localDataSource;

  /// Реализация локального хранения продуктов
  final IProductsLocalDataSource _localDataSource;

  @override
  Stream<List<ProductEntity>> watchProducts() {
    return _localDataSource.watchProducts().map(
      (list) => list.map((item) => item.toEntity()).toList(),
    );
  }

  @override
  Future<void> addProduct(ProductEntity product) =>
      _localDataSource.addProduct(product);

  @override
  Future<void> deleteProduct(int id) => _localDataSource.deleteProduct(id);

  @override
  Future<ProductEntity> getProduct(int id) async {
    final product = await _localDataSource.getProduct(id);

    return product.toEntity();
  }

  @override
  Future<void> toggleProductStatus(ProductEntity product) =>
      _localDataSource.updateProduct(product);
}
