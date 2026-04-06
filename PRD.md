# EduTrack Systems - Smart Attendance Management App

## Purpose
A modern, Flutter-based attendance tracking system to solve issues of proxy attendance, data inconsistencies, delayed reporting, and manual errors. Allows instructors to generate session-based QR codes and students to scan them within a time window with GPS validation.

## Key Pain Points Addressed
- Proxy attendance and fraudulent marking.
- Manual errors in attendance records.
- Delayed report generation for academic audits.
- Lack of real-time monitoring.

## Core Features
1. **Interactive UI & Two Roles**: Instructor and Student dashboards.
2. **QR Code Integration**: 
   - Instructors generate dynamic, time-limited QR codes linking to specific sessions.
   - Students scan these codes to mark attendance.
3. **GPS Validation**: Student location is checked during QR scan to ensure they are physically present in the classroom.
4. **Offline Mode**: Local capture of attendance data with sqlite/shared_preferences and backend sync when network is restored.
5. **Dashboard & Analytics**: Displays real-time monitoring of attendance, and provides a way to generate reports for academic audits.

## GitHub Workflow Constraints
- Minimum 4 commits (Initialization → QR Integration → Backend Sync → UI & Reports).

## Deliverables
1. Flutter source code in the repository.
2. Final PDF document: `[StudentID]_ProblemStatement.pdf` containing UI screens, future scope, and conclusion.
