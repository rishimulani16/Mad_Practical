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

1. **Role Selection UI**
   - Splash screen directing the user to select either "Instructor" or "Student" path.
   - Clean aesthetic with deep purple and teal accents, rendered beautifully via Stitch UI.

2. **Instructor Dashboard**
   - "Generate Session QR" creates a dynamic, time-bound glowing QR payload.
   - Displays the QR code directly on the screen atop a glassmorphism card.

3. **Student Dashboard**
   - "Scan Room QR" floating action button.
   - Offline tracking list with sync status indicators.
   - Deep dark mode elements with vibrant high-contrast accents.

4. **QR Scanner UI**
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
