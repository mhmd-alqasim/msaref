// DataSource = الوحيد المسموح له بالتحدث مع SQLite

// Repository لا يتحدث مع SQLite مباشرة
// Repository يتحدث مع DataSource فقط

// لماذا؟
// لو غيرنا قاعدة البيانات مستقبلاً
// نغير DataSource فقط، الباقي لا يتأثر

import 'package:msaref/features/wallet/data/models/wallet_model.dart';

abstract class WalletLocalDatasource {
  Future<List<WalletModel>> getWallets();
  Future<void> addWallet(WalletModel wallet);
  Future<void> updateWallet(WalletModel wallet);
  Future<void> deleteWallet(String id);
}
