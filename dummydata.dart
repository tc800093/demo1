import 'package:poweriot/features/user/analytics/domain/entity/analytics_model.dart';

final analyticsDummy = AnalyticsModel(
  applicationType: "MG",

  mainsAnalytics: MainsAnalytics(
    powerFailureDurationMinutes: 95,
    lastPowerFailureTime: DateTime.now().subtract(const Duration(hours: 3)),
    lastPowerRestoreTime: DateTime.now().subtract(
      const Duration(hours: 1, minutes: 20),
    ),
    outageCountPerDay: 4,
    phaseFailureCount: 2,
    downtimeDurationMinutes: 95,
    averageVoltage: 231.8,
    averageFrequency: 49.9,
  ),

  generatorAnalytics: GeneratorAnalytics(
    generatorStartCount: 8,
    generatorStopCount: 8,
    generatorOnDuration: "07:45:00",
    dailyFuelConsumption: 18.7,
    monthlyFuelConsumption: 412.4,
    generatorHealthStatus: "Healthy",
    batteryVoltage: 12.8,
    dgFaultStatus: false,
    overloadStatus: false,
    fuelTheftDetected: false,
    fuelLevel: 63.5,
    maintenanceServiceStatus: "Next Service in 38 Hours",
  ),

  alarmHistory: [
    AlarmHistory(
      // alarmName: AlarmName.lowFuel,
      // alarmMessage: AlarmMessage.fuelLevelLow,
      // severity: Severity.high,
      // alarmTime: DateTime.now().subtract(const Duration(hours: 2, minutes: 10)),
    ),

    AlarmHistory(
      // alarmName: AlarmName.overLoad,
      // alarmMessage: AlarmMessage.generatorOverload,
      // severity: Severity.high,
      // alarmTime: DateTime.now().subtract(const Duration(days: 1, hours: 5)),
    ),

    AlarmHistory(
      // alarmName: AlarmName.dgFault,
      // alarmMessage: AlarmMessage.generatorFaultDetected,
      // severity: Severity.critical,
      // alarmTime: DateTime.now().subtract(const Duration(days: 3, hours: 4)),
    ),
  ],

  eventHistory: [
    // ================= Today =================
    EventHistory(
      eventType: "PHASE_FAILURE",
      eventMessage: "Main power failure detected.",
      eventTime: DateTime.now().subtract(const Duration(hours: 6)),
    ),
    EventHistory(
      eventType: "DG_STARTED",
      eventMessage: "Generator started automatically due to mains failure.",
      eventTime: DateTime.now().subtract(const Duration(hours: 5, minutes: 58)),
    ),
    EventHistory(
      eventType: "POWER_RESTORE",
      eventMessage: "Main power supply has been restored.",
      eventTime: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    EventHistory(
      eventType: "DG_STOPPED",
      eventMessage: "Generator stopped after mains power restoration.",
      eventTime: DateTime.now().subtract(const Duration(hours: 1, minutes: 58)),
    ),

    // ================= Yesterday =================
    EventHistory(
      eventType: "PHASE_FAILURE",
      eventMessage: "Power outage detected.",
      eventTime: DateTime.now().subtract(const Duration(days: 1, hours: 8)),
    ),
    EventHistory(
      eventType: "DG_STARTED",
      eventMessage: "Generator started automatically.",
      eventTime: DateTime.now().subtract(
        const Duration(days: 1, hours: 7, minutes: 58),
      ),
    ),
    EventHistory(
      eventType: "POWER_RESTORE",
      eventMessage: "Utility power restored.",
      eventTime: DateTime.now().subtract(const Duration(days: 1, hours: 5)),
    ),
    EventHistory(
      eventType: "DG_STOPPED",
      eventMessage: "Generator stopped successfully.",
      eventTime: DateTime.now().subtract(
        const Duration(days: 1, hours: 4, minutes: 58),
      ),
    ),

    // ================= 2 Days Ago =================
    EventHistory(
      eventType: "PHASE_FAILURE",
      eventMessage: "Incoming mains supply failed.",
      eventTime: DateTime.now().subtract(const Duration(days: 2, hours: 9)),
    ),
    EventHistory(
      eventType: "DG_STARTED",
      eventMessage: "Backup generator started.",
      eventTime: DateTime.now().subtract(
        const Duration(days: 2, hours: 8, minutes: 59),
      ),
    ),
    EventHistory(
      eventType: "POWER_RESTORE",
      eventMessage: "Power supply restored.",
      eventTime: DateTime.now().subtract(const Duration(days: 2, hours: 6)),
    ),
    EventHistory(
      eventType: "DG_STOPPED",
      eventMessage: "Generator switched off.",
      eventTime: DateTime.now().subtract(
        const Duration(days: 2, hours: 5, minutes: 58),
      ),
    ),

    // ================= 3 Days Ago =================
    EventHistory(
      eventType: "PHASE_FAILURE",
      eventMessage: "Main supply interruption detected.",
      eventTime: DateTime.now().subtract(const Duration(days: 3, hours: 7)),
    ),
    EventHistory(
      eventType: "DG_STARTED",
      eventMessage: "Generator started to provide backup power.",
      eventTime: DateTime.now().subtract(
        const Duration(days: 3, hours: 6, minutes: 58),
      ),
    ),
    EventHistory(
      eventType: "POWER_RESTORE",
      eventMessage: "Normal power supply resumed.",
      eventTime: DateTime.now().subtract(const Duration(days: 3, hours: 3)),
    ),
    EventHistory(
      eventType: "DG_STOPPED",
      eventMessage: "Generator stopped after utility restoration.",
      eventTime: DateTime.now().subtract(
        const Duration(days: 3, hours: 2, minutes: 58),
      ),
    ),

    // ================= 4 Days Ago =================
    EventHistory(
      eventType: "PHASE_FAILURE",
      eventMessage: "Power outage detected on mains supply.",
      eventTime: DateTime.now().subtract(const Duration(days: 4, hours: 10)),
    ),
    EventHistory(
      eventType: "DG_STARTED",
      eventMessage: "Generator started automatically.",
      eventTime: DateTime.now().subtract(
        const Duration(days: 4, hours: 9, minutes: 58),
      ),
    ),
    EventHistory(
      eventType: "POWER_RESTORE",
      eventMessage: "Mains power restored successfully.",
      eventTime: DateTime.now().subtract(const Duration(days: 4, hours: 6)),
    ),
    EventHistory(
      eventType: "DG_STOPPED",
      eventMessage: "Generator stopped after power restoration.",
      eventTime: DateTime.now().subtract(
        const Duration(days: 4, hours: 5, minutes: 58),
      ),
    ),
  ],
);
