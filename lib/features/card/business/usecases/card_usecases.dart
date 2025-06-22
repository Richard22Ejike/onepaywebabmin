import '../../../../core/errors/failure.dart';
import '../../../../core/params/params.dart';
import '../entities/card_entity.dart';
import '../repositories/repository.dart';

class CardUseCases {
  final CardRepository cardRepository;

  CardUseCases({required this.cardRepository});

  Future<(Failure?, List<CardEntity>?)> call({
    required CardParams cardParams,
  }) async {
    return await cardRepository.getCards(cardParams: cardParams);
  }
  Future<(Failure?, CardEntity?)> addCard({
    required CardParams cardParams,
  }) async {
    return await cardRepository.addCard(cardParams: cardParams);
  }
}