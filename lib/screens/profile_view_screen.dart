import 'package:flutter/material.dart';
import '../models/profile.dart';
import '../services/profile_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileViewScreen extends StatelessWidget {
  final ProfileService _profileService = ProfileService();

  Future<Profile?> _getProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return await _profileService.getProfile(user.uid);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
        centerTitle: true,
        elevation: 10,
        backgroundColor: Colors.deepPurpleAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.edit, size: 28), // Increased icon size
            onPressed: () {
              Navigator.pushNamed(context, '/profile-edit');
            },
          ),
        ],
      ),
      body: FutureBuilder<Profile?>(
        future: _getProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || snapshot.data == null) {
            return Center(child: Text('Error loading profile.'));
          } else {
            final profile = snapshot.data!;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    // Profile Info
                    _buildProfileInfo(Icons.person, 'Name', profile.name),
                    _buildProfileInfo(Icons.email, 'Email', profile.email),
                    _buildProfileInfo(Icons.phone, 'Phone', profile.phone),
                    _buildProfileInfo(Icons.info_outline, 'Bio', profile.bio),
                    SizedBox(height: 40),
                    // Edit Profile Button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/profile-edit');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent,
                        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      child: Text(
                        'Edit Profile',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  // Method to build profile info with icon
  Widget _buildProfileInfo(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: Colors.deepPurpleAccent, size: 30), // Adjusted icon size and color
          SizedBox(width: 15),
          Expanded(
            child: Text(
              '$label: $value',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
