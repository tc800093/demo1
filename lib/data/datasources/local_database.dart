import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDatabase {
  static final LocalDatabase instance = LocalDatabase._init();
  static Database? _database;

  LocalDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('poweriot.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const realType = 'REAL NOT NULL';
    const intType = 'INTEGER NOT NULL';

    await db.execute('''
CREATE TABLE metrics (
  id $idType,
  timestamp $textType,
  source $textType,
  voltageR $realType,
  voltageY $realType,
  voltageB $realType,
  fuelLevel $realType,
  oilPressure $realType,
  engineTemp $realType,
  batteryStatus $realType,
  isRunning $intType
)
''');

    await db.execute('''
CREATE TABLE outages (
  id $idType,
  startTime $textType,
  endTime $textType,
  durationMinutes $intType
)
''');

    await db.execute('''
CREATE TABLE fuel_logs (
  id $idType,
  date $textType,
  quantity $realType,
  cost $realType
)
''');

    // Insert Dummy Data
    await _insertDummyData(db);
  }

  Future<void> _insertDummyData(Database db) async {
    final now = DateTime.now();

    // Insert Metrics
    for (int i = 0; i < 24; i++) {
      final time = now.subtract(Duration(hours: i));
      final source = i % 5 == 0
          ? 'Generator'
          : 'MSEB'; // Every 5th hour is Generator

      await db.insert('metrics', {
        'timestamp': time.toIso8601String(),
        'source': source,
        'voltageR': source == 'MSEB' ? 230.0 + (i % 5) : 0.0,
        'voltageY': source == 'MSEB' ? 228.0 + (i % 3) : 0.0,
        'voltageB': source == 'MSEB' ? 231.0 - (i % 4) : 0.0,
        'fuelLevel': source == 'Generator' ? 80.0 - i : 0.0,
        'oilPressure': source == 'Generator' ? 45.0 : 0.0,
        'engineTemp': source == 'Generator' ? 85.0 : 0.0,
        'batteryStatus': source == 'Generator' ? 12.4 : 0.0,
        'isRunning': source == 'Generator' ? 1 : 0,
      });
    }

    // Insert Outages
    await db.insert('outages', {
      'startTime': now
          .subtract(const Duration(days: 1, hours: 2))
          .toIso8601String(),
      'endTime': now.subtract(const Duration(days: 1)).toIso8601String(),
      'durationMinutes': 120,
    });

    // Insert Fuel Logs
    await db.insert('fuel_logs', {
      'date': now.subtract(const Duration(days: 2)).toIso8601String(),
      'quantity': 50.0,
      'cost': 4500.0,
    });
  }

  Future<List<Map<String, dynamic>>> getMetrics() async {
    final db = await instance.database;
    return await db.query('metrics', orderBy: 'timestamp DESC');
  }

  Future<List<Map<String, dynamic>>> getOutages() async {
    final db = await instance.database;
    return await db.query('outages', orderBy: 'startTime DESC');
  }

  Future<List<Map<String, dynamic>>> getFuelLogs() async {
    final db = await instance.database;
    return await db.query('fuel_logs', orderBy: 'date DESC');
  }
}
