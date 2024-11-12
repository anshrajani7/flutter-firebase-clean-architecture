import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/tab_data_entity.dart';

abstract class TabRepository {
  Stream<List<TabDataEntity>> getTabData(String tabName);
  Future<Either<Failure, void>> updateTabData(String tabName, TabDataEntity data);
  Future<Either<Failure, List<TabDataEntity>>> getCachedTabData(String tabName);
  Future<Either<Failure, void>> cacheTabData(String tabName, List<TabDataEntity> data);
}