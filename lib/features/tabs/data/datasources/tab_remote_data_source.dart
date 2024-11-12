import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/error/exceptions.dart';
import '../models/tab_data_model.dart';

abstract class TabRemoteDataSource {
  Stream<List<TabDataModel>> getTabData(String tabName);
  Future<void> updateTabData(String tabName, TabDataModel data);
}

class TabRemoteDataSourceImpl implements TabRemoteDataSource {
  final FirebaseFirestore _firestore;

  TabRemoteDataSourceImpl(this._firestore);

  @override
  Stream<List<TabDataModel>> getTabData(String tabName) {
    try {
      return _firestore
          .collection(tabName)
          .orderBy('lastUpdated', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
          .map((doc) => TabDataModel.fromFirestore(doc))
          .toList());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> updateTabData(String tabName, TabDataModel data) async {
    try {
      await _firestore.collection(tabName).doc(data.id).set(
        data.toJson(),
        SetOptions(merge: true),
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}