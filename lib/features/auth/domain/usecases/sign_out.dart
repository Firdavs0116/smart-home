import 'package:dartz/dartz.dart';
import 'package:smart_home1/features/auth/domain/repository/auth_repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class SignOutUseCase implements UsecaseWithoutParams<void> {
  final AuthRepository repository;

  SignOutUseCase(this.repository);

  @override
  Future<Either<Failures, void>> call() async {
    return await repository.signOut();
  }
}