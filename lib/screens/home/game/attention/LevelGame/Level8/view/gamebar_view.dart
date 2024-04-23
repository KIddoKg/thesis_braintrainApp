import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../base/game_component.dart';
import '../game/game_controller.dart';
import '../game/game_setting.dart';
import 'mine_view.dart';

GameSetting setting = GameSetting();

class GamebarView extends GameComponent {
  GamebarView() : super(position: setting.barPosition, size: setting.barSize) {
    active = false;
  }

  late TextComponent startIndicator;

  late TextComponent missedStatus;
  late TextComponent killedStatus;
  late TextComponent waveStatus;
  late TextComponent timerStatus;

  late MineView mine;

  late Timer countDown;
  int _remainingTime = 30;
  bool timerStarted = true;
  int heathResult = 0;
  int killResult = 0;
  int _wave = 0;
  int _killedEnemy = 0;
  int _missedEnemy = 0;
  int _mineCollected = 0;
  int _lives = 600;

  @override
  Future<void>? onLoad() {
    countDown = Timer(1, onTick: () {
      if (_remainingTime > 0) {
        _remainingTime -= 1;
        // overlays.notifyListeners();
      }
    });

     waveStatus = TextComponent(
      textRenderer:
      TextPaint(style: const TextStyle(color: Colors.black, fontSize: 20)),
      position: (size / 2)..x = (size.x * (3/ 8)),
      anchor: Anchor.center,
    );
    add(waveStatus);

    missedStatus = TextComponent(
      textRenderer:
          TextPaint(style: const TextStyle(color: Colors.black, fontSize: 12)),
      position: (size / 2)..x = (size.x * (1 / 8)),
      anchor: Anchor.center,
    );
    add(missedStatus);

    killedStatus = TextComponent(
      textRenderer:
          TextPaint(style: const TextStyle(color: Colors.red, fontSize: 20)),
      position: (size / 2)..x = (size.x * (5 / 8)),
      anchor: Anchor.center,
    );
    add(killedStatus);

    timerStatus = TextComponent(
      textRenderer:
          TextPaint(style: const TextStyle(color: Colors.black, fontSize: 12)),
      position: (size / 2)..x = (size.x * (7 / 8)),
      anchor: Anchor.center,
    );
    add(timerStatus);

    mine = MineView(
        position: (size / 2)..x = (size.x * (6 / 8)),
        size: Vector2(size.y * 1.5, size.y) * 0.7,
        style: const TextStyle(color: Colors.black, fontSize: 12));
    // add(mine);
  }

  int get wave => _wave;

  set wave(n) {
    _wave = n;
    // waveStatus.text = 'Wave: $_wave';
  }

  // set wave(int n) {
  //   _missedEnemy = n;

  //   waveStatus.text = 'Lives: ${_lives - _missedEnemy * 20} %';
  //   if (_lives - _missedEnemy <= 0) {
  //     gameRef.gameController.send(this, GameControl.GAME_OVER);
  //   }
  // }

  int get killedEnemy => _killedEnemy;

  set killedEnemy(int n) {
    _killedEnemy = n;
    killedStatus.text = 'Cá: $_killedEnemy';
    killResult = _killedEnemy;
  }

  int get missedEnemy => _missedEnemy;

  set missedEnemy(int n) {
    _missedEnemy = n;
    waveStatus.text = 'Điểm: ${(_lives - _missedEnemy * 20) * 80}';
    missedStatus.text = 'Máu: ${_lives - _missedEnemy * 20} %';
    heathResult = (_lives - _missedEnemy * 20) * 80;
    if (_lives - _missedEnemy * 20 <= 0 || _lives - _missedEnemy * 20 < 580) {
      saveData(killResult, heathResult);
      gameRef.gameController.send(this, GameControl.GAME_OVER);
    }
  }

  int get remainingTime => _remainingTime;

  set remainingTime(int n) {
    _remainingTime = n;
    timerStatus.text = 'Thời gian: ${_remainingTime} s';
    if (_remainingTime <= 0) {
      saveData(killResult, heathResult);
      gameRef.gameController.send(this, GameControl.GAME_NEXT);
    }
  }

  int get mineCollected => _mineCollected;

  set mineCollected(int n) {
    _mineCollected = n;
    mine.number = _mineCollected;
  }
}

void saveData(int killResult, int heathResult) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt('kill_Result', killResult);
  prefs.setInt('heath_Result', heathResult);
}
