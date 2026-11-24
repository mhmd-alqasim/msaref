// ── delete_wallet_usecase.dart ────────────────────
import 'package:dartz/dartz.dart';
import 'package:msaref/core/error/failures.dart';
import 'package:msaref/core/usecases/usecase.dart';
import 'package:msaref/features/wallet/domain/repositories/wallet_repository.dart';

/// نعرّف Params خاص بالحذف لأنه يحتاج id فقط
class DeleteWalletParams {
  final String id;
  const DeleteWalletParams(this.id);
}

class DeleteWalletUseCase extends UseCase<Unit, DeleteWalletParams> {
  final WalletRepository repository;
  DeleteWalletUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(DeleteWalletParams params) {
    return repository.deleteWallet(params.id);
  }
}
