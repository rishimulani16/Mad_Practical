import 'package:flutter/material.dart';
import 'qr_scanner_screen.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  List<String> attendances = [];

  void _openScanner() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const QRScannerScreen()),
    );
    if (result != null) {
      setState(() {
        attendances.add(result.toString());
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Attendance Marked Successfully!'), backgroundColor: Colors.teal),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Dashboard')),
      body: Column(
        children: [
          Expanded(
            child: attendances.isEmpty
                ? const Center(child: Text('No recent attendance records.'))
                : ListView.builder(
                    itemCount: attendances.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const Icon(Icons.check_circle, color: Colors.tealAccent),
                        title: Text('Session: ${attendances[index]}'),
                        subtitle: const Text('Recorded just now'),
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
        label: const Text('Scan QR', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
