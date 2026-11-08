import 'package:dartz/dartz.dart';
import 'package:msaref/core/error/failures.dart';
import 'package:msaref/features/wallet/domain/entities/wallet_entity.dart';
import 'package:msaref/features/wallet/domain/repositories/wallet_repositorie.dart';

class GetWalletUsecase {
  final WalletRepository Repositorie;

  GetWalletUsecase(this.Repositorie);
  Future<Either<Failure, List<WalletEntity>>> call() async {
    return await Repositorie.getWallets();
  }
}
