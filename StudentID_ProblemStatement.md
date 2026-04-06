# EduTrack Systems - Smart Attendance Management App

## Problem Statement
At EduTrack Systems, attendance tracking is performed manually, leading to proxy attendance, data inconsistencies, and delayed reporting. To modernize this process, we require a Flutter-based Smart Attendance Management App that leverages QR codes to record attendance accurately.

## Key Pain Points Solved
- Proxy attendance and fraudulent marking (Solved via GPS bounds & Session Timeouts).
- Manual errors in attendance records (Automated).
- Delayed report generation (Real-time sync).
- Lack of real-time monitoring (Offline-first Dashboard).

---

## UI Screens (References)

1. **Role Selection UI (main.dart)**
   - Allows users to select either "Instructor" or "Student" path.
   - Clean aesthetic with deep purple and teal accents for a modern look.

2. **Instructor Dashboard (instructor_dashboard.dart)**
   - "Generate Session QR" button creates a dynamic, time-bound QR payload.
   - Displays the QR code directly on the screen for students to scan.

3. **Student Dashboard (student_dashboard.dart)**
   - "Mark Attendance" Floating Action Button.
   - Checks GPS bounds before opening the camera.
   - Offline tracking list with sync status indicators.

4. **QR Scanner UI (qr_scanner_screen.dart)**
   - Real-time mobile scanner parsing JSON payloads.
---

## Future Scope
- **Biometric Integration**: Use `local_auth` to require fingerprint or face-ID before scanning the QR code, adding a secondary layer against proxy attendance.
- **Dynamic Salt**: Implement TOTP (Time-Based One-Time Password) encryption on the QR code so the payload changes every 30 seconds to prevent photo-sharing among students.
- **Push Notifications**: Inform students when an attendance window opens via FCM (Firebase Cloud Messaging).
- **Admin Web Panel**: A React/Next.js dashboard for administrators to view complex analytics and export historical data to Excel.

## Conclusion
The Smart Attendance Management App successfully mitigates the primary challenges of manual attendance tracking. By integrating a dynamic QR payload approach with GPS bounding, the risk of fraudulent attendance marking is heavily reduced. Furthermore, the local offline storage architecture ensures that students can reliably log their attendance even in areas with poor network coverage, later syncing to the centralized database once connectivity is restored.

*(Note: Please export this document to PDF using your markdown viewer or browser print-to-pdf to submit as `StudentID_ProblemStatement.pdf`)*
