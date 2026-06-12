import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ClickLogger {
  /// Logs a user click event to a local text file.
  /// 
  /// The log file is saved in the application's document directory
  /// under the name 'user_clicks.txt'.
  static Future<void> logClick({
    required String buttonName,
    required String screenName,
  }) async {
    try {
      // Get the application documents directory where the file will be saved
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/user_clicks.txt');
      
      // Get the current time
      final timestamp = DateTime.now().toIso8601String();
      
      // Create the log entry
      final logEntry = 'Time: $timestamp | Screen: $screenName | Button: $buttonName\n';
      
      // Write the log entry to the file, appending it to the end
      await file.writeAsString(logEntry, mode: FileMode.append);
      
      // Optional: Print to console for debugging
      print('Click logged successfully: $logEntry');
    } catch (e) {
      print('Error logging click: $e');
    }
  }
}
