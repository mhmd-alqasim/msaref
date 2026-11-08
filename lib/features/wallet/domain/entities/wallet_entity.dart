class WalletEntity {
  final int? id;
  final String name;
  final double balance;
  final String currency;
  const WalletEntity({
    this.id,
    required this.name,
    required this.balance,
    required this.currency,
  });
}
