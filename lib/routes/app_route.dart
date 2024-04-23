//! general pages
import '../screens/authenticate/signup/SignupScreen.dart';
import '../screens/authenticate/otp/OtpScreen.dart';
import '../screens/authenticate/splash/SplashScreen.dart';
import '../screens/authenticate/login/LoginScreen.dart';
import '../screens/authenticate/forgot_password/ForgotPasswordScreen.dart';
import '../screens/authenticate/reset_password/ResetPasswordScreen.dart';
import '../screens/authenticate/complete_profile/CompleteProfile.dart';
import '../../../../screens/home/home_page/homepage.dart';
import '../../../../screens/home/home_page/leader.dart';
import '../../screens/home/setting/Setting_Screen.dart';

//! languages game
import '../../screens/home/game/languages/Language_Screen.dart';
import '../../screens/home/game/languages/game_one/languaes_first_letter.dart';
import '../../screens/home/game/languages/game_two/languages_first_word.dart';
import '../../screens/home/game/languages/game_three/languages_conjunction.dart';
import '../../screens/home/game/languages/game_four/languages_word_sort.dart';

//! attention game
import '../../screens/home/game/attention/Attention_Screen.dart';

// attention 1
import '../../screens/home/game/attention/game_one/attention_game1.dart';

// attention 2
import '../../screens/home/game/attention/game_two/level_att2.dart';

// attention 3
import '../../screens/home/game/attention/game_three/menu_Level_game3.dart';
import '../../screens/home/game/attention/game_three/attention_game3_level1.dart';
import '../../screens/home/game/attention/game_three/attention_game3_level2.dart';
import '../../screens/home/game/attention/game_three/attention_game3_level3.dart';
import '../../screens/home/game/attention/game_three/attention_game3_level4.dart';
import '../../screens/home/game/attention/game_three/attention_game3_level5.dart';
import '../../screens/home/game/attention/game_three/attention_game3_level6.dart';
import '../../screens/home/game/attention/game_three/attention_game3_level7.dart';
import '../../screens/home/game/attention/game_three/attention_game3_level8.dart';
import '../../screens/home/game/attention/game_three/attention_game3_level9.dart';
import '../../screens/home/game/attention/game_three/attention_game3_level10.dart';

//! memory game
import '../../screens/home/game/memory/Memory_Screen.dart';
import '../../screens/home/game/memory/game_one/memory_one.dart';
import '../../screens/home/game/memory/game_two/level.dart';
import '../../screens/home/game/memory/game_three/level_m3.dart';

//! math game
import '../../../../screens/home/game/math/Math_Screen.dart';
import '../../screens/home/game/math/game1_screens/game1_screen.dart';
import '../../screens/home/game/math/game1_screens/g1_congrat_screen.dart';
import '../../screens/home/game/math/game2_screens/g2_levels_screen.dart';
import '../../screens/home/game/math/game2_screens/game2_screen.dart';
import '../../screens/home/game/math/game2_screens/g2_congrat_screen.dart';

//! admin
// import '../../screens/home/admin/admin_page.dart';
import '../screens/home/about_us/about_our.dart';
import '../screens/home/about_us/function.dart';
import '../screens/home/about_us/group.dart';
import '../screens/home/about_us/intro.dart';
import '../shared/notification_ui.dart';

//! user
// import '../../screens/home/user/profile.dart';
// import '../../screens/home/user/menu_user.dart';

class RouteGenerator {
  const RouteGenerator._();

  //! general routes
  static const splash = '/splash';
  static const login = '/login';
  static const forgotPassword = '/forgotPassword';
  static const resetPassword = '/resetPassword';
  static const signup = '/signup';
  static const otp = '/otp';
  static const completeProfile = '/completeProfile';
  static const homepage = '/homepage';
  static const leader = '/leader';
  static const setting = '/setting';

  //! languages game
  static const languageScreen = '/languageScreen';
  static const gameLetter = '/gameLetter';
  static const gameWord = '/gameWord';
  static const gameConj = '/gameConj';
  static const gameSort = '/gameSort';

  //! memory game
  static const memoryScreen = '/memoryScreen';
  static const gameMemory1 = 'gameMemory1';
  static const gameMemory2 = 'gameMemory2';
  static const gameMemory3 = 'gameMemory3';

  //! attention game
  static const game3atte1 = 'game3atte1';
  static const game3atte2 = 'game3atte2';
  static const game3atte3 = 'game3atte3';
  static const game3atte4 = 'game3atte4';
  static const game3atte5 = 'game3atte5';
  static const game3atte6 = 'game3atte6';
  static const game3atte7 = 'game3atte7';
  static const game3atte8 = 'game3atte8';
  static const game3atte9 = 'game3atte9';
  static const game3atte10 = 'game3atte10';
  static const attentionScreen = '/attentionScreen';
  static const gametest = 'gametest';
  static const levelattengame3 = 'levelattengame3';
  static const game1Atten = '/game1Atten';
  static const game2Atten = '/game2Atten';

  //! math game
  static const mathScreen = '/mathScreen';
  static const game1Math = '/game1Math';
  static const game2Math = '/game2Math';
  static const math2Level = '/game2MathLevel';
  static const result_gameMath1 = '/math1_result';
  static const result_gameMath2 = '/math2_result';

  //! popup
  static const walkthrough_screen = '/walkthrough_screen';

  //! admin_page
  static const admin_page2 = '/admin_page2';

  //! user
  static const profile = '/profile';
  static const menu_user = '/menu_user';
  static const stat_user = '/stat_user';

  //! Notificaion
  static const notify = '/notify';
  static const about_us = '/about_us';
  static const intro = '/intro';
  static const func = '/func';
  static const group = '/group';

  static final routes = {
    //! general routes
    splash: (context) => const SplashScreen(),
    login: (context) => const LoginScreen(),
    forgotPassword: (context) => const ForgotPasswordScreen(),
    resetPassword: (context) => const ResetPasswordScreen(),
    signup: (context) => const SignupScreen(),
    otp: (context) => const OtpScreen(),
    completeProfile: (context) => const CompleteProfile(),
    homepage: (context) => const Homepage(),
    leader: (context) => BottomNavBar(index: 1,),
    // setting: (context) => const SettingsScreen(),

    //! languages game
    languageScreen: (context) => const LanguageScreen(),
    gameLetter: (context) => const LanguagesFirstLetter(),
    gameWord: (context) => const LanguagesFirstWord(),
    gameConj: (context) => const LanguageGameThree(),
    gameSort: (context) => const WordFind(),

    //! memory game
    memoryScreen: (context) => const MemoryScreen(),
    gameMemory1: (context) => const MemoryOne(),
    gameMemory2: (context) => const LevelScreen(),
    gameMemory3: (context) => const LevelM3Screen(),

    //! attention game
    attentionScreen: (context) => const AttentionScreen(),
    game1Atten: (context) => const AttentionGameOne(),
    game2Atten: (context) => const LevelA2Screen(),
    levelattengame3: (context) => const LevelsScreen(),
    game3atte1: (context) => const GameAtte3Level1(),
    game3atte2: (context) => const GameAtte3Level2(),
    game3atte3: (context) => const GameAtte3Level3(),
    game3atte4: (context) => const GameAtte3Level4(),
    game3atte5: (context) => const GameAtte3Level5(),
    game3atte6: (context) => const GameAtte3Level6(),
    game3atte7: (context) => const GameAtte3Level7(),
    game3atte8: (context) => const GameAtte3Level8(),
    game3atte9: (context) => const GameAtte3Level9(),
    game3atte10: (context) => const GameAtte3Level10(),

    //! math game
    mathScreen: (context) => const MathScreen(),
    game1Math: (context) => const Game1Screen(),
    game2Math: (context) => const Game2Screen(),
    math2Level: (context) => Math2LevelScreen(),
    result_gameMath1: (context) => const Math1CongratScreen(),
    result_gameMath2: (context) => const Math2CongratScreen(),

    //! notificaion
    notify: (context) => CustomLottieDialog(),
    // about_us: (context) => AboutScreen(),
    intro: (context) => IntroScreen(),
    func: (context) => FuncScreen(),
    group: (context) => GroupScreen(),

    //! admin
    // TODO: cần thêm admin sau
    // admin_page2: (context) => const Adminpage(),

    //! user
    // TODO: cần thêm user sau
    // profile: (context) => Scene(),
    // menu_user: (context) => TabBarPage(),
  };
}
