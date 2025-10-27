import 'package:equatable/equatable.dart';

abstract class Failures extends Equatable{
  final String message;
  final int statuscode;

  const Failures ({ 
    required this.message, 
    required this.statuscode
    });
    @override
    List<Object> get props => [message, statuscode];
}

class APIFailure extends Failures{
  const APIFailure({required super.message, required super.statuscode});

}

class ServerFailure extends Failures{
  const ServerFailure({required super.message, required super.statuscode});
}

class CacheFailure extends Failures{
  const CacheFailure({required super.message, required super.statuscode});
}