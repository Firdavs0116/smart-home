import 'package:dartz/dartz.dart';
import 'package:smart_home1/features/auth/domain/repository/auth_repository.dart';
import '../entities/user_entity.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class SignUpUseCase implements UsecaseWithParams<UserEntity, SignUpParams> {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  @override
  Future<Either<Failures, UserEntity>> call(SignUpParams params) async {
    return await repository.signUp(
      params.email,
      params.password,
      params.name,
    );
  }
}

class SignUpParams {
  final String email;
  final String password;
  final String name;

  SignUpParams({
    required this.email,
    required this.password,
    required this.name,
  });
}