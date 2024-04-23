import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../viewModel/data/data_math/math1_data_generator.dart';
import '../../controllers/math1_controller.dart';

import 'g1_question_card.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    Math1Controller _questionController = Get.put(Math1Controller());
    final List<List<Pair>> questionSet = _questionController.getQuestions();
    double scrHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: Column(
                        children: [
                          //! display total point
                          Row(
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
                                        text: "${_questionController.getPoint}",
                                        style: const TextStyle(
                                          color:
                                              Color.fromRGBO(139, 148, 188, 1),
                                          fontSize: 30,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          //! display play time
                          Row(
                            children: [
                              Image.asset(
                                'assets/math/clock.png',
                                scale: 1,
                              ),
                              Obx(
                                () => Text.rich(
                                  TextSpan(
                                    text: ' THỜI GIAN CÒN LẠI ',
                                    style: const TextStyle(
                                      color: Color.fromRGBO(139, 148, 188, 1),
                                      fontSize: 20,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: "${_questionController.timeLeft}",
                                        style: const TextStyle(
                                          color:
                                              Color.fromRGBO(139, 148, 188, 1),
                                          fontSize: 30,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: scrHeight / 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Obx(
                  () => Text.rich(
                    TextSpan(
                      text: "Câu hỏi ${_questionController.questionNumber}",
                      style: const TextStyle(
                        color: Color.fromRGBO(139, 148, 188, 1),
                        fontSize: 34,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  // block swipe to the next question
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _questionController.pageController,
                  onPageChanged: _questionController.updateQuestionNumber,
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
