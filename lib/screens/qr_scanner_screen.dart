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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan QR Code')),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: MobileScanner(
              controller: controller,
              onDetect: (capture) {
                if (!isScanning) return;
                final List<Barcode> barcodes = capture.barcodes;
                for (final barcode in barcodes) {
                  final rawValue = barcode.rawValue;
                  if (rawValue != null) {
                    setState(() => isScanning = false);
                    try {
                      final data = jsonDecode(rawValue);
                      Navigator.pop(context, data['course'] ?? data['sessionId']);
                    } catch (e) {
                      Navigator.pop(context, 'Unknown Session');
                    }
                    break;
                  }
                }
              },
            ),
          ),
          const Expanded(
            flex: 1,
            child: Center(
              child: Text('Align QR Code within the frame'),
            ),
          )
        ],
      ),
    );
  }
}
