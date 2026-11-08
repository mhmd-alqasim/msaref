import 'package:dartz/dartz.dart';
import 'package:msaref/core/error/failures.dart';
import 'package:msaref/features/wallet/domain/entities/wallet_entity.dart';

abstract class WalletRepository {
  Future<Either<Failure, List<WalletEntity>>> getWallets();
  Future<Either<Failure, Unit>> addWallet(WalletEntity wallet);
  Future<Either<Failure, Unit>> updateWallet(WalletEntity wallet);
  Future<Either<Failure, Unit>> deletWallet(int id);
}
