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
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _teacherController = TextEditingController();

  String? qrData;
  List<Map<String, dynamic>> verifiedAttendees = [];

  @override
  void initState() {
    super.initState();
    _loadAttendees();
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _descController.dispose();
    _teacherController.dispose();
    super.dispose();
  }

  void _loadAttendees() async {
    final data = await _syncService.getRecords();
    setState(() {
      verifiedAttendees =
          data.where((record) => record['synced'] == true).toList();
    });
  }

  void _generateSessionQR() {
    if (!_formKey.currentState!.validate()) return;

    final payload = {
      'sessionId': '${_subjectController.text.trim()}-${DateTime.now().millisecondsSinceEpoch}',
      'subject': _subjectController.text.trim(),
      'description': _descController.text.trim(),
      'teacher': _teacherController.text.trim(),
      'timestamp': DateTime.now().toIso8601String(),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── LEFT PANEL: Form + QR ──────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Create Session',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.tealAccent),
                    ),
                    const SizedBox(height: 20),

                    // Subject Name
                    TextFormField(
                      controller: _subjectController,
                      decoration: InputDecoration(
                        labelText: 'Subject Name',
                        hintText: 'e.g. Computer Science 101',
                        prefixIcon: const Icon(Icons.book_outlined),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: Colors.white10,
                      ),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Please enter a subject name' : null,
                    ),
                    const SizedBox(height: 14),

                    // What was studied
                    TextFormField(
                      controller: _descController,
                      decoration: InputDecoration(
                        labelText: 'What was Studied',
                        hintText: 'e.g. Chapter 3 – Data Structures',
                        prefixIcon: const Icon(Icons.notes_outlined),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: Colors.white10,
                      ),
                      maxLines: 2,
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Please describe the topic studied' : null,
                    ),
                    const SizedBox(height: 14),

                    // Teacher Name
                    TextFormField(
                      controller: _teacherController,
                      decoration: InputDecoration(
                        labelText: 'Teacher Name',
                        hintText: 'e.g. Prof. Rishi Mulani',
                        prefixIcon: const Icon(Icons.person_outline),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: Colors.white10,
                      ),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Please enter the teacher name' : null,
                    ),
                    const SizedBox(height: 24),

                    ElevatedButton.icon(
                      onPressed: _generateSessionQR,
                      icon: const Icon(Icons.qr_code_2),
                      label: const Text('Generate Session QR'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Generated QR Code
                    if (qrData != null) ...[
                      const Divider(),
                      const SizedBox(height: 16),
                      Center(
                        child: Column(
                          children: [
                            const Text(
                              'Session QR Code',
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: QrImageView(
                                data: qrData!,
                                version: QrVersions.auto,
                                size: 220.0,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Show this QR code to students to mark attendance.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text(
                              'Valid for 5 minutes',
                              style: TextStyle(color: Colors.tealAccent.withOpacity(0.8)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),

          const VerticalDivider(width: 1),

          // ── RIGHT PANEL: Verified Attendees ────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: Colors.tealAccent.withOpacity(0.1),
                  child: Text(
                    'Verified Attendees (${verifiedAttendees.length})',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.tealAccent),
                  ),
                ),
                Expanded(
                  child: verifiedAttendees.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.people_outline, size: 60, color: Colors.grey),
                              SizedBox(height: 12),
                              Text(
                                'No students have synced yet.\nAsk them to scan & sync!',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: verifiedAttendees.length,
                          itemBuilder: (context, index) {
                            final r = verifiedAttendees[index];
                            return Card(
                              color: Colors.white10,
                              margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              child: ListTile(
                                leading: const CircleAvatar(
                                  backgroundColor: Colors.deepPurpleAccent,
                                  child: Icon(Icons.person, color: Colors.white),
                                ),
                                title: Text(r['sessionId'] ?? 'Unknown Session'),
                                subtitle: Text('Synced on: ${r['timestamp'] ?? ''}'),
                                trailing: const Icon(Icons.verified, color: Colors.tealAccent),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
