import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:convert';

class InstructorDashboard extends StatefulWidget {
  const InstructorDashboard({super.key});

  @override
  State<InstructorDashboard> createState() => _InstructorDashboardState();
}

class _InstructorDashboardState extends State<InstructorDashboard> {
  String? qrData;

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
      appBar: AppBar(title: const Text('Instructor Dashboard')),
      body: Center(
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
    );
  }
}
