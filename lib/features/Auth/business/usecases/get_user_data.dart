import '../../../../core/errors/failure.dart';
import '../../../../core/params/params.dart';
import '../entities/entity.dart';
import '../repositories/repository.dart';

class GetUserData {
  final UserRepository userRepository;

  GetUserData({required this.userRepository});

  Future<(Failure?, UserEntity?)> call({
    required UserParams userParams,
  }) async {
    return await userRepository.getUserData(UserParams: userParams);
  }
}