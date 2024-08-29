import 'package:get_it/get_it.dart';
import 'package:order/core/database/firebase_db.dart';
import 'package:order/features/login/data/datasources/remote_login_user.dart';
import 'package:order/features/login/data/reporisatory/account_reporisatory_impl.dart';
import 'package:order/features/login/domain/repositories/account_repository.dart';
import 'package:order/features/login/domain/usecases/remote_login_usecase.dart';
import 'package:order/features/login/domain/usecases/remote_logout_usecase.dart';
import 'package:order/features/login/presentation/cubit/login_cubit.dart';
import 'package:order/features/notification/presentation/cubit/notification_cubit.dart';
import 'package:order/features/orders/data/datasource/remote_order_datasource.dart';
import 'package:order/features/orders/data/reporisatory/remote_order_repository_impl.dart';
import 'package:order/features/orders/domain/remote_usecases/remote_add_order_usecase.dart';
import 'package:order/features/orders/domain/remote_usecases/remote_delete_order_useCase.dart';
import 'package:order/features/orders/domain/remote_usecases/remote_get_all_orders_usecase.dart';
import 'package:order/features/orders/domain/remote_usecases/remote_get_user_orders_usecase.dart';
import 'package:order/features/orders/domain/remote_usecases/remote_update_order_usecase.dart';
import 'package:order/features/orders/domain/reporisatory/order_repository.dart';
import 'package:order/features/orders/presentation/cubit/order_cubit.dart';
import 'package:order/features/register/data/datasource/remote_register_user_datasource.dart';
import 'package:order/features/register/data/reporisatory/register_repo_impl.dart';
import 'package:order/features/register/domain/reposisatory/register_reprisatory.dart';
import 'package:order/features/register/domain/usecase/get_user_info_usecase.dart';
import 'package:order/features/register/domain/usecase/remote_register_usecase.dart';
import 'package:order/features/register/presentation/cubit/profile_cubit.dart';
import 'package:order/features/register/presentation/cubit/register_cubit.dart';
import 'package:order/features/restaurant/data/datasource/restaurant_datasource.dart';
import 'package:order/features/restaurant/data/reporisatory/firebase_storage_repo.dart';
import 'package:order/features/restaurant/data/reporisatory/restaurant_reporisatory_impl.dart';
import 'package:order/features/restaurant/domain/reporisatory/restaurant_reporisatory.dart';
import 'package:order/features/restaurant/domain/usecase/add_restaurant_usecase.dart';
import 'package:order/features/restaurant/domain/usecase/delete_image_usecase.dart';
import 'package:order/features/restaurant/domain/usecase/get_all_restaurant_usecase.dart';
import 'package:order/features/restaurant/domain/usecase/get_uploaded_iamge_usecase.dart';
import 'package:order/features/restaurant/domain/usecase/upload_image_usecase.dart';
import 'package:order/features/restaurant/presentation/cubit/restaurant_cubit.dart';

final GetIt sl = GetIt.instance;

void init() {
  // lazy singleton for FirebaseDatabaseProvider
  sl.registerLazySingleton(() => FirebaseDatabseProvider());

  // Registering remote login data source
  sl.registerLazySingleton<RemoteLoginDatasource>(
      () => RemoteLoginDatasourceImpl(sl()));

  // Registering account repository
  sl.registerLazySingleton<AccountRepository>(
      () => AccountRepositoryImlp(sl()));

  // Registering register account repository
  sl.registerLazySingleton<RegisterAccountRepository>(
      () => RegisterReporisatoryImpl(sl<RemoteRegisterDatasource>()));

  // Registering register use cases
  sl.registerLazySingleton<RemoteRegisterUsecase>(
      () => RemoteRegisterUsecase(sl<RegisterAccountRepository>()));
  sl.registerLazySingleton<GetUserInfoUsecase>(
      () => GetUserInfoUsecase(sl<RegisterAccountRepository>()));

  // Registering login use cases
  sl.registerLazySingleton<RemoteLoginUsecase>(() => RemoteLoginUsecase(sl()));
  sl.registerLazySingleton<RemoteLogoutUsecase>(
      () => RemoteLogoutUsecase(sl()));

  // Registering login cubit
  sl.registerFactory<LoginCubit>(() => LoginCubit());
  sl.registerFactory<NotificationCubit>(() => NotificationCubit());

  // Registering remote register data source
  sl.registerLazySingleton<RemoteRegisterDatasource>(
      () => RemoteRegisterDatasourceImlp(sl()));

  // Registering register cubit
  sl.registerFactory<RegisterCubit>(() => RegisterCubit());

  // Registering ticket data source
  sl.registerLazySingleton<RemoteOrderDatasourceInterface>(
      () => RemoteOrderDatasource());

  // Registering ticket repository
  sl.registerLazySingleton<OrderRepository>(
      () => OrderRepositoryImpl(sl<RemoteOrderDatasourceInterface>()));

  // Registering ticket use cases
  sl.registerLazySingleton<AddOrderUsecase>(
      () => AddOrderUsecase(sl<OrderRepository>()));

  sl.registerLazySingleton<GetUsersUsecase>(
      () => GetUsersUsecase(sl<OrderRepository>()));

  sl.registerLazySingleton<UpdateOrderUsecase>(
      () => UpdateOrderUsecase(sl<OrderRepository>()));

  sl.registerLazySingleton<DeleteOrderUsecase>(
      () => DeleteOrderUsecase(sl<OrderRepository>()));
  sl.registerLazySingleton<GetAllOrderUsecase>(
      () => GetAllOrderUsecase(sl<OrderRepository>()));

  // Registering ticket cubits
  sl.registerFactory(() => OrderCubit());

  // Registering restaurant data source
  sl.registerLazySingleton<RestaurantDatasourceInterface>(
      () => RestaurantDatasourceImpl());

  // Registering restaurant repository
  sl.registerLazySingleton<RestaurantReporisatory>(
      () => RestaurantReporisatoryImpl(sl()));

  // Registering restaurant use cases
  sl.registerLazySingleton<AddRestaurantUsecase>(
      () => AddRestaurantUsecase(sl<RestaurantReporisatory>()));
  sl.registerLazySingleton<UploadImageUsecase>(
      () => UploadImageUsecase(sl<RestaurantReporisatory>()));
  sl.registerLazySingleton<GetUploadedImageUsecase>(
      () => GetUploadedImageUsecase(sl<RestaurantReporisatory>()));
  sl.registerLazySingleton(() => FirebaseStorageRepository());
  sl.registerLazySingleton(
      () => DeleteImageUsecase(sl<RestaurantReporisatory>()));
  sl.registerLazySingleton<GetAllRestaurantUsecase>(
      () => GetAllRestaurantUsecase(sl<RestaurantReporisatory>()));

  // Registering restaurant cubits
  sl.registerFactory(() => RestaurantCubit());

  // Registering ProfileCubit
  sl.registerFactory(() => ProfileCubit());
}
