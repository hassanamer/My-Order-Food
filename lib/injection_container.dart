import 'package:get_it/get_it.dart';
import 'package:order/core/database/firebase_db.dart';
import 'package:order/features/cart/data/datasource/cart_datasource.dart';
import 'package:order/features/cart/data/reporisatory_imlp/cart_reporisatory_impl.dart';
import 'package:order/features/cart/domain/reporisatory/cart_reporisatory.dart';
import 'package:order/features/cart/domain/usecase/add_items_to_cart_usecase.dart';
import 'package:order/features/cart/domain/usecase/clear_cart_items_usecase.dart';
import 'package:order/features/cart/domain/usecase/get_all_cart_items_usecase.dart';
import 'package:order/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:order/features/event/data/datasource/remote_order_datasource.dart';
import 'package:order/features/event/data/reporisatory/remote_order_repository_impl.dart';
import 'package:order/features/event/domain/remote_usecases/add_order_usecase.dart';
import 'package:order/features/event/domain/remote_usecases/delete_ticket.dart';
import 'package:order/features/event/domain/remote_usecases/remote_get_all_ticket.dart';
import 'package:order/features/event/domain/remote_usecases/update_ticket.dart';
import 'package:order/features/event/domain/reporisatory/ticket_reporisatory.dart';
import 'package:order/features/event/presentation/cubit/order_cubit.dart';
import 'package:order/features/login/data/datasources/remote_login_user.dart';
import 'package:order/features/login/domain/usecases/remote_login_usecase.dart';
import 'package:order/features/login/domain/usecases/remote_logout_usecase.dart';
import 'package:order/features/login/presentation/cubit/login_cubit.dart';
import 'package:order/features/register/data/datasource/remote_register_user_datasource.dart';
import 'package:order/features/register/data/reporisatory/register_repo_impl.dart';
import 'package:order/features/register/domain/reposisatory/register_reprisatory.dart';
import 'package:order/features/register/domain/usecase/get_user_info_usecase.dart';
import 'package:order/features/register/domain/usecase/remote_register_usecase.dart';
import 'package:order/features/register/presentation/cubit/register_cubit.dart';
import 'package:order/features/restaurant/data/datasource/restaurant_datasource.dart';
import 'package:order/features/restaurant/data/reporisatory/restaurant_reporisatory_impl.dart';
import 'package:order/features/restaurant/domain/reporisatory/restaurant_reporisatory.dart';
import 'package:order/features/restaurant/domain/usecase/add_menu_items_usecase.dart';
import 'package:order/features/restaurant/domain/usecase/add_restaurant_usecase.dart';
import 'package:order/features/restaurant/domain/usecase/get_all_menu.dart';
import 'package:order/features/restaurant/domain/usecase/get_all_restaurant_usecase.dart';
import 'package:order/features/restaurant/domain/usecase/get_uploaded_iamge_usecase.dart';
import 'package:order/features/restaurant/domain/usecase/upload_image_usecase.dart';
import 'package:order/features/restaurant/presentation/cubit/menu_cubit.dart';
import 'package:order/features/restaurant/presentation/cubit/restaurant_cubit.dart';

import 'features/cart/domain/usecase/view_orders_usecase.dart';
import 'features/login/data/datasources/local_login_user.dart';
import 'features/login/data/reporisatory/account_reporisatory_impl.dart';
import 'features/login/domain/repositories/account_repository.dart';
import 'features/register/user/profile_cubit.dart';

final sl = GetIt.instance;

void init() {
  // lazy singleton for FirebaseDatabaseProvider
  sl.registerLazySingleton(() => FirebaseDatabseProvider());

  // Registering local database data source
  sl.registerLazySingleton<LocalDatabaseDataSource>(
      () => DatabaseDataSourceImpl(sl()));

  // Registering remote login data source
  sl.registerLazySingleton<RemoteLoginDatasource>(
      () => RemoteLoginDatasourceImpl(sl()));

  // Registering account repository
  sl.registerLazySingleton<AccountRepository>(
      () => AccountRepositoryImlp(sl()));

  // Registering login use cases
  sl.registerLazySingleton<RemoteLoginUsecase>(() => RemoteLoginUsecase(sl()));
  sl.registerLazySingleton<RemoteLogoutUsecase>(
      () => RemoteLogoutUsecase(sl()));

  // Registering login cubit
  sl.registerFactory<LoginCubit>(() => LoginCubit());

  // Registering remote register data source
  sl.registerLazySingleton<RemoteRegisterDatasource>(
      () => RemoteRegisterDatasourceImlp(sl()));

  // Registering register account repository
  sl.registerLazySingleton<RegisterAccountRepository>(
      () => RegisterReporisatoryImpl(sl<RemoteRegisterDatasource>()));

  // Registering register use cases
  sl.registerLazySingleton<RemoteRegisterUsecase>(
      () => RemoteRegisterUsecase(sl<RegisterAccountRepository>()));
  sl.registerLazySingleton<GetUserInfoUsecase>(
      () => GetUserInfoUsecase(sl<RegisterAccountRepository>()));

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
  sl.registerLazySingleton<AddMenuItemsUsecase>(
      () => AddMenuItemsUsecase(sl<RestaurantReporisatory>()));
  sl.registerLazySingleton<GetAllRestaurantUsecase>(
      () => GetAllRestaurantUsecase(sl<RestaurantReporisatory>()));
  sl.registerLazySingleton<GetAllMenuUsecase>(
      () => GetAllMenuUsecase(sl<RestaurantReporisatory>()));

  // Registering restaurant cubits
  sl.registerFactory(() => RestaurantCubit());
  sl.registerFactory(() => MenuCubit());

  // Registering cart data source
  sl.registerLazySingleton<CartDatasourceInterface>(() => CartDatasourceImpl());

  // Registering cart repository
  sl.registerLazySingleton<CartReporisatoryInterface>(
      () => CartReporisatoryImpl(sl()));

  // Registering cart use cases
  sl.registerLazySingleton<AddProductToCartUsecase>(
      () => AddProductToCartUsecase(sl<CartReporisatoryInterface>()));
  sl.registerLazySingleton<GetAllCartItemsUsecase>(
      () => GetAllCartItemsUsecase(sl<CartReporisatoryInterface>()));
  sl.registerLazySingleton<ViewOrderUsecase>(
      () => ViewOrderUsecase(sl<CartReporisatoryInterface>()));
  sl.registerLazySingleton<ClearCartItemsUsecase>(
      () => ClearCartItemsUsecase(sl<CartReporisatoryInterface>()));

  // Registering cart cubit
  sl.registerFactory(() => CartCubit());

  // Registering ProfileCubit
  sl.registerFactory(() => ProfileCubit());
}
