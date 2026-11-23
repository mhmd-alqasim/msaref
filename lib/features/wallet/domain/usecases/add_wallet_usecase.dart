import 'package:dartz/dartz.dart';
import 'package:msaref/core/error/failures.dart';
import 'package:msaref/core/usecases/usecase.dart';
import 'package:msaref/features/wallet/domain/entities/wallet_entity.dart';
import 'package:msaref/features/wallet/domain/repositories/wallet_repository.dart';

class AddWalletUseCase extends UseCase<Unit, WalletEntity> {
  final WalletRepository repository;
  AddWalletUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(WalletEntity params) {
    return repository.addWallet(params);
  }
}
