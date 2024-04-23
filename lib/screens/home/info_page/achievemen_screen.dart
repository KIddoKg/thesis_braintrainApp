// import 'dart:html';
import 'dart:convert';
import 'dart:io';
import 'package:animations/animations.dart';
import 'package:brain_train_app/helper/formater.dart';
import 'package:brain_train_app/shared/app_styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'package:brain_train_app/models/achievement_model.dart';
import 'package:brain_train_app/models/objective_model.dart';
import 'package:brain_train_app/models/user_model.dart';
import '../../../services/services.dart';
import '../../../shared/light_colors.dart';
import '../../../shared/share_widgets.dart';

class AchievementScreen extends StatefulWidget {
  const AchievementScreen({super.key});

  @override
  State<AchievementScreen> createState() => _AchievementScreenState();
}

class _AchievementScreenState extends State<AchievementScreen> {
  List<Objective> objRoot = [];
  List<Objective> filteredObjectives = [];

  @override
  void initState() {
    dataInit();
    initData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  late AnimationController _controller;
  final String jsonFilePath = 'lib/data/data_achievement/achievement.json';
  late List<Achievement> achievementList;

  Future<void> initData() async {
    var res = await Services.instance.setContext(context).getOBJ();
    if (res != null) {
      var data = res.castList<Objective>();
      objRoot = data;
      Map<String, int> maxLevelMap = {};

      // Lọc và cập nhật maxLevelMap
      // for (var objective in objRoot) {
      //   final objectiveType = objective.objectiveType;
      //   final level = objective.level;
      //   final status = objective.achieved;
      //
      //   if (!maxLevelMap.containsKey(objectiveType) ||
      //       level > maxLevelMap[objectiveType]! && status == true) {
      //     maxLevelMap[objectiveType] = level;
      //   }
      // }
      //
      // // Lọc ra những Objective có level cao nhất cho từng objectiveType
      // filteredObjectives = objRoot
      //     .where((objective) =>
      // objective.level == maxLevelMap[objective.objectiveType])
      //     .toList();
      //
      // print(filteredObjectives);
      filteredObjectives = objRoot;
    }

    // Tạo một Map để lưu trữ level cao nhất cho mỗi objectiveType

    setState(() {});
  }

  Future<void> dataInit() async {
    achievementList = [];
    await loadAchievementsFromJson();
  }

  Future<void> loadAchievementsFromJson() async {
    try {
      final String jsonString = await rootBundle
          .loadString('lib/data/data_achievement/achievement.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final List<dynamic> achievementData = jsonData['achievements'];

      if (achievementData != null) {
        final List<Achievement> loadedAchievements =
            achievementData.map((item) => Achievement.fromJson(item)).toList();

        setState(() {
          achievementList = loadedAchievements;
        });
      } else {
        setState(() {
          achievementList = <Achievement>[];
        });
      }
    } catch (error) {

      setState(() {
        achievementList = <Achievement>[];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
          color: Colors.white,
        ),
        child: CustomScrollView(
          slivers: [
            filteredObjectives.isNotEmpty
                ? SliverToBoxAdapter(
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: filteredObjectives.length,
                      itemBuilder: (context, index) {
                        Objective obj = filteredObjectives[index];
                        // int totalPrice = products.fold(0, (sum, product) => sum + (product.quantity * product.price));
                        return GestureDetector(
                          onTap: () {
                            // showPopupInfoAchievement(
                            //     context, objRoot,obj.objectiveType);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(
                                top: 20, right: 15, left: 15),
                            // height: double.infinity,
                            // width: double.infinity,
                            decoration: BoxDecoration(
                              color: obj.achieved ? AppColors.primaryColor : Colors.grey,
                              borderRadius:

                                  const BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Column(
                                        children: [
                                          SizedBox(
                                            width: 100,
                                            child: SizedBox(
                                              width: 75,
                                              height: 75,
                                              child: Opacity(
                                                opacity: obj.achieved ?1: 0.1,
                                                child: Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  CircleAvatar(
                                                    radius: 40,
                                                    backgroundImage: AssetImage(
                                                      "assets/Achievement/${obj.imageTag}.jpg",
                                                    ),
                                                  ),
                                                  if(!obj.achieved)
                                                  const Icon(
                                                    Icons.lock, // Replace 'your_icon' with the desired icon
                                                    color: Colors.black, // Set the icon color
                                                    size: 30, // Set the icon size
                                                  ),
                                                ],
                                              ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Center(
                                            child: Text("Cấp độ ${obj.level}",style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w800),),
                                          )
                                        ],
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8.0, left: 8, top: 8),
                                              child: Text(
                                                obj.title,
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8.0,
                                                  left: 8,
                                                  bottom: 8),
                                              child: Text(
                                                obj.description,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 17,
                                                ),
                                              ),
                                            ),
                                            if(obj.achieved)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8.0,
                                                  left: 8,
                                                  bottom: 8),
                                              child: Text(
                                                obj.achievedDate.toDateString(),
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 17,
                                                ),
                                              ),
                                            ),
                                            // Padding(
                                            //   padding: EdgeInsets.all(8),
                                            //   child: Row(
                                            //     children: [
                                            //       new LinearPercentIndicator(
                                            //         padding: EdgeInsets.zero,
                                            //         width: MediaQuery.of(context)
                                            //                 .size
                                            //                 .width -
                                            //             230,
                                            //         animation: true,
                                            //         lineHeight: 10.0,
                                            //         animationDuration: 1000,
                                            //         percent: achievement
                                            //                     .percent !=
                                            //                 0
                                            //             ? achievement.percent /
                                            //                 achievement.maxCount
                                            //             : 0,
                                            //         barRadius:
                                            //             const Radius.circular(16),
                                            //         progressColor: LightColors
                                            //             .kLightPercentOP,
                                            //         backgroundColor:
                                            //             LightColors.kLightPercent,
                                            //       ),
                                            //       SizedBox(
                                            //         width: 10,
                                            //       ),
                                            //       Text(
                                            //           "${achievement.percent}/${achievement.maxCount}")
                                            //     ],
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : const SliverToBoxAdapter(
                    child: SizedBox(),
                  )
          ],
        ),
      ),
    );
  }

  Future<BuildContext?> showPopupInfoAchievement(
      BuildContext context, List<Objective> obj, String typeObj) {
    List<Objective> objtest = [];
    for (var e in obj) {
      if (e.objectiveType == typeObj) {
        objtest.add(e);
      }
    }

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
                  borderRadius: BorderRadius.only(
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
                    const Wrap(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Center(
                            child: Text(
                              "Ngày đạt đươc thành tựu",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 20),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(15.0),
                        ),
                      ],
                    ),
                    Expanded(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: CustomScrollView(
                          controller: controller,
                          slivers: [
                            objtest.isNotEmpty
                                ? SliverToBoxAdapter(
                                    child: ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: objtest.length,
                                      itemBuilder: (context, index) {
                                        Objective objData = objtest[index];
                                        return Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  Column(
                                                    children: [
                                                      const SizedBox(
                                                        width: 100,
                                                        child: SizedBox(
                                                          width: 75,
                                                          height: 75,
                                                          child: CircleAvatar(
                                                            radius: 21,
                                                            backgroundColor:
                                                                Color(
                                                                    0xff37EBBC),
                                                            child: CircleAvatar(
                                                              radius: 18,
                                                              backgroundImage:
                                                                  AssetImage(
                                                                "assets/Achievement/1.jpg",
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Center(
                                                        child: Text(
                                                            "Levels ${objData.level}"),
                                                      )
                                                    ],
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  right: 8.0,
                                                                  left: 8,
                                                                  top: 8),
                                                          child: Text(
                                                            objData.title,
                                                            style: const TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 18,
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  right: 8.0,
                                                                  left: 8,
                                                                  bottom: 8),
                                                          child: Text(
                                                            objData.description,
                                                            style: const TextStyle(
                                                              color: Colors.red,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 17,
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  right: 8.0,
                                                                  left: 8,
                                                                  bottom: 8),
                                                          child: Text(
                                                            "${objData.achievedDate}",
                                                            style: const TextStyle(
                                                              color: Colors.red,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 17,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        );
                                      },
                                    ),
                                  )
                                : const SliverToBoxAdapter(
                                    child: SizedBox(
                                      child: Center(
                                        child: Text(
                                            "Bạn chưa mở khoá thành tựu này"),
                                      ),
                                    ),
                                  )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ));
  }
}
