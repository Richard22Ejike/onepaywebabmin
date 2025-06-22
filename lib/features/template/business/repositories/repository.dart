import '../../../../core/errors/failure.dart';
import '../../../../core/params/params.dart';
import '../entities/entity.dart';

abstract class TemplateRepository {
  Future<(Failure?, TemplateEntity?)> getTemplate({
    required TemplateParams templateParams,
  });
}