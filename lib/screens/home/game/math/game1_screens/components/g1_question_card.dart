import "package:flutter/material.dart";
import "package:get/get.dart";

import '../../../../../../viewModel/data/data_math/math1_data_generator.dart';
import '../../controllers/math1_controller.dart';

import 'g1_option.dart';

class QuestionCard extends StatelessWidget {
  final List<Pair> question;

  const QuestionCard({
    Key? key,
    required this.question,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Math1Controller _controller = Get.put(Math1Controller());
    double scrHeight = MediaQuery.of(context).size.height;

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 30),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          const Text(
            'Biểu thức nào có giá trị bé hơn?',
            style: TextStyle(
              color: Color.fromRGBO(16, 16, 16, 1),
              fontSize: 22,
            ),
          ),
          SizedBox(height: scrHeight / 70),
          ...List.generate(
            question.length,
            (index) => Option(
              index: index,
              text: question[index].exp,
              press: () => {
                // only choose one option at a time
                _controller.isAnswered == false
                    ? _controller.checkAns(question, index)
                    : null,
              },
            ),
          ),
        ],
      ),
    );
  }
}
