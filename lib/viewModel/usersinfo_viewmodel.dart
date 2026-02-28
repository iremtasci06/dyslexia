import 'package:flutter/cupertino.dart';

class AvatarViewModel extends ChangeNotifier {
  String? _selectedAvatar;
  String? _email;
  String? _username;
  String? _sifre;
  String? _adsoyad;
  DateTime? _dogumgunu;
  String? _sinif;

  String? get selectedAvatar => _selectedAvatar;
  String? get email => _email;
  String? get username => _username;
  String? get sifre => _sifre;
  String? get adsoyad => _adsoyad;
  DateTime? get dogumgunu => _dogumgunu;
  String? get sinif => _sinif;

  void selectAvatar(String avatarPath) {
    _selectedAvatar = avatarPath;
    notifyListeners();
  }

  void setEmail(String e) {
    _email = e;
    notifyListeners();
  }

  void setUsername(String u) {
    _username = u;
    notifyListeners();
  }

  void setSifre(String s) {
    _sifre = s;
    notifyListeners();
  }

  void setAdSoyad(String a) {
    _adsoyad = a;
    notifyListeners();
  }

  void setDogumgunu(DateTime d) {
    _dogumgunu = d;
    notifyListeners();
  }

  void setSinif(String s) {
    _sinif = s;
    notifyListeners();
  }
}
