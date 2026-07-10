import 'dart:math' as math;

class DummyEvent {
  final DateTime mainsFailureTime;
  final DateTime dgStartTime;
  final DateTime powerRestoreTime;
  final DateTime dgStopTime;
  final int durationMinutes;

  DummyEvent({
    required this.mainsFailureTime,
    required this.dgStartTime,
    required this.powerRestoreTime,
    required this.dgStopTime,
    required this.durationMinutes,
  });
}

// ==========================================
// [DUMMY DATA GENERATOR] - DEMO UTILITY
// Contains helper models and generation algorithms used to produce 
// realistic simulated outage events and telemetry values for local/demo testing.
// ==========================================
class DummyDataGenerator {
  static final int targetGeneratorMinutesPerDay = 288; // ~20% of 24 hours

  static List<DummyEvent> generateEventsForDay(DateTime day) {
    // Use a deterministic seed based on the date so it always generates the same events for the same day
    final int seed = day.year * 10000 + day.month * 100 + day.day;
    final random = math.Random(seed);
    
    List<DummyEvent> events = [];
    int outageCount = random.nextInt(3) + 2; 
    
    List<int> outageDurations = List.filled(outageCount, 0);
    int remaining = targetGeneratorMinutesPerDay;
    
    for (int k = 0; k < outageCount - 1; k++) {
      int maxMins = remaining - (15 * (outageCount - 1 - k));
      int mins = 15 + random.nextInt((maxMins - 15).clamp(1, targetGeneratorMinutesPerDay));
      outageDurations[k] = mins;
      remaining -= mins;
    }
    outageDurations[outageCount - 1] = remaining;

    int segmentLength = (24 * 60) ~/ outageCount;

    for (int j = 0; j < outageCount; j++) {
      int maxRandom = segmentLength - outageDurations[j] - 10;
      if (maxRandom <= 0) maxRandom = 1;
      int startMinuteOffset = (j * segmentLength) + random.nextInt(maxRandom);
      
      DateTime dayStart = DateTime(day.year, day.month, day.day);
      DateTime mainsFailureTime = dayStart.add(Duration(minutes: startMinuteOffset));
      DateTime dgStartTime = mainsFailureTime.add(const Duration(minutes: 2));
      DateTime powerRestoreTime = mainsFailureTime.add(Duration(minutes: outageDurations[j]));
      DateTime dgStopTime = powerRestoreTime.add(const Duration(minutes: 2));

      events.add(DummyEvent(
        mainsFailureTime: mainsFailureTime,
        dgStartTime: dgStartTime,
        powerRestoreTime: powerRestoreTime,
        dgStopTime: dgStopTime,
        durationMinutes: outageDurations[j],
      ));
    }

    return events;
  }
}
