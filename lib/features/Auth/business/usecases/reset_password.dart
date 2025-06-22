import '../../../../core/errors/failure.dart';
import '../../../../core/params/params.dart';
import '../entities/entity.dart';
import '../repositories/repository.dart';

class ResetPasswordCases {
  final UserRepository userRepository;

  ResetPasswordCases({required this.userRepository});

  Future<(Failure?, MessageEntity?)> forgotPassword({
    required UserParams userParams,
  }) async {
    return await userRepository.forgotPassword(UserParams: userParams);
  }
  Future<(Failure?, MessageEntity?)> verifyOtpPassword ({
    required UserParams userParams,
  }) async {
    return await userRepository.verifyOtpPassword(UserParams: userParams);
  }
  Future<(Failure?, MessageEntity?)> ResetPassword({
    required UserParams userParams,
  }) async {
    return await userRepository.ResetPassword(UserParams: userParams);
  }
}