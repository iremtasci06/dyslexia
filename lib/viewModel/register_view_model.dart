import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/users_models.dart';

class RegisterViewModel extends ChangeNotifier{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference usersCollection = FirebaseFirestore.instance
      .collection('users');
  Future<String?> addUser(Users user) async {
    try {
      // Kullanıcı adı çakışması kontrolü
      final query =
      await usersCollection
          .where('kullaniciAdi', isEqualTo: user.username)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        return 'Bu kullanıcı adı zaten alınmış.';
      }
      final emailQuery = await usersCollection
          .where('email', isEqualTo: user.email)
          .limit(1)
          .get();

      if (emailQuery.docs.isNotEmpty) {
        return 'Bu email zaten kullanılıyor.';
      }

      // Firebase Authentication'da oluştur
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
        email: user.email,
        password: user.sifre,
      );

      // Firestore'a ekle (şifre yok)
      await usersCollection.doc(userCredential.user!.uid).set(user.toMap());

      return null; // Başarılı
    } on FirebaseAuthException catch (e) {
      return "Kayıt hatası: ${e.message}";
    } catch (e) {
      return "Bilinmeyen hata: $e";
    }
  }
}