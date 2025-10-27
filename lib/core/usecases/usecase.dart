import 'package:smart_home1/core/utils/type_def.dart';

abstract class UsecaseWithParams<Type, Params>{
  const UsecaseWithParams();
  ResultFuture<Type> call(Params params);
}

abstract class UsecaseWithoutParams<Type>{
  const UsecaseWithoutParams();
  ResultFuture<Type> call();
}