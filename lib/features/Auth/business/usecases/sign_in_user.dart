import 'dart:developer';

import 'package:onepluspay/features/Auth/business/repositories/repository.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/params/params.dart';
import '../entities/entity.dart';


class SignInUser {
  final UserRepository userRepository;

  SignInUser({required this.userRepository});

  Future<(Failure?, UserEntity?)> call({
    required UserParams userParams,
  }) async {
    return await userRepository.signInUser(UserParams: userParams);
  }
}