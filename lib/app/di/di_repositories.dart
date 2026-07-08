import 'package:family_product_plan/features/auth/data/repository/auth_repository.dart';
import 'package:family_product_plan/features/auth/domain/repository/i_auth_repository.dart';
import 'package:family_product_plan/features/home/data/repository/home_repository.dart';
import 'package:family_product_plan/features/home/domain/repository/i_home_repository.dart';
import 'di_container.dart';

/// Контейнер репозиториев приложения.
final class DiRepositories {
  /// Репозиторий для работы с главным экраном.
  late final IHomeRepository homeRepository;

  /// Репозиторий для работы с экраном авторизации.
  late final IAuthRepository authRepository;

  /// Инициализирует репозитории приложения.
  void init({required DiContainer diContainer}) {
    homeRepository = HomeRepository(
      localDataSource: diContainer.dataSource.productsLocalDataSource,
    );

    authRepository = AuthRepository(
      remoteDataSource: diContainer.dataSource.authRemoteDataSource,
    );
  }
}
