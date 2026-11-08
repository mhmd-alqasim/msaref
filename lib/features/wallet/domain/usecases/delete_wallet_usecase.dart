import 'package:dartz/dartz.dart';
import 'package:msaref/core/error/failures.dart';
import 'package:msaref/features/wallet/domain/entities/wallet_entity.dart';
import 'package:msaref/features/wallet/domain/repositories/wallet_repositorie.dart';

class DeleteWalletUseCase {
  final WalletRepository repository;

  DeleteWalletUseCase(this.repository);

  Future<Either<Failure, Unit>> call(WalletEntity wallet) async {
    return await repository.deletWallet(wallet.id!);
  }
}
