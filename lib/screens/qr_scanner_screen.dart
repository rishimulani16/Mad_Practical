import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'dart:convert';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final MobileScannerController controller = MobileScannerController();
  bool isScanning = true;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (!isScanning) return;
    for (final barcode in capture.barcodes) {
      final rawValue = barcode.rawValue;
      if (rawValue != null) {
        setState(() => isScanning = false);
        try {
          final data = jsonDecode(rawValue) as Map<String, dynamic>;
          // Show a bottom sheet with session details before confirming attendance
          _showSessionDetails(data);
        } catch (e) {
          Navigator.pop(context, 'Unknown Session');
        }
        break;
      }
    }
  }

  void _showSessionDetails(Map<String, dynamic> data) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                children: const [
                  Icon(Icons.check_circle, color: Colors.tealAccent, size: 28),
                  SizedBox(width: 10),
                  Text(
                    'Session Scanned!',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.tealAccent),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(color: Colors.white24),
              const SizedBox(height: 12),

              // Subject
              _infoRow(Icons.book_outlined, 'Subject', data['subject'] ?? data['course'] ?? '—'),
              const SizedBox(height: 12),

              // What was studied
              _infoRow(Icons.notes_outlined, 'Topic Covered', data['description'] ?? '—'),
              const SizedBox(height: 12),

              // Teacher name
              _infoRow(Icons.person_outline, 'Teacher', data['teacher'] ?? '—'),
              const SizedBox(height: 24),

              // Confirm Button
              ElevatedButton.icon(
                icon: const Icon(Icons.how_to_reg),
                label: const Text('Confirm Attendance'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.tealAccent,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.pop(context); // close bottom sheet
                  // Pass back the sessionId to student dashboard
                  Navigator.pop(
                    context,
                    data['subject'] ?? data['sessionId'] ?? 'Unknown Session',
                  );
                },
              ),
              const SizedBox(height: 10),

              // Cancel Button
              TextButton(
                child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                onPressed: () {
                  setState(() => isScanning = true);
                  Navigator.pop(context); // close bottom sheet, resume scanning
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.deepPurpleAccent, size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Attendance QR')),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: Stack(
              children: [
                MobileScanner(
                  controller: controller,
                  onDetect: _onDetect,
                ),
                // Overlay frame
                Center(
                  child: Container(
                    width: 230,
                    height: 230,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.tealAccent, width: 3),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.qr_code_scanner, color: Colors.grey),
                  SizedBox(height: 6),
                  Text(
                    'Align the QR code within the frame',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
