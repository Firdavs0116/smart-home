import 'package:dartz/dartz.dart';
import '../entities/user_entity.dart';
import '../../../../core/errors/failures.dart';

abstract class AuthRepository {
  Future<Either<Failures, UserEntity>> signIn(String email, String password);
  Future<Either<Failures, UserEntity>> signUp(String email, String password, String name);
  Future<Either<Failures, void>> signOut();
  Stream<UserEntity?> get authStateChanges;
  Future<Either<Failures, UserEntity?>> getCurrentUser();
}