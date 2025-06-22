import '../../../../core/errors/failure.dart';
import '../../../../core/params/params.dart';
import '../entities/entity.dart';

abstract class EscrowRepository {
  Future<(Failure?, List<EscrowEntity>?)> getEscrow({
    required EscrowParams escrowParams,
  });
  Future<(Failure?, String?)> getUserEscrow({
    required EscrowParams escrowParams,
  });
  Future<(Failure?, EscrowEntity?)> makeEscrow({
    required EscrowParams escrowParams,
  });
  Future<(Failure?, EscrowEntity?)> EditEscrow({
    required EscrowParams escrowParams,
  });
  Future<(Failure?, EscrowEntity?)> updateEscrow({
    required EscrowParams escrowParams,
  });
  Future<(Failure?, EscrowEntity?)> disputeEscrow({
    required EscrowParams escrowParams,
  });
  Future<(Failure?, EscrowEntity?)> releaseEscrowFund({
    required EscrowParams escrowParams,
  });
  Future<(Failure?, EscrowEntity?)> makePaymentEscrow({
    required EscrowParams escrowParams,
  });
  Future<(Failure?, List<ChatEntity>?)> getChat({
    required EscrowParams escrowParams,
  });
}