import 'package:flutter/material.dart';
import 'instructor_dashboard.dart';
import 'student_dashboard.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.school, size: 80, color: Colors.tealAccent),
              const SizedBox(height: 20),
              const Text(
                'EduTrack Systems',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Smart Attendance Management',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 50),
              _buildRoleButton(
                context, 
                title: 'I am an Instructor', 
                icon: Icons.person, 
                color: Colors.deepPurpleAccent,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const InstructorDashboard())),
              ),
              const SizedBox(height: 20),
              _buildRoleButton(
                context, 
                title: 'I am a Student', 
                icon: Icons.person_outline, 
                color: Colors.tealAccent,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const StudentDashboard())),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleButton(BuildContext context, {required String title, required IconData icon, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.5), width: 2),
          color: color.withOpacity(0.1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
            )
          ],
        ),
      ),
    );
  }
}
