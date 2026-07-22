import 'package:poweriot/features/user/dashboard/domain/model/dashboar_model.dart';
import 'package:poweriot/features/user/dashboard/domain/repository/dashboard_repository.dart';

class ConnectDashboardWebSocketUseCase {
  final DashboardRepository repository;

  ConnectDashboardWebSocketUseCase({required this.repository});

  Stream<DashboardModel> call() {
    return repository.dashboardStream();
  }
}
