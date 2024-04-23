import 'package:get/get.dart';

class Globals {
  // to monitor the level of each play time
  static RxInt glbLevel = 0.obs;

  // to monitor the max unlocked level
  static int maxUnlockedLevel = 1;

  // to announce the level is up
  static bool announceLevelUp = false;

  // to stop timer when needed
  static bool stopTimer = false;
}
