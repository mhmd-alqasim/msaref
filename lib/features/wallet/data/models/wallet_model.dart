// Entity  = الحقيقة في تطبيقك (domain)
//           لا تعرف شيئاً عن قواعد البيانات أو JSON

// Model   = Entity + قدرة التحويل
//           يعرف كيف يتحول من/إلى Map (SQLite)

import 'package:msaref/features/wallet/domain/entities/wallet_entity.dart';

class WalletModel extends WalletEntity {
  const WalletModel({
    required super.id,
    required super.name,
    required super.balance,
    required super.currency,
    required super.createdAt,
    required super.updatedAt,
  });

  // from map ---->model

  factory WalletModel.fromMap(Map<String, dynamic> map) {
    return WalletModel(
      id: map['id'] as String,
      name: map['name'] as String,
      balance: map['balance'] as double,
      currency: map['currency'] as String? ?? 'USD',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updated_at'] as int),
    );
  }
}
