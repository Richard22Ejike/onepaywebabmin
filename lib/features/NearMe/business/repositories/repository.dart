import 'package:flutter_chat_ui/flutter_chat_ui.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/params/params.dart';
import '../entities/entity.dart';

abstract class NearMeRepository {
  Future<(Failure?, List<NearMeEntity>?)> getNearMe({
    required NearMeParams nearmeParams,
  });
  Future<(Failure?, List<NearMeEntity>?)> getUserNearMe({
    required NearMeParams nearmeParams,
  });
  Future<(Failure?, NearMeEntity?)> makeNearMe({
    required NearMeParams nearmeParams,
  });
  Future<(Failure?, ChatRoomEntity?)> makeChatRoom({required NearMeParams nearmeParams});

  Future<(Failure?, NearMeEntity?, SuccessMessage?)> EditNearMe({
    required NearMeParams nearmeParams,
  });

  Future<(Failure?, List<ChatRoomEntity>?)> getChat({
    required NearMeParams nearmeParams,
  });

  Future<(Failure?, List<NearMeChatEntity>?)> getNearMeChat({
    required NearMeParams nearmeParams,
  });
}