import '../../../../core/errors/failure.dart';
import '../../../../core/params/params.dart';
import '../entities/entity.dart';
import '../repositories/repository.dart';

class GetPaybills {
  final PaybillsRepository paybillsRepository;

  GetPaybills({required this.paybillsRepository});

  Future<(Failure?, PayBillsEntity?)> call({
    required PaybillsParams paybillsParams,
  }) async {
    return await paybillsRepository.getPaybills(paybillsParams: paybillsParams);
  }
  Future<(Failure?, PayBillsEntity?)> payPaybills({
    required PaybillsParams paybillsParams,
  }) async {
    return await paybillsRepository.payPaybills(paybillsParams: paybillsParams);
  }
  Future<(Failure?,List<TvEntity>?)> Tvbills({
    required PaybillsParams paybillsParams,
  }) async {
    return await paybillsRepository.Tvbills(paybillsParams: paybillsParams);
  }
}