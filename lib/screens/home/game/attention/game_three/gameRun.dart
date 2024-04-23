import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class GameRunProvider extends ChangeNotifier {
  bool _gameRun = false;

  bool get gameRun => _gameRun;

  void setGameRun(bool value) {
    _gameRun = value;
    notifyListeners(); // Thông báo cho các người tiêu dùng về sự thay đổi
  }
}
