import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/profile.dart';

class ProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createProfile(Profile profile) async {
    await _firestore.collection('profiles').doc(profile.id).set(profile.toJson());
  }

  Future<Profile?> getProfile(String userId) async {
    final doc = await _firestore.collection('profiles').doc(userId).get();
    if (doc.exists) {
      return Profile.fromJson(doc.data()!);
    }
    return null;
  }

  Future<void> updateProfile(Profile profile) async {
    await _firestore.collection('profiles').doc(profile.id).update(profile.toJson());
  }
  Future<String> getNameById(String userId) async {
    try {
      final doc = await FirebaseFirestore.instance.collection('profiles').doc(userId).get();
      if (doc.exists && doc.data() != null) {
        return doc.data()!['name'] as String? ?? 'Unknown'; // Return 'Unknown' if the name is null
      }
      return 'Unknown'; // Return 'Unknown' if the document doesn't exist or has no data
    } catch (e) {
      print('Error fetching name: $e');
      return 'Unknown'; // Return 'Unknown' in case of an error
    }
  }
}
