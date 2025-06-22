import 'package:flutter_chat_ui/flutter_chat_ui.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/params/params.dart';
import '../entities/entity.dart';
import '../repositories/repository.dart';

class GetNearMe {
  final NearMeRepository nearmeRepository;

  GetNearMe({required this.nearmeRepository});

  Future<(Failure?, List<NearMeEntity>?)> call({
    required NearMeParams nearmeParams,
  }) async {
    return await nearmeRepository.getNearMe(nearmeParams: nearmeParams);
  }
  Future<(Failure?, List<NearMeEntity>?)> getUserNearMe({
    required NearMeParams nearmeParams,
  }) async {
    return await nearmeRepository.getUserNearMe(nearmeParams: nearmeParams);
  }
  Future<(Failure?, NearMeEntity?)> make({
    required NearMeParams nearmeParams,
  }) async {
    return await nearmeRepository.makeNearMe(nearmeParams: nearmeParams);
  }
  Future<(Failure?, ChatRoomEntity?)> makeChatRoom({required NearMeParams nearmeParams}) async{
    return await nearmeRepository.makeChatRoom( nearmeParams:nearmeParams);
  }
  Future<(Failure?, NearMeEntity?,SuccessMessage?)> edit({
    required NearMeParams nearmeParams,
  }) async {
    return await nearmeRepository.EditNearMe(nearmeParams: nearmeParams);
  }
  Future<(Failure?, NearMeEntity?, SuccessMessage?)> cancel({
    required NearMeParams nearmeParams,
  }) async {
    return await nearmeRepository.EditNearMe(nearmeParams: nearmeParams);
  }

  Future<(Failure?, List<ChatRoomEntity>?)> getChat({
    required NearMeParams nearmeParams,
  }) async {
    return await nearmeRepository.getChat(nearmeParams: nearmeParams);
  }
  Future<(Failure?, List<NearMeChatEntity>?)> getNearMeChat({
    required NearMeParams nearmeParams,
  })async {
    return await nearmeRepository.getNearMeChat(nearmeParams: nearmeParams);
  }
}