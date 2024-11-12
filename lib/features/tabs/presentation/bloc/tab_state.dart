part of 'tab_bloc.dart';

abstract class TabState extends Equatable {
  const TabState();

  @override
  List<Object?> get props => [];
}

class TabInitial extends TabState {}

class TabLoading extends TabState {}

class TabRefreshing extends TabState {
  final List<TabDataEntity> oldData;

  const TabRefreshing(this.oldData);

  @override
  List<Object> get props => [oldData];
}

class TabLoaded extends TabState {
  final List<TabDataEntity> data;

  const TabLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class TabError extends TabState {
  final String message;

  const TabError(this.message);

  @override
  List<Object> get props => [message];
}