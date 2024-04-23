import 'dart:math';

import 'package:brain_train_app/helper/formater.dart';
import 'package:brain_train_app/shared/light_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:brain_train_app/models/dataGameGet.dart';
import '../../../services/services.dart';
import '../../../shared/app_styles.dart';
import '../../../shared/share_widgets.dart';

class StatisticalPage extends StatefulWidget {
  // ChartService? chartType;

  StatisticalPage({
    Key? key,
  }) : super(key: key);

  @override
  State<StatisticalPage> createState() => _StatisticalPageState();
}

class _StatisticalPageState extends State<StatisticalPage> {
  late List<ExpenseData> _chartData;
  late TooltipBehavior _tooltipBehavior;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool checkDays = true;
  bool checkWeek = false;
  bool checkMonth = false;
  bool expandScreen = false;
  bool testBug = false;
  bool loadingDataChart = false;
  late ZoomPanBehavior _zoomPanBehavior;

  List<GameData> _dealsBefore = [];
  String selectGame = "";
  List<String> buttonTitles = ["Trí nhớ", "Tập trung", "Ngôn ngữ", "Toán học"];
  List<String> buttonTitlesGame1 = ["Trò chơi 1", "Trò chơi 2", "Trò chơi 3"];
  List<String> buttonTitlesGame2 = ["Trò chơi 1", "Trò chơi 2", "Trò chơi 3"];
  List<String> buttonTitlesGame3 = ["Trò chơi 1", "Trò chơi 2", "Trò chơi 3", "Trò chơi 4"];
  List<String> buttonTitlesGame4 = ["Trò chơi 1", "Trò chơi 2"];
  int _selectedGameData = 0;
  int _selectedGame1 = 0;
  int _selectedGame2 = 0;
  int _selectedGame3 = 0;
  int _selectedGame4 = 0;
  int beforeMaxPoint = 0;
  int nowMaxPoint = 0;
  double percent = 0.0;
  bool levelLg4 = false;

  List<GameData> _game = [];

  bool runSave = false;

  Map<String, dynamic> filter = {
    "fromDate": DateTime.now().millisecondsSinceEpoch,
    "toDate": DateTime.now().millisecondsSinceEpoch,
    "gameType": "",
    "gameName": "",
  };
  Map<String, dynamic> filterDataBefore = {
    "fromDate": DateTime.now().millisecondsSinceEpoch,
    "toDate": DateTime.now().millisecondsSinceEpoch,
    'gameType': '',
    'gameName': '',
  };
  Map<String, dynamic> filterData = {
    "fromDate": DateTime.now().millisecondsSinceEpoch,
    "toDate": DateTime.now().millisecondsSinceEpoch,
    "gameType": "",
    "gameName": "",
  };
  late TrackballBehavior _trackballBehavior;

  @override
  void initState() {

    onSelectedDate(0);
    _chartData = getDataNull();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        expandScreen = true;
        _runCheck();
      });
      await initData();

    });
    _zoomPanBehavior = ZoomPanBehavior(
        enablePinching: true,
        enableDoubleTapZooming: true,
        enablePanning: true,
        zoomMode: ZoomMode.x,
        enableMouseWheelZooming: true,
        maximumZoomLevel: 0.7);
    _tooltipBehavior = TooltipBehavior(enable: true);
    _trackballBehavior = TrackballBehavior(
      enable: true,
      builder: (BuildContext context, TrackballDetails trackballDetails) {
        int? intValue;
        if (trackballDetails.point!.yValue is int) {
          intValue = trackballDetails.point!
              .yValue; // If dynamicData is already an int, assign it directly
        } else if (trackballDetails.point!.yValue is String) {
          intValue = int.tryParse(trackballDetails.point!.yValue);
        }
        return Container(
          height: 50,
          width: 150,
          decoration: const BoxDecoration(
            color: Color.fromRGBO(0, 8, 22, 0.75),
            borderRadius: BorderRadius.all(Radius.circular(6.0)),
          ),
          child: Row(
            children: [
              Center(
                  child: SizedBox(
                      height: 40,
                      width: 150,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            !levelLg4 ? 'Điểm số' : 'Cấp',
                            style: TextStyle(
                              fontSize: 13,
                              color: trackballDetails.series!
                                  .color, // Change the color to the desired color
                            ),
                          ),
                          Text(
                            ' : $intValue',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color.fromRGBO(255, 255, 255, 1),
                            ),
                          ),
                        ],
                      )))
            ],
          ),
        );
      },
      activationMode: ActivationMode.singleTap,
    );
    super.initState();
  }

  Future<void> _runCheck() async {
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    testBug = true;
    setState(() {});
  }

  int currentMonth = DateTime.now().month;
  int currentYear = DateTime.now().year;

  void decreaseMonth() {
    _chartData = getChartDataDays();
    if (currentMonth > 1) {
      setState(() {
        currentMonth--;
      });
    } else {
      setState(() {
        currentMonth = 12;
        currentYear--;
      });
    }
  }

  void increaseMonth() {
    _chartData = getChartDataDays();
    if (currentMonth < 12) {
      setState(() {
        currentMonth++;
      });
    } else {
      setState(() {
        currentMonth = 1;
        currentYear++;
      });
    }
  }

  void checkNowDays() {
    DateTime nowDate = DateTime.now();

    var dateStr = filterData['toDate'];
    DateTime now = DateTime.fromMillisecondsSinceEpoch(dateStr);
    if (nowDate.day == now.day &&
        nowDate.month == now.month &&
        nowDate.year == now.year) {
      runSave = false;
    } else {
      runSave = true;
    }
    setState(() {});
  }

  Future<void> initData() async {
    filter['fromDate'] = filterData['fromDate'];
    filter['toDate'] = filterData['toDate'];

    levelLg4 = false;
    switch (_selectedGameData) {
      case 0:
        filter['gameType'] = "MEMORY";
        filterDataBefore['gameType'] = "MEMORY";
        switch (_selectedGame1) {
          case 0:
            filter['gameName'] = "POSITION";
            filterDataBefore['gameName'] = "POSITION";
            break;
          case 1:
            filter['gameName'] = "NEW_PICTURE";
            filterDataBefore['gameName'] = "NEW_PICTURE";
            break;
          case 2:
            filter['gameName'] = "LOST_PICTURE";
            filterDataBefore['gameName'] = "LOST_PICTURE";
            break;
        }
        break;
      case 1:
        filter['gameType'] = "ATTENTION";
        filterDataBefore['gameType'] = "ATTENTION";
        switch (_selectedGame2) {
          case 0:
            filter['gameName'] = "DIFFERENCE";
            filterDataBefore['gameName'] = "DIFFERENCE";
            break;
          case 1:
            filter['gameName'] = "PAIRING";
            filterDataBefore['gameName'] = "PAIRING";
            break;
          case 2:
            filter['gameName'] = "FISHING";
            filterDataBefore['gameName'] = "FISHING";
            break;
        }
        break;
      case 2:
        filter['gameType'] = "LANGUAGE";
        filterDataBefore['gameType'] = "LANGUAGE";
        switch (_selectedGame3) {
          case 0:
            filter['gameName'] = "STARTING_LETTER";
            filterDataBefore['gameName'] = "STARTING_LETTER";
            break;
          case 1:
            filter['gameName'] = "STARTING_WORD";
            filterDataBefore['gameName'] = "STARTING_WORD";
            break;
          case 2:
            filter['gameName'] = "NEXT_WORD";
            filterDataBefore['gameName'] = "NEXT_WORD";
            break;
          case 3:
            filter['gameName'] = "LETTERS_REARRANGE";
            filterDataBefore['gameName'] = "LETTERS_REARRANGE";
            levelLg4 = true;
            break;
        }
        break;
      case 3:
        filter['gameType'] = "MATH";
        filterDataBefore['gameType'] = "MATH";
        switch (_selectedGame4) {
          case 0:
            filter['gameName'] = "SMALLER_EXPRESSION";
            filterDataBefore['gameName'] = "SMALLER_EXPRESSION";
            break;
          case 1:
            filter['gameName'] = "SUM";
            filterDataBefore['gameName'] = "SUM";
            break;
        }
        break;
    }
    getDateBefore();
    loadingDataChart = true;
    var resBefore =
        await Services.instance.setContext(context).getDataGameUser(filter: filterDataBefore);
    if (resBefore != null) {
      var res = await Services.instance.getDataGameUser(filter: filter);
      loadingDataChart = false;
      if (res != null) {
        var data = res.castList<GameData>();
        _game = data;

        setState(() {});
        _chartData = getChartData();
      }
      var data = resBefore.castList<GameData>();

      _dealsBefore = data;
    }

    if(nowMaxPoint != 0 && beforeMaxPoint != 0 ) {
      percent = (nowMaxPoint - beforeMaxPoint) / beforeMaxPoint;
    }
    else if (nowMaxPoint != 0 && beforeMaxPoint == 0) {
      percent = 1;
    } else if (nowMaxPoint == 0 && beforeMaxPoint != 0) {
      percent = -1;

    }else {
      percent = 0;
    }
    setState(() {});
  }

  List<ExpenseData> getChartData() {
    var data = getNull();
    if (checkWeek == true) {
      data = getChartDataWeek();
    } else if (checkMonth == true) {
      data = getChartMonth();
    } else if (checkDays == true) {
      data = getChartDataDays();
    }

    final List<ExpenseData> chartData = data;
    return chartData;
  }

  List<ExpenseData> getDataDealinDays() {
    var fromDateTime =
    filterData['fromDate']; // Assuming you have this variable
    var toDateTime = filterData['toDate']; // Assuming you have this variable

    DateTime fromDate = DateTime.fromMillisecondsSinceEpoch(fromDateTime);
    DateTime toDate = DateTime.fromMillisecondsSinceEpoch(toDateTime);

    // Sử dụng một Map để theo dõi tổng số tiền cho mỗi ngày
    Map<int, int> dailyPoint = {};

    // Đảm bảo tạo các mục cho tất cả các ngày trong khoảng thời gian
    for (var day = 1; day <= toDate.day; day++) {
      dailyPoint[day] ??= 0;
    }
    beforeMaxPoint = 0;
    for (var e in _dealsBefore) {
      if (e.gameName == filter['gameName']) {
        if(e.gameName == "LETTERS_REARRANGE") {
          if (beforeMaxPoint < e.maxLevel) {
            beforeMaxPoint = e.maxLevel;
          }
        }else{
          if (beforeMaxPoint < e.score) {
            beforeMaxPoint = e.score;
          }
        }

      }
    }
    nowMaxPoint = 0;
    for (var e in _game) {
      DateTime checkDay = DateTime.fromMillisecondsSinceEpoch(e.createdDate);
      if (e.gameName == filter['gameName']) {
        if(e.gameName == "LETTERS_REARRANGE") {
          if (nowMaxPoint < e.maxLevel) {
            nowMaxPoint = e.maxLevel;
          }
        }else{
          if (nowMaxPoint < e.score) {
            nowMaxPoint = e.score;
          }
        }

      }
      // if (checkDay.isAfter(fromDate) && checkDay.isBefore(toDate) && e.gameName == "POSITION") {
      //   dailyPoint[checkDay.day] = (e.score);
      // }

      if (checkDay.isAfter(fromDate) &&
          checkDay.isBefore(toDate) &&
          e.gameName == filter['gameName']) {
        if (e.gameName == "LETTERS_REARRANGE") {
          final currentDay = checkDay.day;
          if (dailyPoint[currentDay] == null ||
              e.maxLevel > dailyPoint[currentDay]!) {
            dailyPoint[currentDay] = e.maxLevel;
          }
        } else {
          final currentDay = checkDay.day;
          if (dailyPoint[currentDay] == null ||
              e.score > dailyPoint[currentDay]!) {
            dailyPoint[currentDay] = e.score;
          }
        }
      }
    }

    final List<ExpenseData> chartData = [];

    // Tạo các đối tượng ExpenseData từ tổng số tiền hàng ngày
    dailyPoint.forEach((day, point) {
      chartData.add(
        ExpenseData(
          DateTime(toDate.year,toDate.month,day),
          point,
        ),
      );
    });

    return chartData;
  }
  List<ExpenseData> getDataDealinWeeks() {
    var fromDateTime =
        filterData['fromDate']; // Assuming you have this variable
    var toDateTime = filterData['toDate']; // Assuming you have this variable

    DateTime fromDate = DateTime.fromMillisecondsSinceEpoch(fromDateTime);
    DateTime toDate = DateTime.fromMillisecondsSinceEpoch(toDateTime);

    // Calculate the number of weeks between fromDate and toDate
    int weeks = (toDate.difference(fromDate).inDays ~/ 7) + 1;

    // Use maps to track total expenses and different categories of expenses by week
    Map<int, int> weeklyPoint = {};

    for (var e in _game) {
      DateTime checkDay = DateTime.fromMillisecondsSinceEpoch(e.createdDate);

      if (checkDay.isAfter(fromDate) && checkDay.isBefore(toDate)) {
        // Calculate the week number for the current deal
        int weekNumber = checkDay.difference(fromDate).inDays ~/ 7 + 1;


        if (e.gameName == filter['gameName']) {
          if (e.gameName == "LETTERS_REARRANGE") {
            final currentDay = weekNumber;
            if (weeklyPoint[currentDay] == null ||
                e.maxLevel > weeklyPoint[currentDay]!) {
              weeklyPoint[currentDay] = e.maxLevel;
            }
          } else {
            final currentDay = weekNumber;
            if (weeklyPoint[currentDay] == null ||
                e.score > weeklyPoint[currentDay]!) {
              weeklyPoint[currentDay] = e.score;
            }
          }
        }
      }
    }

    final List<ExpenseData> chartData = [];

    // Create ExpenseData objects from weekly data
    for (int weekNumber = 1; weekNumber <= weeks; weekNumber++) {
      DateTime weekStart = fromDate.add(Duration(days: (weekNumber - 1) * 7));
      DateTime weekEnd = weekStart.add(const Duration(days: 6));

      if (weekEnd.isAfter(toDate)) {
        weekEnd = toDate;

      }
      chartData.add(
        ExpenseData(
          DateTime(weekStart.year,weekStart.month,weekStart.day),
          weeklyPoint[weekNumber] ?? 0,
        ),
      );
    }

    return chartData;
  }

  List<ExpenseData> getDataNull() {
    final List<ExpenseData> chartData = [];
    chartData.add(
      ExpenseData(
        DateTime(2016, 12, 31),
        0,
      ),
    );

    return chartData;
  }

  List<ExpenseData> getDataDealinMonths() {
    var fromDateTime =
        filterData['fromDate']; // Assuming you have this variable
    var toDateTime = filterData['toDate']; // Assuming you have this variable

    DateTime fromDate = DateTime.fromMillisecondsSinceEpoch(fromDateTime);
    DateTime toDate = DateTime.fromMillisecondsSinceEpoch(toDateTime);


    Map<int, int> monthlyPoint = {};

    for (var e in _game) {
      DateTime checkDay = DateTime.fromMillisecondsSinceEpoch(e.createdDate);

      if (checkDay.isAfter(fromDate) && checkDay.isBefore(toDate)) {
        // Calculate the month number for the current deal
        int monthNumber = checkDay.month;


        if (e.gameName == filter['gameName']) {
          if (e.gameName == "LETTERS_REARRANGE") {
            final currentDay = monthNumber;
            if (monthlyPoint[currentDay] == null ||
                e.maxLevel > monthlyPoint[currentDay]!) {
              monthlyPoint[currentDay] = e.maxLevel;
            }
          } else {
            final currentDay = monthNumber;
            if (monthlyPoint[currentDay] == null ||
                e.score > monthlyPoint[currentDay]!) {
              monthlyPoint[currentDay] = e.score;
            }
          }
        }
      }
    }

    final List<ExpenseData> chartData = [];

    // Create ExpenseData objects from monthly data
    for (int monthNumber = 1; monthNumber <= toDate.month; monthNumber++) {
      chartData.add(
        ExpenseData(
          DateTime(toDate.year,monthNumber,1),
          monthlyPoint[monthNumber] ?? 0,
        ),
      );
    }

    return chartData;
  }

  List<ExpenseData> getChartMonth() {
    return getDataDealinMonths();
  }

  List<ExpenseData> getChartDataWeek() {
    return getDataDealinWeeks();
  }

  List<ExpenseData> getNull() {
    return getDataNull();
  }

  List<ExpenseData> getChartDataDays() {
    return getDataDealinDays();
  }

  void getDateBefore() {
    DateTime nowDate = DateTime.now();
    var dateStr = filterData['toDate'];
    DateTime now = DateTime.fromMillisecondsSinceEpoch(dateStr);
    // DateTime now = DateTime.parse(dateStr);
    int day = now.day;
    int month = now.month;
    int year = now.year;
    runSave = true;

    DateTime startDate = DateTime(year, month, day, 00, 00, 00);
    DateTime endDate = DateTime(year, month, day, 24, 00, 00);

    if (checkMonth == false) {
      startDate = DateTime(now.year, now.month - 1, 1);
      int lastDayOfPreviousMonth = DateTime(now.year, now.month, 0).day;
      endDate = DateTime(now.year, now.month - 1, lastDayOfPreviousMonth);
    } else if (checkMonth == true) {

      startDate = DateTime(now.year - 1, 1, 1);
      endDate = DateTime(now.year - 1, 12, 31);
    }
    if (runSave == true) {
      filterDataBefore['fromDate'] = startDate.millisecondsSinceEpoch;

      filterDataBefore['toDate'] = endDate.millisecondsSinceEpoch;

    }
    setState(() {});
  }

  void onSelectedDate(int index) async {
    DateTime nowDate = DateTime.now();
    var dateStr = filterData['toDate'];
    DateTime now = DateTime.fromMillisecondsSinceEpoch(dateStr);
    // DateTime now = DateTime.parse(dateStr);
    int day = now.day;
    int month = now.month;
    int year = now.year;
    runSave = true;

    DateTime startDate = DateTime(year, month, day, 00, 00, 00);
    DateTime endDate = DateTime(year, month, day, 24, 00, 00);

    if (checkMonth == false) {
      switch (index) {
        case 0:
          startDate = DateTime(now.year, now.month, 1);
          endDate = now;
          break;
        case 1:
          startDate = DateTime(now.year, now.month - 1, 1);
          int lastDayOfPreviousMonth = DateTime(now.year, now.month, 0).day;
          endDate = DateTime(now.year, now.month - 1, lastDayOfPreviousMonth);
          break;

        case 2:
          if (nowDate.month == now.month + 1 && nowDate.year == now.year) {

            startDate = DateTime(now.year, now.month + 1, 1);
            endDate = nowDate;
          } else if (nowDate.year > now.year) {

            startDate = DateTime(now.year, now.month + 1, 1);
            int lastDayOfNextMonth = DateTime(now.year, now.month + 2, 0).day;
            endDate = DateTime(now.year, now.month + 1, lastDayOfNextMonth);
          } else if (nowDate.year == now.year &&
              nowDate.month > now.month + 1) {
            startDate = DateTime(now.year, now.month + 1, 1);
            int lastDayOfNextMonth = DateTime(now.year, now.month + 2, 0).day;
            endDate = DateTime(now.year, now.month + 1, lastDayOfNextMonth);
          } else {

            runSave = false;
            setState(() {});
          }

          break;
      }
    } else if (checkMonth == true) {

      switch (index) {
        case 0:
          startDate = DateTime(now.year, 1, 1);
          endDate = nowDate;
          runSave = true;
          break;
        case 1:
          startDate = DateTime(now.year - 1, 1, 1);
          endDate = DateTime(now.year - 1, 12, 31);
          break;

        case 2:
          if (nowDate.isAfter(DateTime(now.year - 1, 12, 31)) &&
              nowDate.year == now.year + 1) {

            startDate = DateTime(nowDate.year, 1, 1);
            endDate = nowDate;
          } else if (nowDate.isAfter(DateTime(now.year - 1, 12, 31)) &&
              nowDate.year > now.year) {
            startDate = DateTime(now.year + 1, 1, 1);
            endDate = DateTime(now.year + 1, 12, 31);
          } else {

            runSave = false;
            setState(() {});
          }

          break;
      }
    }
    if (runSave == true) {
      filterData['fromDate'] = startDate.millisecondsSinceEpoch;

      filterData['toDate'] = endDate.millisecondsSinceEpoch;
    }
    setState(() {});
  }

  String getAbbreviatedDay(String fullDay) {
    switch (fullDay) {
      case 'Monday':
        return 'T2';
      case 'Tuesday':
        return 'T3';
      case 'Wednesday':
        return 'T4';
      case 'Thursday':
        return 'T5';
      case 'Friday':
        return 'T6';
      case 'Saturday':
        return 'T7';
      case 'Sunday':
        return 'CN';
      default:
        return fullDay; // Return the same day name if it's not recognized
    }
  }

  String getTypeGame(String gameType) {
    switch (gameType) {
      case 'MEMORY':
        return 'Trí Nhớ';
      case 'ATTENTION':
        return 'Tập Trung';
      case 'LANGUAGE':
        return 'Ngôn Ngữ';
      case 'MATH':
        return 'Toán học';
      default:
        return gameType; // Return the same day name if it's not recognized
    }
  }

  String getNameGame(String gameName) {
    switch (gameName) {
      case 'POSITION' ||
            'DIFFERENCE' ||
            'STARTING_LETTER' ||
            'SMALLER_EXPRESSION':
        return 'Trò chơi 1';
      case 'NEW_PICTURE' || 'PAIRING' || 'STARTING_WORD' || 'SUM':
        return 'Trò chơi 2';
      case 'LOST_PICTURE' || 'FISHING' || 'NEXT_WORD':
        return 'Trò chơi 3';
      case 'LETTERS_REARRANGE':
        return 'Trò chơi 4';
      default:
        return gameName; // Return the same day name if it's not recognized
    }
  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // var x = getServiceTypeIcon(widget.chartType!);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
                Radius.circular(20.0)), // Set rounded corner radius
          ),
          // width: 500,
          // height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius:   BorderRadius.all(
                  Radius.circular(6.0),
                ),
                color: Colors.white,
              ),
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ButtonVertical(
                          buttonTitles: buttonTitles,
                          height: 50,
                          selectedButtonIndex: _selectedGameData,
                          onButtonTap: _handleButtonTap,
                        ),
                      ),
                      if (_selectedGameData == 0)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ButtonVertical(
                            buttonTitles: buttonTitlesGame1,
                            height: 50,
                            selectedButtonIndex: _selectedGame1,
                            onButtonTap: _handleButtonTapGame1,
                          ),
                        ),
                      if (_selectedGameData == 1)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ButtonVertical(
                            buttonTitles: buttonTitlesGame2,
                            height: 50,
                            selectedButtonIndex: _selectedGame2,
                            onButtonTap: _handleButtonTapGame2,
                          ),
                        ),
                      if (_selectedGameData == 2)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ButtonVertical(
                            buttonTitles: buttonTitlesGame3,
                            height: 50,
                            selectedButtonIndex: _selectedGame3,
                            onButtonTap: _handleButtonTapGame3,
                          ),
                        ),
                      if (_selectedGameData == 3)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ButtonVerticalCenter(
                            buttonTitles: buttonTitlesGame4,
                            height: 50,
                            selectedButtonIndex: _selectedGame4,
                            onButtonTap: _handleButtonTapGame4,
                          ),
                        ),
                      SizedBox(
                        height: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Spacer(),
                            Flexible(
                                flex: 2,
                                child: PageButton(
                                  Icons.arrow_back_ios_new,
                                  backgroundColor: Colors.white,
                                  disable: false,
                                  onTap: () async {
                                    onSelectedDate(1);
                                    await initData();
                                    setState(() {});
                                  },
                                  fontColor: AppColors.primaryColor,
                                  border: Colors.grey,
                                )),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: GestureDetector(
                                    onTap: () => {},
                                    child: SizedBox(
                                      width: 140,
                                      child: CardTime(
                                        backgroundColor: '#f7f7f7'.toColor(),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              (filterData['fromDate'] as int)
                                                  .toDateString(
                                                      format: 'dd/MM/yyyy'),
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black54),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Flexible(
                                  child: GestureDetector(
                                    onTap: () {},
                                    child: SizedBox(
                                      width: 140,
                                      child: CardTime(
                                        backgroundColor: '#f7f7f7'.toColor(),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              (filterData['toDate'] as int)
                                                  .toDateString(
                                                      format: 'dd/MM/yyyy'),
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black54),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Flexible(
                                flex: 2,
                                child: PageButton(
                                  Icons.arrow_forward_ios,
                                  backgroundColor: Colors.white,
                                  disable: !runSave,
                                  onTap: () async {
                                    onSelectedDate(2);
                                    await initData();
                                    setState(() {});
                                  },
                                  fontColor: AppColors.primaryColor,
                                  border: Colors.grey,
                                )),
                            const Spacer(),
                          ],
                        ),
                      ),

                      _game.isNotEmpty
                          ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: 10,),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0,bottom: 15),
                                  child: Text(!levelLg4
                                      ? 'Điểm số cao nhất'
                                      : 'Cấp độ cao nhất', style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20),),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0,bottom: 10),
                                  child: Row(
                                    // crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "$nowMaxPoint",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 22,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      const SizedBox(width: 50),
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            (percent >= 0) ? const Icon(Icons.arrow_upward, size: 18, color: Colors.green) :const  Icon(Icons.arrow_downward_sharp, size: 18, color: Colors.red),
                                            Text(
                                              "${(percent >= 0 ? (percent * 100) : (percent * -1 * 100)).toStringAsFixed(2)} % ",
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 14,
                                                color: percent >= 0 ? Colors.green : Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                                Center(
                                    child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height - 350,

                                  // width:
                                  // MediaQuery.of(context).size.width*2,
                                  child: SfCartesianChart(

                                    legend: const Legend(
                                        isVisible: true,
                                        position: LegendPosition.bottom),
                                    tooltipBehavior: _tooltipBehavior,
                                    // trackballBehavior: _trackballBehavior,
                                    zoomPanBehavior: _zoomPanBehavior,
                                    primaryYAxis: NumericAxis(
    // anchorRangeToVisiblePoints: false,
                                      // labelFormat: '{value} M',
                                      numberFormat: NumberFormat.compact(),
                                      minimum: 0,
                                      // maximum: maxiChart +
                                      //     maxiChart *
                                      //         0.05,
                                    ),
                                    series: <ChartSeries>[
                                      SplineSeries<ExpenseData, DateTime>(
                                        color: Colors.blue,
                                        splineType: SplineType.monotonic,
                                        dataSource: _chartData,
                                        xValueMapper: (ExpenseData exp, _) =>
                                            exp.expenseCategory,
                                        yValueMapper: (ExpenseData exp, _) =>
                                            exp.total,
                                        name: 'Số điểm đạt được cao nhất',
    // dataLabelSettings: DataLabelSettings(isVisible: true),
    // enableTooltip: true,
                                        markerSettings: const MarkerSettings(
                                          isVisible: true,
                                        )
                                      ),
                                    ],
                                    primaryXAxis: DateTimeAxis(
                                        edgeLabelPlacement: EdgeLabelPlacement.shift,
                                        dateFormat: checkMonth ? DateFormat.M() : DateFormat.d(),
                                        intervalType: checkMonth ? DateTimeIntervalType.months: DateTimeIntervalType.days,
                                        interactiveTooltip: const InteractiveTooltip(enable: false)),
                                  ),
                                )),
                              ],
                            )
                          : Center(
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height - 150,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    loadingDataChart == true
                                        ? LoadingDot()
                                        : ErrorsNoti(
                                            text:
                                                "Không có dữ liệu \n trong thời gian này !",
                                            style: const TextStyle(
                                                color: Colors.black54,
                                                fontSize: 20),
                                          )
                                  ],
                                ),
                              ),
                            ),
                      Center(
                        child: Container(
                          width: 242,
                          height: 35,
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(6.0),
                            ),
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.black,
                              width: 1.0,
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(6.0),
                                    topLeft: Radius.circular(6.0),
                                  ),
                                  color: checkDays == true
                                      ? AppColors.primaryColor
                                      : LightColors.kLightYellow,
                                ),
                                width: 80,
                                child: TextButton(
                                    onPressed: () async {
                                      checkMonth = false;
                                      checkDays = true;
                                      checkWeek = false;
                                      onSelectedDate(0);
                                      await initData();
                                      _chartData = getChartDataDays();
                                      setState(() {});
                                    },
                                    child: Text(
                                      "Ngày",
                                      style: TextStyle(
                                          color: checkDays == true
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.w600),
                                    )),
                              ),
                              Container(
                                width: 80,
                                decoration: BoxDecoration(
                                  color: checkWeek == true
                                      ? AppColors.primaryColor
                                      : LightColors.kLightYellow,
                                  border: const Border(
                                    left: BorderSide(
                                      color: Colors.black,
                                      width: 1.0,
                                    ),
                                    right: BorderSide(
                                      color: Colors.black,
                                      width: 1.0,
                                    ),
                                  ),
                                ),
                                child: TextButton(
                                    onPressed: () async {
                                      checkMonth = false;
                                      checkDays = false;
                                      checkWeek = true;
                                      onSelectedDate(0);
                                      await initData();
                                      _chartData = getChartDataWeek();
                                      setState(() {});
                                    },
                                    child: Text(
                                      "Tuần",
                                      style: TextStyle(
                                          color: checkWeek == true
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.w600),
                                    )),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    bottomRight: Radius.circular(6.0),
                                    topRight: Radius.circular(6.0),
                                  ),
                                  color: checkMonth == true
                                      ? AppColors.primaryColor
                                      : LightColors.kLightYellow,
                                ),
                                width: 80,
                                child: TextButton(
                                    onPressed: () async {
                                      checkMonth = true;
                                      checkDays = false;
                                      checkWeek = false;

                                      onSelectedDate(0);
                                      await initData();
                                      _chartData = getChartMonth();
                                      setState(() {});
                                    },
                                    child: Text(
                                      "Tháng",
                                      style: TextStyle(
                                          color: checkMonth == true
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.w600),
                                    )),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 15, left: 15),
                        child: ButtonSubmit(
                          "Dữ liệu chi tiết trong tuần",
                          fontColor: Colors.white,
                          onTap: () {
                            showPopupInfo(context, _game, filter['gameType'],
                                filter['gameName']);
                          },
                        ),
                      ),
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleButtonTap(int selectedIndex) async {
    _selectedGameData = selectedIndex;
    setState(() {});
    await initData();
  }

  Future<void> _handleButtonTapGame1(int selectedIndex) async {
    setState(() {
      _selectedGame1 = selectedIndex;
    });
    await initData();
  }

  Future<void> _handleButtonTapGame2(int selectedIndex) async {
    setState(() {
      _selectedGame2 = selectedIndex;
    });
    await initData();
  }

  Future<void> _handleButtonTapGame3(int selectedIndex) async {
    setState(() {
      _selectedGame3 = selectedIndex;
    });
    await initData();
  }

  Future<void> _handleButtonTapGame4(int selectedIndex) async {
    setState(() {
      _selectedGame4 = selectedIndex;
    });
    await initData();
  }

  Future<BuildContext?> showPopupInfo(BuildContext context,
      List<GameData> _game, String gameType, String gameName) {
    // final List<ChartData> chartData = <ChartData>[
    //   ChartData("11/9/2023", 11),
    //   ChartData("12/9/2023", 13),
    //   ChartData("13/9/2023", 15),
    //   ChartData("14/9/2023", 12),
    //   // ChartData("2007", 29, 36, 49, 59, 69),
    //   // ChartData("2008", 28, 38, 48, 68, 78),
    //   // ChartData("2009", 35, 54, 64, 74, 84),
    //   // ChartData("2010", 37, 57, 67, 77, 87),
    //   // ChartData("2011", 50, 70, 80, 85, 90),
    // ];
    //
    // DateTime fromDate = DateTime.fromMillisecondsSinceEpoch(filterData['fromDate']);
    // DateTime toDate = DateTime.fromMillisecondsSinceEpoch(filterData['toDate']);

    final now = DateTime.now();
    DateTime monday = DateTime(now.year, now.month, now.day);
    monday = monday.subtract(Duration(days: now.weekday - 1));
    int difpoint = 0;
    int pointNow = 0;
    final List<GameData> gamePlaysInRange = [];
    Map<String, int> weeklyMaxData = {
      'T2': 0,
      'T3': 0,
      'T4': 0,
      'T5': 0,
      'T6': 0,
      'T7': 0,
      'CN': 0,
    };

    for (var e in _game) {
      DateTime checkDay = DateTime.fromMillisecondsSinceEpoch(e.createdDate);

      if (checkDay.millisecondsSinceEpoch >= monday.millisecondsSinceEpoch &&
          checkDay.millisecondsSinceEpoch <= now.millisecondsSinceEpoch) {
        if (e.gameName == filter['gameName']) {
          gamePlaysInRange.add(e);
          String dayName = DateFormat('EEEE').format(checkDay);
          String abbreviatedDay = getAbbreviatedDay(dayName);

          if (e.gameName == "LETTERS_REARRANGE") {
            if (e.maxLevel > weeklyMaxData[abbreviatedDay]!) {
              weeklyMaxData[abbreviatedDay] = e.maxLevel;
              pointNow = e.maxLevel;
            }
          } else {
            if (e.score > weeklyMaxData[abbreviatedDay]!) {
              weeklyMaxData[abbreviatedDay] = e.score;
              pointNow = e.score;
            }
          }
        }
      }
    }

    final List<Date> chartData = weeklyMaxData.entries.map((entry) {
      return Date(entry.key, entry.value);
    }).toList();

    if (gameName == 'LETTERS_REARRANGE') {
      gamePlaysInRange.sort((a, b) => b.maxLevel.compareTo(a.maxLevel));
    } else {
      gamePlaysInRange.sort((a, b) => b.score.compareTo(a.score));
    }
    gamePlaysInRange.sort((a, b) => b.score.compareTo(a.score));

    // if (pointNow != 0 && weeklyMaxData["T2"] != 0) {
      difpoint = pointNow - weeklyMaxData["T2"]!;
    // }
    return showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: true,
        context: context,
        // isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => DraggableScrollableSheet(
              initialChildSize: 0.4,
              minChildSize: 0.2,
              maxChildSize: 0.75,
              expand: false,
              builder: (_, controller) => Container(
                height: MediaQuery.of(context).size.height * 0.75,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:   BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    topRight: Radius.circular(25.0),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 60, // Độ rộng của hình chữ nhật
                        height: 10, // Chiều cao của hình chữ nhật
                        decoration: BoxDecoration(
                          color: Colors.grey, // Màu nền của hình chữ nhật
                          borderRadius:
                              BorderRadius.circular(20), // Bán kính bo tròn
                        ),
                      ),
                    ),
                    Wrap(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Center(
                            child: Text(
                              "${getNameGame(gameName)} ${getTypeGame(gameType)}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 20),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(15.0),
                        ),
                      ],
                    ),
                    Expanded(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: SingleChildScrollView(
                            // physics: NeverScrollableScrollPhysics(),
                            // shrinkWrap: true,
                            controller: controller,
                            child: Column(
                              children: [
                                Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Center(
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text:
                                                  "Điểm trò chơi ${getNameGame(gameName) }trong ${getTypeGame(gameType)} của bạn đã ",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15,
                                                  color: Colors.black),
                                            ),
                                            TextSpan(
                                              text: difpoint < 0
                                                  ? "Giảm $difpoint điểm"
                                                  : "Tăng $difpoint điểm",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15,
                                                  color: difpoint < 0
                                                      ? Colors.red
                                                      : Colors.green),
                                            ),
                                            const TextSpan(
                                              text: " so với lúc đầu tuần",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15,
                                                  color: Colors.black),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )),
                                Center(
                                    child: SfCartesianChart(
                                      title: ChartTitle(
                                          text:
                                              'Tổng số lần chơi ${gamePlaysInRange.length}'),
                                      legend: const Legend(
                                          isVisible: true,
                                          position: LegendPosition.bottom),
                                      tooltipBehavior: _tooltipBehavior,
                                      series: <ChartSeries>[
                                        ColumnSeries<Date, String>(
                                            color: Colors.blue,
                                            dataSource: chartData,
                                            dashArray: <double>[5, 5],
                                            xValueMapper: (Date exp, _) =>
                                                exp.time,
                                            yValueMapper: (Date exp, _) =>
                                                exp.total,
                                            name: 'Số điểm đạt được cao nhất',
                                            markerSettings: const MarkerSettings(
                                              isVisible: true,
                                            )),
                                      ],
                                      primaryXAxis: CategoryAxis(),
                                    )),
                                Divider(
                                  thickness: 1.0,
                                  color: Colors.grey[300],
                                ),
                                gamePlaysInRange.isNotEmpty
                                    ? Center(
                                        child: DataTable(
                                          columns: const [
                                            DataColumn(label: Text('Hạng')),
                                            DataColumn(label: Text('Ngày')),
                                            DataColumn(label: Text('Điểm')),
                                          ],
                                          rows: gamePlaysInRange
                                              .take(20)
                                              .map((data) {
                                            final rank = gamePlaysInRange
                                                    .indexOf(data) +
                                                1; // Xếp hạng dựa trên vị trí trong danh sách

                                            Widget rankWidget;
                                            if (rank == 1) {
                                              rankWidget = const Icon(Icons.star,
                                                  color: Colors.yellow);
                                            } else {
                                              rankWidget =
                                                  Text(rank.toString());
                                            }

                                            return DataRow(cells: [
                                              DataCell(rankWidget),
                                              DataCell(Text(data.createdDate
                                                  .toDateString())),
                                              gameName != 'LETTERS_REARRANGE'
                                                  ? DataCell(Text(
                                                      data.score.toString()))
                                                  : DataCell(Text(
                                                      data.maxLevel.toString()))
                                            ]);
                                          }).toList(),
                                        ),
                                      )
                                    : ErrorsNoti(
                                        text:
                                            "Bạn chưa chơi game \n nào trong tuần này !",
                                        style: const TextStyle(
                                            color: Colors.black54,
                                            fontSize: 17),
                                      )
                              ],
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }
}

class ChartData {
  ChartData(
    this.x,
    this.series0,
  );

  final DateTime x;
  final double series0;
}

class ExpenseData {
  ExpenseData(
      this.expenseCategory,
      this.total,
      );

  final DateTime expenseCategory;
  final num total;

  Map<String, dynamic> toJson() {
    return {
      'expenseCategory': expenseCategory,
      'total': total,
    };
  }

  @override
  String toString() {
    return 'ExpenseData { expenseCategory: $expenseCategory, total: $total }';
  }
}
class Date {
  Date(
      this.time,
      this.total,
      );

  final String time;
  final num total;

  Map<String, dynamic> toJson() {
    return {
      'expenseCategory': time,
      'total': total,
    };
  }

  @override
  String toString() {
    return 'ExpenseData { expenseCategory: $time, total: $total }';
  }
}