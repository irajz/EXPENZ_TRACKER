// lib/screens/profile/profile_screen.dart
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage("assets/profile.png"),
              ),
              const SizedBox(height: 10),
              const Text("Iriana Saliha",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),
              _buildTile(Icons.wallet, "My Wallet"),
              _buildTile(Icons.settings, "Settings"),
              _buildTile(Icons.download, "Export Data"),
              _buildTile(Icons.logout, "Logout", color: Colors.red, onTap: () {
                _showLogoutDialog(context);
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTile(IconData icon, String title,
      {Color color = Colors.black, VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color)),
      onTap: onTap,
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Logout?"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("No", style: TextStyle(color: Colors.purple))),
          TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                // TODO: call logout logic (clear token, redirect to login)
              },
              child: const Text("Yes", style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }
}
