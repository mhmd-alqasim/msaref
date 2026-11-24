import 'package:get_it/get_it.dart';
import 'package:msaref/core/database/database_helper.dart';
import 'package:msaref/features/wallet/data/datasources/wallet_local_datasource.dart';
import 'package:msaref/features/wallet/data/datasources/wallet_local_datasource_impl.dart';
import 'package:msaref/features/wallet/data/repositories/wallet_repository_imp.dart';
import 'package:msaref/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:msaref/features/wallet/domain/usecases/add_wallet_usecase.dart';
import 'package:msaref/features/wallet/domain/usecases/delete_wallet_usecase.dart';
import 'package:msaref/features/wallet/domain/usecases/get_wallet_usecase.dart';
import 'package:msaref/features/wallet/domain/usecases/update_wallet_usecase.dart';
import 'package:msaref/features/wallet/presentation/bloc/wallet_cubit.dart';

final sl = GetIt.instance;

/// sl = Service Locator
/// مستودع واحد لكل الكائنات في التطبيق
/// او فيني اقول متل امين المستودع تبع الورشة الخاصة بعمالي

//البداية
Future<void> initDependencies() async {
  // registerFactory: كل من يطلب يأخذ نسخة جديدة خاصة به (مناسب لـ Bloc / Cubit).
  //ايي متل مصنع دائما بينتج طلب
  // registerLazySingleton: لا يُصنع إلا عند أول طلب، وبعدها الجميع يتشاركون نفس النسخة الواحدة طوال عمر التطبيق (مناسب لـ UseCase / Repository / DataSource).
  // يعني: لا تنشئه الآن
  // انشئه فقط عندما يطلبه أحد

  sl.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());
  _initWallet();
}

void _initWallet() {
  //البداية مع datasourese  databaseHelper
  // DataSource يحتاج DatabaseHelper
  sl.registerLazySingleton<WalletLocalDatasource>(
    () => WalletLocalDatasourceImpl(sl()),
  );
  // Repository يحتاج DataSource
  sl.registerLazySingleton<WalletRepository>(() => WalletRepositoryImp(sl()));

  // UseCases تحتاج Repository
  sl.registerFactory(() => GetWalletsUseCase(sl()));
  sl.registerFactory(() => AddWalletUseCase(sl()));
  sl.registerFactory(() => UpdateWalletUseCase(sl()));
  sl.registerFactory(() => DeleteWalletUseCase(sl()));

  //وهيك حتى وصلنا لعند cubit
  // Cubit يحتاج UseCases
  sl.registerFactory(
    () => WalletCubit(
      getWallets: sl(),
      addWallet: sl(),
      updateWallet: sl(),
      deleteWallet: sl(),
    ),
  );
}

//ملاحظاتي
// من الأسفل للأعلى دائماً:

// DatabaseHelper          ← لا يحتاج أحد
//       ↓
// DataSource              ← يحتاج DatabaseHelper
//       ↓
// Repository              ← يحتاج DataSource
//       ↓
// UseCases                ← يحتاج Repository
//       ↓
// Cubit                   ← يحتاج UseCases
//       ↓
// UI                      ← يحتاج Cubit فقط
