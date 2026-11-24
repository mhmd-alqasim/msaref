import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:msaref/core/usecases/usecase.dart';
import 'package:msaref/features/wallet/domain/entities/wallet_entity.dart';
import 'package:msaref/features/wallet/domain/usecases/add_wallet_usecase.dart';
import 'package:msaref/features/wallet/domain/usecases/delete_wallet_usecase.dart';
import 'package:msaref/features/wallet/domain/usecases/get_wallet_usecase.dart'
    show GetWalletsUseCase;
import 'package:msaref/features/wallet/domain/usecases/update_wallet_usecase.dart';
import 'package:msaref/features/wallet/presentation/bloc/wallet_state.dart';
import 'package:uuid/uuid.dart';

// ملاحظات المعلم
// Repository أو DataSource لا يعرفCubit
// UseCases  فقط يتحدث مع
class WalletCubit extends Cubit<WalletState> {
  final GetWalletsUseCase _getWallets;
  final AddWalletUseCase _addWallet;
  final DeleteWalletUseCase _deleteWallet;
  final UpdateWalletUseCase _updateWallet;

  WalletCubit({
    required this._getWallets,
    required this._addWallet,
    required this._deleteWallet,
    required this._updateWallet,
  }) : super(WalletInitial());

  Future<void> loadWallets() async {
    emit(WalletLoading());
    final result = await _getWallets(const NoParams());

    result.fold(
      (failure) => emit(WalletError(message: failure.message)),
      (wallets) => emit(
        WalletLoaded(wallets: wallets, totalBalance: _calculateTotal(wallets)),
      ),
    );
  }

  double _calculateTotal(List<WalletEntity> wallets) {
    if (wallets.isEmpty) return 0.0;
    return wallets.fold(0.0, (sum, wallet) => sum + wallet.balance);
  }

  //add wallet
  Future<void> addWallet({
    required String name,
    required double balance,
    String currency = 'USD',
  }) async {
    emit(WalletLoading());
    final wallet = WalletEntity(
      id: const Uuid().v4(),
      name: name,
      balance: balance,
      currency: currency,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    final resulte = await _addWallet(wallet);

    resulte.fold((failure) => emit(WalletError(message: failure.message)), (
      _,
    ) async {
      emit(const WalletActionSuccess(message: 'تمت إضافة المحفظة بنجاح'));
      await loadWallets();
    });
  }
  //delete wallet

  Future<void> deleteWallet(String id) async {
    emit(WalletLoading());
    final result = await _deleteWallet(DeleteWalletParams(id));
    result.fold((failure) => emit(WalletError(message: failure.message)), (
      _,
    ) async {
      emit(const WalletActionSuccess(message: 'تم حذف المحفظة'));
      await loadWallets();
    });
  }

  //update wallet
  Future<void> updateWallet({
    required WalletEntity oldWallet,
    required String newName,
    required double newBalance,
  }) async {
    emit(const WalletLoading());

    // copyWith تحافظ على id و createdAt
    // وتحدث updatedAt تلقائياً
    final updatedWallet = oldWallet.copyWith(
      name: newName,
      balance: newBalance,
    );

    final result = await _updateWallet(updatedWallet);

    result.fold((failure) => emit(WalletError(message: failure.message)), (
      _,
    ) async {
      emit(const WalletActionSuccess(message: 'تم تحديث المحفظة بنجاح'));
      await loadWallets();
    });
  }
}
