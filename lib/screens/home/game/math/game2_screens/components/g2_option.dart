import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../../controllers/math2_controller.dart';

class Option extends StatelessWidget {
  final String text;
  final int index;
  final VoidCallback press;

  const Option({
    super.key,
    required this.text,
    required this.index,
    required this.press,
  });

  @override
  Widget build(BuildContext context) {
    double scrWidth = MediaQuery.of(context).size.width;

    // set the width of an option
    //* formula: final width = (scrWidth - spacingAroundColumns) / noOfCols;
    final double optWidth = (scrWidth - 100) / 2;

    return GetBuilder<Math2Controller>(
      init: Math2Controller(),
      builder: (controller) {
        Color getTheRightColor() {
          if (!controller.isAnswered &&
              controller.optionsChosen.contains(index)) {
            return const Color.fromARGB(255, 91, 90, 90);
          }
          if (controller.isAnswered) {
            if (controller.correctAns.contains(index)) {
              return Colors.green;
            } else if (controller.selectedAns.contains(index) &&
                !controller.equal(
                    controller.selectedAns, controller.correctAns)) {
              return Colors.red;
            }
          }
          return const Color.fromARGB(255, 146, 146, 146);
        }

        IconData getTheRightIcon() {
          if (getTheRightColor() == Colors.red) {
            return Icons.close;
          } else if (getTheRightColor() == Colors.green) {
            return Icons.done;
          } else {
            return Icons.question_mark_sharp;
          }
        }

        Color fillOptionColor() {
          if (controller.isAnswered) {
            if (controller.correctAns.contains(index)) {
              return const Color.fromARGB(255, 233, 241, 231);
            } else if (controller.selectedAns.contains(index) &&
                !controller.equal(
                    controller.selectedAns, controller.correctAns)) {
              return const Color.fromARGB(255, 245, 227, 227);
            }
          }
          return Colors.white;
        }

        return InkWell(
          onTap: press,
          child: Container(
            width: optWidth,
            margin: const EdgeInsets.only(top: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: fillOptionColor(),
              border: Border.all(color: getTheRightColor()),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  text,
                  style: TextStyle(
                    color: getTheRightColor(),
                    fontSize: 22,
                  ),
                ),
                Container(
                  height: 26,
                  width: 26,
                  decoration: BoxDecoration(
                    color: getTheRightColor() ==
                            const Color.fromARGB(255, 146, 146, 146)
                        ? Colors.transparent
                        : getTheRightColor(),
                    border: Border.all(
                      color: getTheRightColor(),
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Icon(
                    getTheRightIcon(),
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
