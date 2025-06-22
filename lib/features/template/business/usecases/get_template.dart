import '../../../../core/errors/failure.dart';
import '../../../../core/params/params.dart';
import '../entities/entity.dart';
import '../repositories/repository.dart';

class GetTemplate {
  final TemplateRepository templateRepository;

  GetTemplate({required this.templateRepository});

  Future<(Failure?, TemplateEntity?)> call({
    required TemplateParams templateParams,
  }) async {
    return await templateRepository.getTemplate(templateParams: templateParams);
  }
}