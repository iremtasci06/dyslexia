import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disleksi_surum/models/game_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

class GameResultViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Harf için oyun sonucunu kaydet
  Future<void> saveGameResult({
    required String letter,
    required int totalClicks,
    required int correctClicks,
    required int durationseconds,
    required String koleksiyonadi,
  }) async {
    // Mevcut kullanıcıyı al
    final user = _auth.currentUser;
    if (user == null) return;

    // Doğruluk oranını hesapla
    final double accuracy = totalClicks > 0 ? (correctClicks / totalClicks) : 0;

    // GameResult nesnesi oluştur
    final gameResult = GameResult(
      totalClicks: totalClicks,
      correctClicks: correctClicks,
      durationseconds: durationseconds,
    );

    // Kullanıcı altındaki GameResults koleksiyonu
    final gameResultsRef = _firestore.collection('users').doc(user.uid).collection(koleksiyonadi);

    // Harf belgesi referansı (örn: P, B, D)
    final letterDocRef = gameResultsRef.doc(letter.toLowerCase());

    // Harf belgesi var mı kontrol et
    final letterDocSnapshot = await letterDocRef.get();
    if (!letterDocSnapshot.exists) {
      // Yoksa oluştur
      await letterDocRef.set({'createdAt': FieldValue.serverTimestamp()});
    }

    // Lessons alt koleksiyonuna oyun oturumunu ekle
    await letterDocRef.collection('lessons').add(gameResult.toMap());

    notifyListeners();
  }
}
