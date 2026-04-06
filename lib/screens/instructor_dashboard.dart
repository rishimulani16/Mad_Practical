import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:smart_attendance/services/sync_service.dart';
import 'dart:convert';

class InstructorDashboard extends StatefulWidget {
  const InstructorDashboard({super.key});

  @override
  State<InstructorDashboard> createState() => _InstructorDashboardState();
}

class _InstructorDashboardState extends State<InstructorDashboard> {
  final SyncService _syncService = SyncService();
  String? qrData;
  List<Map<String, dynamic>> verifiedAttendees = [];

  @override
  void initState() {
    super.initState();
    _loadAttendees();
  }

  void _loadAttendees() async {
    final data = await _syncService.getRecords();
    setState(() {
      // For this simulated app on one device, we assume any record 
      // marked 'synced: true' arrived from the cloud successfully.
      verifiedAttendees = data.where((record) => record['synced'] == true).toList();
    });
  }

  void generateSessionQR() {
    // Generate a QR with timestamp + course code
    final payload = {
      'sessionId': 'CS101-${DateTime.now().millisecondsSinceEpoch}',
      'timestamp': DateTime.now().toIso8601String(),
      'course': 'Computer Science 101'
    };
    setState(() {
      qrData = jsonEncode(payload);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instructor Dashboard'),
        actions: [
           IconButton(
             icon: const Icon(Icons.refresh),
             onPressed: _loadAttendees,
             tooltip: 'Refresh Verified Attendees',
           )
        ],
      ),
      body: Row(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (qrData != null) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: QrImageView(
                        data: qrData!,
                        version: QrVersions.auto,
                        size: 250.0,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text('Students can scan this code to mark attendance.'),
                    const Text('Valid for the next 5 minutes.', style: TextStyle(color: Colors.grey)),
                  ] else ...[
                    const Icon(Icons.qr_code_scanner, size: 100, color: Colors.grey),
                    const SizedBox(height: 20),
                    const Text('No active session.', style: TextStyle(fontSize: 18)),
                  ],
                  const SizedBox(height: 40),
                  ElevatedButton.icon(
                    onPressed: generateSessionQR,
                    icon: const Icon(Icons.add),
                    label: const Text('Generate Session QR'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  )
                ],
              ),
            ),
          ),
          
          Expanded(
            child: Container(
              color: Colors.black12,
              child: Column(
                children: [
                   Container(
                     width: double.infinity,
                     padding: const EdgeInsets.all(16),
                     color: Colors.tealAccent.withOpacity(0.1),
                     child: Text(
                       'Verified Attendees (${verifiedAttendees.length})', 
                       style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.tealAccent),
                     ),
                   ),
                   Expanded(
                     child: verifiedAttendees.isEmpty
                       ? const Center(child: Text("No students have synced yet.", style: TextStyle(color: Colors.grey)))
                       : ListView.builder(
                           itemCount: verifiedAttendees.length,
                           itemBuilder: (context, index) {
                             final r = verifiedAttendees[index];
                             return ListTile(
                               leading: const Icon(Icons.person, color: Colors.deepPurpleAccent),
                               title: Text('Student ID: Simulated User'),
                               subtitle: Text('Recorded: ${r['sessionId']}'),
                               trailing: const Icon(Icons.verified, color: Colors.tealAccent),
                             );
                           }
                       )
                   )
                ]
              )
            )
          )
        ],
      ),
    );
  }
}
