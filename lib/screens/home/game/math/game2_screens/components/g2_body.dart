import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/math2_controller.dart';
import 'g2_progress_bar.dart';
import 'g2_question_card.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    Math2Controller _controller = Get.put(Math2Controller());
    final List<List<int>> questionSet = _controller.getQuestions();
    double scrHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/math/medal.png',
                            scale: 2.1,
                          ),
                          Obx(
                            () => Text.rich(
                              TextSpan(
                                text: ' ĐIỂM SỐ ',
                                style: const TextStyle(
                                  color: Color.fromRGBO(139, 148, 188, 1),
                                  fontSize: 20,
                                ),
                                children: [
                                  TextSpan(
                                    text: "${_controller.getPoint}",
                                    style: const TextStyle(
                                      color: Color.fromRGBO(139, 148, 188, 1),
                                      fontSize: 30,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/math/flag.png',
                            scale: 1.3,
                          ),
                          Obx(
                            () => Text.rich(
                              TextSpan(
                                text: ' CẤP ĐỘ ',
                                style: const TextStyle(
                                  color: Color.fromRGBO(139, 148, 188, 1),
                                  fontSize: 20,
                                ),
                                children: [
                                  TextSpan(
                                    text: "${_controller.getLevel}",
                                    style: const TextStyle(
                                      color: Color.fromRGBO(255, 255, 255, 1.0),
                                      fontSize: 30,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: scrHeight / 80),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: ProgressBar(),
              ),
              SizedBox(height: scrHeight / 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Obx(
                  () => Text.rich(
                    TextSpan(
                      text: "Câu hỏi ${_controller.questionNumber}",
                      style: const TextStyle(
                        color: Color.fromRGBO(139, 148, 188, 1),
                        fontSize: 34,
                      ),
                      children: [
                        TextSpan(
                          text: "/${questionSet.length}",
                          style: const TextStyle(
                            color: Color.fromRGBO(139, 148, 188, 1),
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  // block swipe to the next question
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _controller.pageController,
                  onPageChanged: _controller.updateQuestionNumber,
                  itemCount: questionSet.length,
                  itemBuilder: (context, index) => QuestionCard(
                    question: questionSet[index],
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
