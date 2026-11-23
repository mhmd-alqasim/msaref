class WalletEntity {
  final String id;
  final String name;
  final double balance;
  final String currency;
  final DateTime createdAt;
  final DateTime updatedAt;
  const WalletEntity({
    required this.id,
    required this.name,
    required this.balance,
    required this.currency,
    required this.createdAt,
    required this.updatedAt,
  });

  /// نحتاج copyWith لتحديث حقل واحد فقط دون تغيير الباقي

  WalletEntity copyWith({String? name, double? balance, String? currency}) {
    return WalletEntity(
      id: id, // id لا يتغير أبداً
      name: name ?? this.name,
      balance: balance ?? this.balance,
      currency: currency ?? this.currency,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}
