import 'package:dartz/dartz.dart';
import 'package:msaref/core/error/exceptions.dart';
import 'package:msaref/core/error/failures.dart';
import 'package:msaref/features/wallet/data/datasources/wallet_local_datasource.dart';
import 'package:msaref/features/wallet/data/models/wallet_model.dart';
import 'package:msaref/features/wallet/domain/entities/wallet_entity.dart';
import 'package:msaref/features/wallet/domain/repositories/wallet_repository.dart';

// Repository = وسيط بين Domain و Data
//  مهمته الوحيدة:
// ✅ يستدعي DataSource
// ✅ يحول Exception → Failure
// ✅ يرجع Either
class WalletRepositoryImp extends WalletRepository {
  final WalletLocalDatasource dataSource;
  WalletRepositoryImp(this.dataSource);
  @override
  Future<Either<Failure, List<WalletEntity>>> getWallets() async {
    try {
      final wallets = await dataSource.getWallets();
      return Right(wallets);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> addWallet(WalletEntity wallet) async {
    try {
      final model = WalletModel.fromEntity(wallet);
      await dataSource.addWallet(model);
      return const Right(unit);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteWallet(String id) async {
    try {
      await dataSource.deleteWallet(id);
      return Right(unit);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateWallet(WalletEntity wallet) async {
    try {
      final model = WalletModel.fromEntity(wallet);
      await dataSource.updateWallet(model);
      return const Right(unit);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}

// ① المستخدم يضغط "إضافة محفظة"
//         ↓
// ② Widget تستدعي:
//    cubit.addWallet(name: 'محفظتي', balance: 500)
//         ↓
// ③ WalletCubit يبني Entity ويستدعي UseCase:
//    addWalletUseCase(WalletEntity(...))
//         ↓
// ④ AddWalletUseCase يستدعي Repository:
//    repository.addWallet(entity)
//         ↓
// ⑤ WalletRepositoryImpl يحول ويستدعي DataSource:
//    Entity → Model
//    dataSource.addWallet(model)
//         ↓
// ⑥ WalletLocalDataSourceImpl يحفظ في SQLite:
//    Model → Map
//    db.insert('wallets', map)
//         ↓
// ⑦ النتيجة ترجع عكسياً:
//    void → Unit → Right(unit) → emit(WalletAdded)
//         ↓
// ⑧ Widget تتحدث تلقائياً ✅
