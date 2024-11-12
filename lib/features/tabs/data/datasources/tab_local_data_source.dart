import 'package:hive/hive.dart';
import '../../../../core/error/exceptions.dart';
import '../models/tab_data_model.dart';

abstract class TabLocalDataSource {
  Future<List<TabDataModel>> getCachedTabData(String tabName);
  Future<void> cacheTabData(String tabName, List<TabDataModel> data);
  Future<bool> isCacheValid(String tabName);
}

class TabLocalDataSourceImpl implements TabLocalDataSource {
  final Box _cache;
  static const cacheValidDuration = Duration(hours: 24);

  TabLocalDataSourceImpl(this._cache);

  @override
  Future<List<TabDataModel>> getCachedTabData(String tabName) async {
    try {
      final jsonList = _cache.get('${tabName}_data') as List<dynamic>?;
      if (jsonList == null) return [];

      return jsonList
          .map((json) => TabDataModel.fromJson(Map<String, dynamic>.from(json)))
          .toList();
    } catch (e) {
      throw CacheException('Failed to get cached data');
    }
  }

  @override
  Future<void> cacheTabData(String tabName, List<TabDataModel> data) async {
    try {
      await _cache.put('${tabName}_data', data.map((e) => e.toJson()).toList());
      await _cache.put('${tabName}_timestamp', DateTime.now().toIso8601String());
    } catch (e) {
      throw CacheException('Failed to cache data');
    }
  }

  @override
  Future<bool> isCacheValid(String tabName) async {
    try {
      final timestamp = _cache.get('${tabName}_timestamp') as String?;
      if (timestamp == null) return false;

      final cacheTime = DateTime.parse(timestamp);
      return DateTime.now().difference(cacheTime) <= cacheValidDuration;
    } catch (e) {
      throw CacheException('Failed to check cache validity');
    }
  }
}