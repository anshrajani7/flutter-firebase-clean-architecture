import 'package:equatable/equatable.dart';

class TabDataEntity extends Equatable {
  final String id;
  final String title;
  final String content;
  final DateTime lastUpdated;
  final Map<String, dynamic> additionalData;

  const TabDataEntity({
    required this.id,
    required this.title,
    required this.content,
    required this.lastUpdated,
    this.additionalData = const {},
  });

  @override
  List<Object> get props => [id, title, content, lastUpdated, additionalData];
}