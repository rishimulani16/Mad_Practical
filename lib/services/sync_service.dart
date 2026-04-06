import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SyncService {
  static const String _key = 'offline_attendance';

  Future<void> saveAttendanceLocally(String sessionId) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> records = prefs.getStringList(_key) ?? [];
    
    final record = {
      'sessionId': sessionId,
      'timestamp': DateTime.now().toIso8601String(),
      'synced': false,
    };
    
    records.add(jsonEncode(record));
    await prefs.setStringList(_key, records);
  }

  Future<List<Map<String, dynamic>>> getRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> records = prefs.getStringList(_key) ?? [];
    return records.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();
  }

  Future<bool> syncPendingRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> records = prefs.getStringList(_key) ?? [];
    bool hasPending = false;
    
    List<String> updated = [];
    for (String r in records) {
      var map = jsonDecode(r) as Map<String, dynamic>;
      if (map['synced'] == false) {
        hasPending = true;
        // Simulate network delay
        await Future.delayed(const Duration(milliseconds: 500));
        map['synced'] = true;
      }
      updated.add(jsonEncode(map));
    }
    
    if (hasPending) {
      await prefs.setStringList(_key, updated);
      return true;
    }
    return false;
  }
}
