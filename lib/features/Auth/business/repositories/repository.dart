import '../../../../core/errors/failure.dart';
import '../../../../core/params/params.dart';
import '../entities/entity.dart';

abstract class UserRepository {
  Future<(Failure?, UserEntity?)> createUser({
    required UserParams UserParams,
  });
  Future<(Failure?, MessageEntity?)> phoneOtp({
    required UserParams UserParams,
  });
  Future<(Failure?, MessageEntity?)> emailOtp({
    required UserParams UserParams,
  });
  Future<(Failure?, MessageEntity?)> verifyOtp({
    required UserParams UserParams,
  });
  Future<(Failure?, UserEntity?)> signInUser({
    required UserParams UserParams,
  });
  Future<(Failure?, UserEntity?)> getUserData({
    required UserParams UserParams,
  });
  Future<(Failure?, MessageEntity?)> forgotPassword({
    required UserParams UserParams,
  });
  Future<(Failure?, MessageEntity?)> verifyOtpPassword({
    required UserParams UserParams,
  });
  Future<(Failure?, MessageEntity?)> ResetPassword({
    required UserParams UserParams,
  });
}