import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:msaref/core/error/exceptions.dart';
import 'package:msaref/core/error/failures.dart';
import 'package:msaref/features/wallet/data/datasources/wallet_local_datasource.dart';
import 'package:msaref/features/wallet/data/models/wallet_model.dart';
import 'package:msaref/features/wallet/domain/entities/wallet_entity.dart';
import 'package:msaref/features/wallet/domain/repositories/wallet_repository.dart';

// Repository = وسيط بين Domain و Data
//  مهمته الوحيدة:
// ✅ يستدعي DataSource
// ✅ يحول Exception → Failure
// ✅ يرجع Either
class WalletRepositoryImp extends WalletRepository {
  final WalletLocalDatasource dataSource;
  WalletRepositoryImp(this.dataSource);
  @override
  Future<Either<Failure, List<WalletEntity>>> getWallets() async {
    try {
      final wallets = await dataSource.getWallets();
      return Right(wallets);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> addWallet(WalletEntity wallet) async {
    try {
      final model = WalletModel.fromEntity(wallet);
      await dataSource.addWallet(model);
      return const Right(unit);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteWallet(String id) async {
    try {
      await dataSource.deleteWallet(id);
      return Right(unit);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateWallet(WalletEntity wallet) async {
    try {
      final model = WalletModel.fromEntity(wallet);
      await dataSource.updateWallet(model);
      return const Right(unit);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}

// استدعاء addWallet:

// Cubit
//   ↓ WalletEntity
// UseCase
//   ↓ WalletEntity
// Repository        ← يحول Entity → Model
//   ↓ WalletModel              يلتقط CacheException
// DataSource        ← يحول Model → Map
//   ↓ Map
// SQLite ✅

// قراءة getWallets:

// SQLite
//   ↓ List<Map>
// DataSource        ← يحول Map → WalletModel
//   ↓ List<WalletModel>
// Repository        ← Model هو Entity (ترث منه)
//   ↓ Right(List<WalletEntity>)
// UseCase
//   ↓ Either<Failure, List<WalletEntity>>
// Cubit
