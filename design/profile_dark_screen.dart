import 'package:flutter/material.dart';

class ProfileDarkScreen extends StatelessWidget {
  const ProfileDarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.white),
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
            ),
            const SizedBox(height: 16),
            const Text(
              'Arun Mishra',
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text('Admin', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 48),
            _buildMenuTile(Icons.lock_outline, 'Manage Passwords'),
            _buildMenuTile(Icons.person_outline, 'Edit Profile'),
            _buildMenuTile(Icons.notifications_none, 'Notification', isToggle: true),
            _buildMenuTile(Icons.help_outline, 'Help & Support'),
            _buildMenuTile(Icons.file_copy_outlined, 'Terms & Privacy'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[700],
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Logout', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuTile(IconData icon, String title, {bool isToggle = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue[300]),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        trailing: isToggle 
            ? Switch(value: true, onChanged: (val) {}, activeColor: Colors.blue)
            : const Icon(Icons.chevron_right, color: Colors.grey),
      ),
    );
  }
}
