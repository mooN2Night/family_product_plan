import 'package:family_product_plan/features/auth/data/repository/auth_repository.dart';
import 'package:family_product_plan/features/auth/domain/repository/i_auth_repository.dart';
import 'package:family_product_plan/features/card/data/repository/card_repository.dart';
import 'package:family_product_plan/features/current_family/data/repository/current_family_repository.dart';
import 'package:family_product_plan/features/current_family/domain/repository/i_current_family_repository.dart';
import 'package:family_product_plan/features/family/data/repository/family_repository.dart';
import 'package:family_product_plan/features/family/domain/repository/i_family_repository.dart';
import 'package:family_product_plan/features/home/data/repository/home_repository.dart';
import 'package:family_product_plan/features/home/domain/repository/i_home_repository.dart';
import 'package:family_product_plan/features/profile/data/repository/profile_repository.dart';
import 'package:family_product_plan/features/profile/domain/repository/i_profile_repository.dart';
import 'package:family_product_plan/features/tasks/data/repository/tasks_repository.dart';
import 'package:family_product_plan/features/tasks/domain/repository/i_tasks_repository.dart';
import '../../features/card/domain/repository/i_card_repository.dart';
import 'di_container.dart';

/// Контейнер репозиториев приложения.
final class DiRepositories {
  /// Репозиторий для работы с главным экраном.
  late final IHomeRepository homeRepository;

  /// Репозиторий для работы с экраном авторизации.
  late final IAuthRepository authRepository;

  /// Репозиторий для работы с экраном профиля.
  late final IProfileRepository profileRepository;

  /// Репозиторий для работы с экраном семьи.
  late final IFamilyRepository familyRepository;

  /// Репозиторий для получения id семьи.
  late final ICurrentFamilyRepository currentFamilyRepository;

  /// Репозиторий для работы с экраном задач.
  late final ITasksRepository tasksRepository;

  /// Репозиторий для работы с экраном задач.
  late final ICardRepository cardRepository;

  /// Инициализирует репозитории приложения.
  void init({required DiContainer diContainer}) {
    homeRepository = HomeRepository(
      localDataSource: diContainer.dataSource.productsLocalDataSource,
      remoteDataSource: diContainer.dataSource.productsRemoteDataSource,
      currentFamilyProvider: diContainer.services.currentFamilyProvider,
      pendingSyncService: diContainer.business.pendingSyncService,
      networkService: diContainer.services.networkService,
    );

    authRepository = AuthRepository(
      remoteDataSource: diContainer.dataSource.authRemoteDataSource,
    );

    profileRepository = ProfileRepository(
      firebaseAuth: diContainer.services.firebaseAuth,
      firestore: diContainer.services.firestore,
      // storage: diContainer.services.storage,
    );

    familyRepository = FamilyRepository(
      firestore: diContainer.services.firestore,
      firebaseAuth: diContainer.services.firebaseAuth,
      currentFamilyProvider: diContainer.services.currentFamilyProvider,
    );

    currentFamilyRepository = CurrentFamilyRepository(
      provider: diContainer.services.currentFamilyProvider,
      firestore: diContainer.services.firestore,
      firebaseAuth: diContainer.services.firebaseAuth,
    );

    tasksRepository = TasksRepository(
      localDataSource: diContainer.dataSource.tasksLocalDataSource,
      currentFamilyProvider: diContainer.services.currentFamilyProvider,
      remoteDataSource: diContainer.dataSource.tasksRemoteDataSource,
      pendingSyncService: diContainer.business.pendingSyncService,
      networkService: diContainer.services.networkService,
    );

    cardRepository = CardRepository(
      pendingSyncService: diContainer.business.pendingSyncService,
      networkService: diContainer.services.networkService,
      localDataSource: diContainer.dataSource.cardLocalDataSource,
    );
  }
}
