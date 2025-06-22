import '../../../../core/errors/failure.dart';
import '../../../../core/params/params.dart';
import '../entities/entity.dart';
import '../repositories/repository.dart';

class GetEscrow {
  final EscrowRepository escrowRepository;

  GetEscrow({required this.escrowRepository});

  Future<(Failure?, List<EscrowEntity>?)> call({
    required EscrowParams escrowParams,
  }) async {
    return await escrowRepository.getEscrow(escrowParams: escrowParams);
  }
  Future<(Failure?, String?)> getUserEscrow({
    required EscrowParams escrowParams,
  }) async {
    return await escrowRepository.getUserEscrow(escrowParams: escrowParams);
  }
  Future<(Failure?, EscrowEntity?)> make({
    required EscrowParams escrowParams,
  }) async {
    return await escrowRepository.makeEscrow(escrowParams: escrowParams);
  }
  Future<(Failure?, EscrowEntity?)> edit({
    required EscrowParams escrowParams,
  }) async {
    return await escrowRepository.EditEscrow(escrowParams: escrowParams);
  }
  Future<(Failure?, EscrowEntity?)> cancel({
    required EscrowParams escrowParams,
  }) async {
    return await escrowRepository.updateEscrow(escrowParams: escrowParams);
  }
  Future<(Failure?, EscrowEntity?)> dispute({
    required EscrowParams escrowParams,
  }) async {
    return await escrowRepository.disputeEscrow(escrowParams: escrowParams);
  }
  Future<(Failure?, EscrowEntity?)> makePayment({
    required EscrowParams escrowParams,
  }) async {
    return await escrowRepository.makePaymentEscrow(escrowParams: escrowParams);
  }
  Future<(Failure?, EscrowEntity?)> release({
    required EscrowParams escrowParams,
  }) async {
    return await escrowRepository.releaseEscrowFund(escrowParams: escrowParams);
  }
  Future<(Failure?, List<ChatEntity>?)> getChat({
    required EscrowParams escrowParams,
  }) async {
    return await escrowRepository.getChat(escrowParams: escrowParams);
  }
}