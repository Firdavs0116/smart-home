import 'package:dartz/dartz.dart';
import 'package:smart_home1/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:smart_home1/features/auth/domain/repository/auth_repository.dart';
import '../../domain/entities/user_entity.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failures, UserEntity>> signIn(String email, String password) async {
    try {
      final user = await remoteDataSource.signIn(email, password);
      return Right(user);
    } on ServerExceptions catch (e) {
      return Left(ServerFailure(message: e.message, statuscode: e.statuscode));
    }
  }

  @override
  Future<Either<Failures, UserEntity>> signUp(String email, String password, String name) async {
    try {
      final user = await remoteDataSource.signUp(email, password, name);
      return Right(user);
    } on ServerExceptions catch (e) {
      return Left(ServerFailure(message: e.message, statuscode: e.statuscode));
    }
  }

  @override
  Future<Either<Failures, void>> signOut() async {
    try {
      await remoteDataSource.signOut();
      return const Right(null);
    } on ServerExceptions catch (e) {
      return Left(ServerFailure(message: e.message, statuscode: e.statuscode));
    }
  }

  @override
  Stream<UserEntity?> get authStateChanges => remoteDataSource.authStateChanges;
  
  @override
Future<Either<Failures, UserEntity?>> getCurrentUser() async {
  try {
    final user = await remoteDataSource.getCurrentUser();
    return Right(user);
  } on ServerExceptions catch (e) {
    return Left(ServerFailure(message: e.message, statuscode: e.statuscode));
  }
}
}