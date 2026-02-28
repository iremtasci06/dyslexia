import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference usersCollection =
  FirebaseFirestore.instance.collection('users');

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<String?> loginUser(String username, String password) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Kullanıcı adından email bul
      final query = await usersCollection
          .where('kullaniciAdi', isEqualTo: username)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        return "Kullanıcı bulunamadı.";
      }

      final data = query.docs.first.data() as Map<String, dynamic>;
      final email = data['email'];

      if (email == null || email.isEmpty) {
        return "Kullanıcının e-posta bilgisi eksik.";
      }

      // FirebaseAuth ile giriş yap
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      return null; // Başarılı giriş
    } on FirebaseAuthException catch (e) {
      return "Giriş hatası: ${e.message}";
    } catch (e) {
      return "Bilinmeyen hata: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
