import 'package:msaref/core/database/database_helper.dart';
import 'package:msaref/core/error/exceptions.dart';
import 'package:msaref/features/wallet/data/datasources/wallet_local_datasource.dart';
import 'package:msaref/features/wallet/data/models/wallet_model.dart';

const String _walletsTable = 'wallets';

class WalletLocalDatasourceImpl extends WalletLocalDatasource {
  final DatabaseHelper databaseHelper;
  WalletLocalDatasourceImpl(this.databaseHelper);
  @override
  Future<void> addWallet(WalletModel wallet) async {
    try {
      await databaseHelper.insert(_walletsTable, wallet.toMap());
    } catch (e) {
      throw CacheException(message: 'فشل في إضافة المحفظة: $e');
    }
  }

  @override
  Future<void> deleteWallet(String id) async {
    try {
      await databaseHelper.delete(
        _walletsTable,
        where: 'id=?',
        whereArgs: [id],
      );
    } catch (e) {
      throw CacheException(message: 'فشل في حذف المحفظة: $e');
    }
  }

  @override
  Future<List<WalletModel>> getWallets() async {
    try {
      final maps = await databaseHelper.query(
        _walletsTable,
        orderBy: 'created_at DESC', // الأحدث أولاً
      );

      // نحول كل Map إلى WalletModel
      return maps.map((map) => WalletModel.fromMap(map)).toList();
    } catch (e) {
      throw CacheException(message: 'فشل في جلب المحافظ: $e');
    }
  }

  @override
  Future<void> updateWallet(WalletModel wallet) async {
    try {
      await databaseHelper.update(
        _walletsTable,
        wallet.toMap(),
        where: 'id = ?',
        whereArgs: [wallet.id],
      );
    } catch (e) {
      throw CacheException(message: 'فشل في تحديث المحفظة: $e');
    }
  }
}
