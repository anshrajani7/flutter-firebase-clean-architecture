import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/tab_data_entity.dart';
import '../../domain/repositories/tab_repository.dart';
import '../datasources/tab_local_data_source.dart';
import '../datasources/tab_remote_data_source.dart';
import '../models/tab_data_model.dart';

class TabRepositoryImpl implements TabRepository {
  final TabRemoteDataSource remoteDataSource;
  final TabLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  TabRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Stream<List<TabDataEntity>> getTabData(String tabName) async* {
    if (await networkInfo.isConnected) {
      try {
        await for (final data in remoteDataSource.getTabData(tabName)) {
          // Cache the data
          await localDataSource.cacheTabData(tabName, data);
          yield data;
        }
      } on ServerException catch (e) {
        // If server fails, try to get cached data
        if (await localDataSource.isCacheValid(tabName)) {
          yield await localDataSource.getCachedTabData(tabName);
        } else {
          throw CacheException('Cache expired and server error: ${e.message}');
        }
      }
    } else {
      if (await localDataSource.isCacheValid(tabName)) {
        yield await localDataSource.getCachedTabData(tabName);
      } else {
        throw CacheException('Cache expired and no internet connection');
      }
    }
  }

  @override
  Future<Either<Failure, void>> updateTabData(
      String tabName,
      TabDataEntity data,
      ) async {
    if (await networkInfo.isConnected) {
      try {
        // Convert TabDataEntity to TabDataModel
        final tabDataModel = TabDataModel(
          id: data.id,
          title: data.title,
          content: data.content,
          lastUpdated: data.lastUpdated,
          additionalData: data.additionalData,
        );

        await remoteDataSource.updateTabData(tabName, tabDataModel);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<TabDataEntity>>> getCachedTabData(
      String tabName,
      ) async {
    try {
      final cachedData = await localDataSource.getCachedTabData(tabName);
      if (await localDataSource.isCacheValid(tabName)) {
        return Right(cachedData);
      } else {
        return const Left(CacheFailure('Cache has expired'));
      }
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> cacheTabData(
      String tabName,
      List<TabDataEntity> data,
      ) async {
    try {
      // Convert List<TabDataEntity> to List<TabDataModel>
      final tabDataModels = data.map((entity) => TabDataModel(
        id: entity.id,
        title: entity.title,
        content: entity.content,
        lastUpdated: entity.lastUpdated,
        additionalData: entity.additionalData,
      )).toList();

      await localDataSource.cacheTabData(tabName, tabDataModels);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}