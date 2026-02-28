import 'dart:math';
import 'base_game_view_model.dart';

class AsansorViewModel extends BaseGameViewModel {
  AsansorViewModel() : super(correctClicks: 3) {
    _initFloors();
    _generateTargets();
  }

  final Random _random = Random();

  // Tur sayısı
  final int totalRounds = 3;
  int completedRounds = 0;

  // Katlar ve asansör pozisyonu
  int _currentFloor = 0;
  int _targetFloor = 0;
  double _elevatorPosition = 0.0;

  final double _floorHeight = 80.0;
  final double _storyBoxHeight = 20.0;
  final List<double> _floorPositions = [];

  // Hikaye adımları (her tur için 1 hedef kat)
  final List<int> _storyTargetFloors = [];

  double get elevatorPosition => _elevatorPosition;
  int get currentFloor => _currentFloor;
  int get targetFloor => _targetFloor;
  double get floorHeight => _floorHeight;

  void _initFloors() {
    for (int i = 0; i < 6; i++) {
      _floorPositions.add(_storyBoxHeight + i * _floorHeight);
    }
    _elevatorPosition = _floorPositions[_currentFloor];
  }

  void _generateTargets() {
    _storyTargetFloors.clear();
    for (int i = 0; i < totalRounds; i++) {
      _storyTargetFloors.add(_random.nextInt(6)); // Her tur için 1 hedef
    }
    completedRounds = 0;
    _currentFloor = 0;
    _targetFloor = _storyTargetFloors[completedRounds];
    _elevatorPosition = _floorPositions[_currentFloor];
    notifyListeners();
  }

  void moveUp() {
    if (_currentFloor > 0) {
      _currentFloor--;
      _elevatorPosition = _floorPositions[_currentFloor];
      notifyListeners();
    }
  }

  void moveDown() {
    if (_currentFloor < _floorPositions.length - 1) {
      _currentFloor++;
      _elevatorPosition = _floorPositions[_currentFloor];
      notifyListeners();
    }
  }

  /// True dönerse oyun bitmiş demektir
  bool checkIfAtTarget() {
    incrementTotalClicks();

    if (_currentFloor == _targetFloor) {
      completedRounds++;
      if (completedRounds < totalRounds) {
        // Yeni tur
        _currentFloor = 0;
        _targetFloor = _storyTargetFloors[completedRounds];
        _elevatorPosition = _floorPositions[_currentFloor];
        notifyListeners();
        return false;
      } else {
        // ✅ Oyun bitti
        notifyListeners();
        return true;
      }
    } else {
      notifyListeners();
      return false;
    }
  }

  double getFloorPosition(int floorIndex, double topOffset) {
    return topOffset + floorIndex * _floorHeight;
  }
}
