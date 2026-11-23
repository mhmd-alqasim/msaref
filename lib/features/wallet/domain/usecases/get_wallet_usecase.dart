import 'package:dartz/dartz.dart';
import 'package:msaref/core/error/failures.dart';
import 'package:msaref/core/usecases/usecase.dart';
import 'package:msaref/features/wallet/domain/entities/wallet_entity.dart';
import 'package:msaref/features/wallet/domain/repositories/wallet_repository.dart';

class GetWalletsUseCase extends UseCase<List<WalletEntity>, NoParams> {
  final WalletRepository repository;
  GetWalletsUseCase(this.repository);

  @override
  Future<Either<Failure, List<WalletEntity>>> call(NoParams params) {
    return repository.getWallets();
  }
}
