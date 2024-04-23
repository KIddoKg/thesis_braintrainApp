import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:notification_center/notification_center.dart';
import '../base/game_component.dart';
import 'game_controller.dart';
import 'game_setting.dart';
import '../map/map_controller.dart';
import '../view/gamebar_view.dart';
import '../view/weapon_factory_view.dart';
import 'package:flutter/material.dart';

class GameMain extends FlameGame with HasTappables {
  Color backgroundColor() => const Color(0xFFEEEEEE);
  late MapController mapController;
  late WeaponFactoryView weaponFactory;
  late GameController gameController;
  late GamebarView gamebarView;
  bool started = false;

  bool loadDone = false;

  // GameView view = GameView();
  GameSetting gameSetting = GameSetting();
  // GameController controller = GameController();
  // EnemySpawner enemySpawner = EnemySpawner();
  // StatusBar statusBar;
  // GameUtil util;
  late Timer countDown;
  int remainingTime =120;
  bool timerStarted = false;

  GameMain();

  @override
  void onGameResize(Vector2 size) {
    if (!loadDone) setting.setScreenSize(size);
    super.onGameResize(size);
  }

  int currentTimeMillis() {
    return new DateTime.now().millisecondsSinceEpoch;
  }

  @override
  Future<void> onLoad() async {
    int timeRecord = currentTimeMillis();

    await super.onLoad();

    // await setting.onLoad();
    // await setting.neutual.load();

    mapController = MapController(
        tileSize: setting.mapTileSize,
        mapGrid: setting.mapGrid,
        position: setting.mapPosition,
        size: setting.mapSize);
    /*game controller should have same range as map */
    gameController =
        GameController(position: setting.mapPosition, size: setting.mapSize);

    gamebarView = GamebarView();
    weaponFactory = WeaponFactoryView();

    await setting.weapons.load(gameSetting);

    add(mapController);
    add(gameController);
    add(gamebarView);
    add(weaponFactory);

    setting.enemies.load();

    loadDone = true;
    int d = currentTimeMillis() - timeRecord;
    print("GameMain onLoad done takke $d");
  }

  @override
  void update(double t) {
    super.update(t);

    if (timerStarted && remainingTime > 0) {
      countDown.update(t);
    }
  }


  Future<void> start() async {
    if (loadDone) {
      countDown = Timer(1, onTick: () {
        if (remainingTime > 0) {
          remainingTime -= 1;
          // overlays.notifyListeners();
        }
        // print(remainingTime);
        gamebarView.remainingTime = remainingTime;
      }, repeat: true);

      timerStarted = true;
      gameController.send(GameComponent(), GameControl.ENEMY_SPAWN);
      gamebarView.killedEnemy = 0;
      gamebarView.mineCollected = 999;
      gamebarView.missedEnemy = 0;
    }
  }
}
