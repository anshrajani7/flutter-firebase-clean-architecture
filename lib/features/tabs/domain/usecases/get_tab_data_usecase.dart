
import '../../../../core/usecase/usecase.dart';
import '../entities/tab_data_entity.dart';
import '../repositories/tab_repository.dart';


class GetTabDataUseCase extends StreamUseCase<List<TabDataEntity>, String> {
  final TabRepository repository;

  GetTabDataUseCase(this.repository);

  @override
  Stream<List<TabDataEntity>> call(String tabName) {
    return repository.getTabData(tabName);
  }
}