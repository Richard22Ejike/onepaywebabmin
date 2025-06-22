import '../../../../core/errors/failure.dart';
import '../../../../core/params/params.dart';
import '../entities/entity.dart';

abstract class PaybillsRepository {
  Future<(Failure?, PayBillsEntity?)> getPaybills({
    required PaybillsParams paybillsParams,
  });
  Future<(Failure?, PayBillsEntity?)> payPaybills({
    required PaybillsParams paybillsParams,
  });
  Future<(Failure?, List<TvEntity>?)> Tvbills({
    required PaybillsParams paybillsParams,
  });
}

