part of 'tab_bloc.dart';

abstract class TabEvent extends Equatable {
  const TabEvent();

  @override
  List<Object?> get props => [];
}

class LoadTabData extends TabEvent {
  final String tabName;

  const LoadTabData(this.tabName);

  @override
  List<Object> get props => [tabName];
}

class RefreshTabData extends TabEvent {
  final String tabName;

  const RefreshTabData(this.tabName);

  @override
  List<Object> get props => [tabName];
}