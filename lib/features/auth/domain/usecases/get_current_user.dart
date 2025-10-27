import 'package:dartz/dartz.dart';
import 'package:smart_home1/features/auth/domain/repository/auth_repository.dart';
import '../entities/user_entity.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class GetCurrentUserUseCase implements UsecaseWithoutParams<UserEntity?> {
  final AuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  @override
  Future<Either<Failures, UserEntity?>> call() async {
    return await repository.getCurrentUser();
  }
}