import '../../../../core/connection/network_info.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/params/params.dart';
import '../../business/repositories/repository.dart';
import '../datasources/template_local_data_source.dart';
import '../datasources/template_remote_data_source.dart';
import '../models/template_model.dart';

class TemplateRepositoryImpl implements TemplateRepository {
  final TemplateRemoteDataSource remoteDataSource;
  final TemplateLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  TemplateRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<(Failure?, TemplateModel?)> getTemplate(
      {required TemplateParams templateParams}) async {
    if (await networkInfo.isConnected!) {
      try {
        TemplateModel remoteTemplate =
        await remoteDataSource.getTemplate(templateParams: templateParams);

        localDataSource.cacheTemplate(templateToCache: remoteTemplate);

        return  (null,remoteTemplate);
      } on ServerException {
        return (ServerFailure(errorMessage: 'This is a server exception'),null);
      }
    } else {
      try {
        TemplateModel localTemplate = await localDataSource.getLastTemplate();
        return (null,localTemplate);
      } on CacheException {
        return (CacheFailure(errorMessage: 'This is a cache exception'),null);
      }
    }
  }
}