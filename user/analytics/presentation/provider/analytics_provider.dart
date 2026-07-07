import 'package:flutter/material.dart';
import 'package:poweriot/core/constants/app_constant.dart';
import 'package:poweriot/core/logger/app_logger.dart';
import 'package:poweriot/features/user/analytics/domain/entity/analytics_model.dart';
import 'package:poweriot/features/user/analytics/domain/usecase/fetch_analytics_usecase.dart';

/// Manages analytics data state for the user analytics screen.
///
/// Fetches power event data from the server and computes metrics like
/// generator usage percentage, main power usage, and runtime segments.
class AnalyticsProvider extends ChangeNotifier {
  final FetchAnalyticsUsecase analyticsUsecase;
  AnalyticsProvider({required this.analyticsUsecase});

  /// Status of the fetch-analytics operation.
  Status _analyticsStatus = .init;
  Status get analyticsStatus => _analyticsStatus;

  /// Latest status message (success or error).
  String _message = '';
  String get message => _message;

  /// The full analytics data model returned from the API.
  AnalyticsModel? _analyticsModel;
  AnalyticsModel get analyticsModel => _analyticsModel!;

  /// Generator usage percentage (0.0 to 1.0 scale).
  double _generateUseage = 0.0;
  double get generatorUsage => _generateUseage;

  /// Runtime segments for power outage events.
  List<RuntimeSegment> _outTimge = [];
  List<RuntimeSegment> get outTimge => _outTimge;

  /// Runtime segments for generator on/off events.
  List<RuntimeSegment> _generatorTimge = [];
  List<RuntimeSegment> get generatorTimge => _generatorTimge;

  /// Main power usage percentage (0.0 to 1.0 scale).
  double _mainPowerUsage = 0.0;
  double get mainsPowerUsage => _mainPowerUsage;

  /// List of power outage/restore events from the event history.
  List<EventHistory> _powerOutage = [];
  List<EventHistory> get powerOutage => _powerOutage;

  /// List of generator start/stop events from the event history.
  List<EventHistory> _generatorCount = [];
  List<EventHistory> get generatorCount => _generatorCount;

  /// Fetches analytics data for the given date range and processes event history.
  ///
  /// [params] must contain `fromDate` and `toDate` in ISO 8601 string format.
  /// Computes generator and main power usage percentages from event segments.
  ///
  ///

  void setAnalyticsData(AnalyticsModel model) {
    _analyticsModel = model;
    notifyListeners();
  }

  Future<void> fetchAnalyticsMethod({
    required FetchAnalyticsParams params,
  }) async {
    _analyticsStatus = .loading;
    _message = '';
    notifyListeners();

    try {
      final result = await analyticsUsecase.call(params);

      await result.fold(
        (error) {
          _analyticsStatus = .failed;
          _message = error.message;
        },
        (success) async {
          _analyticsStatus = .success;
          _message = 'Data found';
          AnalyticsModel model = success;

          _analyticsModel = model;
          setAnalyticsData(model);

          if (model.generatorAnalytics != null) {
            if (model.generatorAnalytics!.generatorStartCount == 0 &&
                model.mainsAnalytics?.outageCountPerDay == 0) {
              _generateUseage = 0.0;
              _mainPowerUsage = 1.0;
            } else {}
          } else {
            _mainPowerUsage = 1.0;
          }

          _powerOutage = model.eventHistory!
              .where(
                (event) =>
                    event.eventType.toString().toUpperCase() ==
                        'PHASE_FAILURE' ||
                    event.eventType.toString().toUpperCase() == 'POWER_RESTORE',
              )
              .toList();

          _generatorCount = model.eventHistory!
              .where(
                (event) =>
                    event.eventType.toString().toUpperCase() == 'DG_STARTED' ||
                    event.eventType.toString().toUpperCase() == 'DG_STOPPED',
              )
              .toList();

          _outTimge = buildSegments(
            _powerOutage,
            end: 'PHASE_FAILURE',
            start: 'POWER_RESTORE',
          );

          _generatorTimge = buildSegments(
            _generatorCount,
            end: 'DG_STOPPED',
            start: 'DG_STARTED',
          );
          double generatior = calculatePercentage(
            segments: _generatorTimge,
            fromDate: DateTime.parse(params.fromDate),
            toDate: DateTime.parse(params.toDate),
          );

          double mainpower = calculatePercentage(
            segments: _outTimge,
            fromDate: DateTime.parse(params.fromDate),
            toDate: DateTime.parse(params.toDate),
          );

          if (mainpower == 0.0 && generatior == 0.0) {
            _mainPowerUsage = 1.0;
            _generateUseage = 0.0;
          } else {
            _mainPowerUsage = (mainpower / 100).clamp(0.0, 1.0);
            _generateUseage = (generatior / 100).clamp(0.0, 1.0);
          }
        },
      );
      notifyListeners();
    } catch (e, trace) {
      AppLogger().error("error in provider $e\n trace $trace");
      _analyticsStatus = .failed;
      _message = 'Something went wrong';
      notifyListeners();
    }
  }

  /// Calculates what percentage of the total period a set of runtime segments covers.
  ///
  /// [segments] is a list of time ranges, [fromDate] and [toDate] define the analysis window.
  /// For a same-day range, the total period is assumed to be 24 hours.
  /// Returns a value clamped between 0.0 and 100.0.
  double calculatePercentage({
    required List<RuntimeSegment> segments,
    required DateTime fromDate,
    required DateTime toDate,
  }) {
    Duration totalRuntime = Duration.zero;

    for (final segment in segments) {
      totalRuntime += segment.duration;
    }

    final bool isSameDay =
        fromDate.year == toDate.year &&
        fromDate.month == toDate.month &&
        fromDate.day == toDate.day;

    final totalPeriodHours = isSameDay
        ? 24.0
        : ((toDate.difference(fromDate).inDays + 1) * 24.0);

    final runtimeHours = totalRuntime.inMinutes / 60.0;

    return ((runtimeHours / totalPeriodHours) * 100).clamp(0.0, 100.0);
  }

  /// Builds consecutive runtime segments from a list of paired events.
  ///
  /// Scans [events] for adjacent pairs matching ([start], [end]) event types
  /// and creates [RuntimeSegment] instances representing each active period.
  List<RuntimeSegment> buildSegments(
    List<EventHistory> events, {
    required String start,
    required String end,
  }) {
    final segments = <RuntimeSegment>[];

    for (int i = 0; i < events.length; i++) {
      if (events[i].eventType.toString().toUpperCase() == start) {
        final startTime = events[i].eventTime!;

        DateTime? endTime;

        for (int j = i + 1; j < events.length; j++) {
          if (events[j].eventType.toString().toUpperCase() == end) {
            endTime = events[j].eventTime!;
            break;
          }
        }

        endTime ??= DateTime.now();

        segments.add(
          RuntimeSegment(
            start: startTime,
            end: endTime,
            duration: endTime.difference(startTime),
          ),
        );
      }
    }

    return segments;
  }

  /// Calculates the ratio of [totalRuntimeHours] (in minutes) to the total
  /// available minutes in the date range.
  ///
  /// Returns a value clamped between 0.0 and 1.0.
  double calculateRuntimePercentage({
    required double totalRuntimeHours,
    required DateTime fromDate,
    required DateTime toDate,
  }) {
    final days = toDate.difference(fromDate).inDays + 1;
    final totalAvailableMinutes = days * 24 * 60;

    final ratio = totalRuntimeHours / totalAvailableMinutes;

    return ratio.clamp(0.0, 1.0);
    // return (totalRuntimeHours / totalAvailableHours) * 100;
  }
}

/// Represents a single time segment during which a system (generator or mains) was active.
class RuntimeSegment {
  /// Start time of the active period.
  final DateTime start;

  final DateTime end;

  final Duration duration;

  RuntimeSegment({
    required this.start,
    required this.end,
    required this.duration,
  });
}
