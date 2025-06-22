import 'dart:developer';

import 'package:onepluspay/features/Auth/business/repositories/repository.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/params/params.dart';
import '../entities/entity.dart';


class CreateUser {
  final UserRepository userRepository;

  CreateUser({required this.userRepository});

  Future<(Failure?, MessageEntity?)> phoneOtp({
    required UserParams userParams,
  }) async {
    log('good1');
    return await userRepository.phoneOtp(UserParams: userParams);
  }

  Future<(Failure?, MessageEntity?)> emailOtp({
    required UserParams userParams,
  }) async {
    log('good1');
    return await userRepository.emailOtp(UserParams: userParams);
  }

  Future<(Failure?, MessageEntity?)> verifyOtp({
    required UserParams userParams,
  }) async {
    log('good1');
    return await userRepository.verifyOtp(UserParams: userParams);
  }


  Future<(Failure?, UserEntity?)> call({
    required UserParams userParams,
  }) async {
    return await userRepository.createUser(UserParams: userParams);
  }
}

