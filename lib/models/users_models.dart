import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  final String email;
  final String username;
  final String sifre;
  final String childName;
  final DateTime childAge;
  final String childClass;
  final String avatarUrl;

  Users({
    required this.email,
    required this.username,
    required this.sifre,
    required this.childName,
    required this.childAge,
    required this.childClass,
    required this.avatarUrl,
  });

  // Firebase'den gelen veriyi User objesine çevir
  factory Users.fromMap(Map<String, dynamic> data, String documentId) {
    return Users(
      email: data['email'] ?? '',
      username: data['kullaniciAdi'] ?? '',
      sifre: data['sifre'] ?? '',
      childName: data['cocukAdi'] ?? '',
      childAge: (data['cocukYaş'] as Timestamp?)?.toDate() ?? DateTime.now(),
      childClass: data['cocukSınıf'] ?? '',
      avatarUrl: data['avatar'] ?? '',
    );
  }

  // Firebase'e kaydetmek için Map formatına çevir
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'kullaniciAdi': username,
      'sifre': sifre,
      'cocukAdi': childName,
      'cocukYaş': Timestamp.fromDate(childAge),
      'cocukSınıf': childClass,
      'avatar': avatarUrl,
    };
  }
}
