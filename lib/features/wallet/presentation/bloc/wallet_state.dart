import 'package:msaref/features/wallet/domain/entities/wallet_entity.dart';

abstract class WalletState {
  const WalletState();
}

class WalletInitial extends WalletState {
  const WalletInitial();
}

class WalletLoading extends WalletState {
  const WalletLoading();
}

class WalletLoaded extends WalletState {
  final List<WalletEntity> wallets;
  final double totalBalance;
  const WalletLoaded({required this.wallets, required this.totalBalance});
}

class WalletActionSuccess extends WalletState {
  final String message;
  const WalletActionSuccess({required this.message});
}

class WalletError extends WalletState {
  final String message;
  const WalletError({required this.message});
}
