import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/repositories/data_repository.dart';

// Events
abstract class DashboardEvent extends Equatable {
  const DashboardEvent();
  @override
  List<Object> get props => [];
}

class LoadDashboardData extends DashboardEvent {}

class ChangeDashboardView extends DashboardEvent {
  final String viewType; // 'Hybrid', 'MSEB', 'Generator'
  const ChangeDashboardView(this.viewType);
  @override
  List<Object> get props => [viewType];
}

// States
abstract class DashboardState extends Equatable {
  const DashboardState();
  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final List<PowerMetric> metrics;
  final List<OutageLog> outages;
  final String currentView; // 'Hybrid', 'MSEB', 'Generator'

  const DashboardLoaded({
    required this.metrics,
    required this.outages,
    required this.currentView,
  });

  @override
  List<Object?> get props => [metrics, outages, currentView];

  DashboardLoaded copyWith({
    List<PowerMetric>? metrics,
    List<OutageLog>? outages,
    String? currentView,
  }) {
    return DashboardLoaded(
      metrics: metrics ?? this.metrics,
      outages: outages ?? this.outages,
      currentView: currentView ?? this.currentView,
    );
  }
}

class DashboardError extends DashboardState {
  final String message;
  const DashboardError(this.message);
  @override
  List<Object> get props => [message];
}

// Bloc
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DataRepository dataRepository;

  DashboardBloc({required this.dataRepository}) : super(DashboardInitial()) {
    on<LoadDashboardData>(_onLoadDashboardData);
    on<ChangeDashboardView>(_onChangeDashboardView);
  }

  Future<void> _onLoadDashboardData(
    LoadDashboardData event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());
    final metricsResult = await dataRepository.getMetrics();
    final outagesResult = await dataRepository.getOutages();

    metricsResult.fold((failure) => emit(DashboardError(failure)), (metrics) {
      outagesResult.fold((failure) => emit(DashboardError(failure)), (outages) {
        emit(
          DashboardLoaded(
            metrics: metrics,
            outages: outages,
            currentView: 'Hybrid',
          ),
        );
      });
    });
  }

  void _onChangeDashboardView(
    ChangeDashboardView event,
    Emitter<DashboardState> emit,
  ) {
    if (state is DashboardLoaded) {
      final currentState = state as DashboardLoaded;
      emit(currentState.copyWith(currentView: event.viewType));
    }
  }
}
