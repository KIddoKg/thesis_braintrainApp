import "package:flutter/material.dart";
import "package:get/get.dart";

import '../../controllers/math2_controller.dart';
import 'g2_option.dart';

class QuestionCard extends StatelessWidget {
  final List<int> question;

  const QuestionCard({
    Key? key,
    required this.question,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Math2Controller _controller = Get.put(Math2Controller());
    double scrHeight = MediaQuery.of(context).size.height;

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 15, 20, 30),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          Text(
            'Hai số nào dưới đây có tổng bằng ${_controller.getSum}?',
            style: const TextStyle(
              color: Color.fromRGBO(16, 16, 16, 1),
              fontSize: 22,
            ),
          ),
          SizedBox(height: scrHeight / 100),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 20,
            children: List.generate(
              question.length,
              (index) => Option(
                index: index,
                text: question[index].toString(),
                press: () => {
                  _controller.optionsChosen.add(index),
                  if (_controller.optionsChosen.length == 2)
                    {
                      if (_controller.optionsChosen.elementAt(0) ==
                          _controller.optionsChosen.elementAt(1))
                        {
                          _controller.optionsChosen.clear(),
                        }
                      else
                        {
                          _controller.checkAns(
                              question, _controller.optionsChosen),
                        }
                    },
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
