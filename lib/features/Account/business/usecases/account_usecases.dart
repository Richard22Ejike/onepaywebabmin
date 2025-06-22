import '../../../../core/errors/failure.dart';
import '../../../../core/params/params.dart';
import '../../../Auth/business/entities/entity.dart';
import '../repositories/repository.dart';

class Accounts {
  final AccountRepository accountRepository;

  Accounts({required this.accountRepository});

  Future<(Failure?, UserEntity?)> changePin({
    required AccountParams accountParams,
  }) async {
    return await accountRepository.changePin(accountParams: accountParams);
  }
  Future<(Failure?, UserEntity?)> setPin({
    required AccountParams accountParams,
  }) async {
    return await accountRepository.setPin(accountParams: accountParams);
  }
  Future<(Failure?, UserEntity?)> updateKYC1({
    required AccountParams accountParams,
  }) async {
    return await accountRepository.updateKYC1(accountParams: accountParams);
  }
  Future<(Failure?, UserEntity?)> updateKYC2({
    required AccountParams accountParams,
  }) async {
    return await accountRepository.updateKYC2(accountParams: accountParams);
  }
  Future<(Failure?, UserEntity?)> updateKYC2v2({
    required AccountParams accountParams,
  }) async {
    return await accountRepository.updateKYC2v2(accountParams: accountParams);
  }
  Future<(Failure?, UserEntity?)> updateKYC3({
    required AccountParams accountParams,
  }) async {
    return await accountRepository.updateKYC3(accountParams: accountParams);
  }
  Future<(Failure?, UserEntity?)> resetPassword({
    required AccountParams accountParams,
  })async {
    return await accountRepository.resetPassword(accountParams: accountParams);
  }
  Future<(Failure?, UserEntity?)> UpdateUser({
    required AccountParams accountParams,
  })async {
    return await accountRepository.UpdateUser(accountParams: accountParams);
  }
  Future<(Failure?, UserEntity?)> VerifyEmail({
    required AccountParams accountParams,
  })async {
    return await accountRepository.VerifyEmail(accountParams: accountParams);
  }
  Future<(Failure?,  List<NotificationEntity>?)> getNotification({
    required AccountParams accountParams,
  })async {
    return await accountRepository.getNotification(accountParams: accountParams);
  }
}