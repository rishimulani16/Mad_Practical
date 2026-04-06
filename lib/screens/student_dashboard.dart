import 'package:flutter/material.dart';
import 'package:smart_attendance/services/location_service.dart';
import 'package:smart_attendance/services/sync_service.dart';
import 'qr_scanner_screen.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  final LocationService _locationService = LocationService();
  final SyncService _syncService = SyncService();
  List<Map<String, dynamic>> attendances = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final data = await _syncService.getRecords();
    setState(() {
      attendances = data;
    });
  }

  void _syncData() async {
    bool synced = await _syncService.syncPendingRecords();
    if (synced) {
      _loadData();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Attendance Synced Successfully!'), backgroundColor: Colors.teal),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No pending records to sync.'), backgroundColor: Colors.blueAccent),
      );
    }
  }

  void _openScanner() async {
    bool isWithinBounds = await _locationService.isWithinClassroom();
    if (!isWithinBounds) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: You are not at the class location.'), backgroundColor: Colors.redAccent),
      );
      return;
    }

    if (!mounted) return;
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const QRScannerScreen()),
    );
    
    if (result != null) {
      await _syncService.saveAttendanceLocally(result.toString());
      _loadData();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Attendance Recorded Locally.'), backgroundColor: Colors.teal),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: _syncData,
            tooltip: 'Sync Offline Records',
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: attendances.isEmpty
                ? const Center(child: Text('No attendance records.'))
                : ListView.builder(
                    itemCount: attendances.length,
                    itemBuilder: (context, index) {
                      final record = attendances[index];
                      final isSynced = record['synced'] == true;
                      return ListTile(
                        leading: Icon(
                          isSynced ? Icons.cloud_done : Icons.cloud_off, 
                          color: isSynced ? Colors.tealAccent : Colors.orangeAccent
                        ),
                        title: Text('Session: ${record['sessionId']}'),
                        subtitle: Text('Status: ${isSynced ? 'Synced' : 'Offline Pending'}'),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openScanner,
        backgroundColor: Colors.tealAccent,
        icon: const Icon(Icons.camera_alt, color: Colors.black),
        label: const Text('Mark Attendance', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

