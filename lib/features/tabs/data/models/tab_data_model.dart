import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/tab_data_entity.dart';

class TabDataModel extends TabDataEntity {
  const TabDataModel({
    required String id,
    required String title,
    required String content,
    required DateTime lastUpdated,
    Map<String, dynamic> additionalData = const {},
  }) : super(
    id: id,
    title: title,
    content: content,
    lastUpdated: lastUpdated,
    additionalData: additionalData,
  );

  factory TabDataModel.fromEntity(TabDataEntity entity) {
    return TabDataModel(
      id: entity.id,
      title: entity.title,
      content: entity.content,
      lastUpdated: entity.lastUpdated,
      additionalData: entity.additionalData,
    );
  }

  factory TabDataModel.fromJson(Map<String, dynamic> json) {
    return TabDataModel(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      lastUpdated: DateTime.parse(json['lastUpdated']),
      additionalData: Map<String, dynamic>.from(json['additionalData'] ?? {}),
    );
  }

  factory TabDataModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TabDataModel.fromJson({
      'id': doc.id,
      ...data,
    });
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'lastUpdated': lastUpdated.toIso8601String(),
      'additionalData': additionalData,
    };
  }
}