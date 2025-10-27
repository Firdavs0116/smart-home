import 'package:smart_home1/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
typedef ResultFuture<T> = Future<Either<Failures, T>>;
typedef ResultVoid = Future<Either<Failures, void>>;
typedef DataMap = Map<String, dynamic>;