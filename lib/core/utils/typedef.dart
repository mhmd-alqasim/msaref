import 'package:dartz/dartz.dart';
import 'package:msaref/core/error/failures.dart';

typedef ResultFuture<T> = Future<Either<Failure, T>>;
typedef ResultFutureVoid = Future<Either<Failure, void>>;
