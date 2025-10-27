import 'package:dartz/dartz.dart';
import 'package:smart_home1/features/auth/domain/repository/auth_repository.dart';
import '../entities/user_entity.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class SignInUseCase implements UsecaseWithParams<UserEntity, SignInParams> {
  final AuthRepository repository;

  SignInUseCase(this.repository);

  @override
  Future<Either<Failures, UserEntity>> call(SignInParams params) async {
    return await repository.signIn(params.email, params.password);
  }
}

class SignInParams {
  final String email;
  final String password;

  SignInParams({required this.email, required this.password});
}