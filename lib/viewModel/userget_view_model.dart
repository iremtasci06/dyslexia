import 'package:disleksi_surum/models/users_models.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class UserGetViewModel extends ChangeNotifier {
  Future<Users?> getUser() async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) return null;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (doc.exists && doc.data() != null) {
        return Users.fromMap(doc.data()!, doc.id);
      }
    } catch (e) {
      debugPrint("Error fetching user: $e");
    }

    return null;
  }
}
