import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/tab_data_entity.dart';
import '../../domain/usecases/get_tab_data_usecase.dart';

part 'tab_event.dart';
part 'tab_state.dart';

class TabBloc extends Bloc<TabEvent, TabState> {
  final GetTabDataUseCase getTabData;

  TabBloc({required this.getTabData}) : super(TabInitial()) {
    on<LoadTabData>(_onLoadTabData);
    on<RefreshTabData>(_onRefreshTabData);
  }

  void _onLoadTabData(LoadTabData event, Emitter<TabState> emit) async {
    emit(TabLoading());

    await emit.forEach(
      getTabData(event.tabName),
      onData: (List<TabDataEntity> data) => TabLoaded(data),
      onError: (error, stackTrace) => TabError(error.toString()),
    );
  }

  void _onRefreshTabData(RefreshTabData event, Emitter<TabState> emit) async {
    final currentState = state;
    if (currentState is TabLoaded) {
      emit(TabRefreshing(currentState.data));
    } else {
      emit(TabLoading());
    }

    await emit.forEach(
      getTabData(event.tabName),
      onData: (List<TabDataEntity> data) => TabLoaded(data),
      onError: (error, stackTrace) => TabError(error.toString()),
    );
  }
}