import '../../../../core/errors/failure.dart';
import '../../../../core/params/params.dart';
import '../../../Auth/business/entities/entity.dart';


abstract class AccountRepository {
  Future<(Failure?, UserEntity?)> changePin({
    required AccountParams accountParams,
  });
  Future<(Failure?, UserEntity?)> setPin({
    required AccountParams accountParams,
  });
  Future<(Failure?, UserEntity?)> updateKYC1({
    required AccountParams accountParams,
  });
  Future<(Failure?, UserEntity?)> updateKYC2({
    required AccountParams accountParams,
  });
  Future<(Failure?, UserEntity?)> updateKYC2v2({
    required AccountParams accountParams,
  });
  Future<(Failure?, UserEntity?)> updateKYC3({
    required AccountParams accountParams,
  });
  Future<(Failure?, UserEntity?)> resetPassword({
    required AccountParams accountParams,
  });
  Future<(Failure?, UserEntity?)> UpdateUser({
    required AccountParams accountParams,
  });
  Future<(Failure?, UserEntity?)> VerifyEmail({
    required AccountParams accountParams,
  });
  Future<(Failure?, List<NotificationEntity>?)> getNotification({
    required AccountParams accountParams,
  });
}