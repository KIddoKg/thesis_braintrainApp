import 'dart:math';

class Game2DataGenerator {
  List<int> generateOptions(int sum, int numOfOptions) {
    // to avoid duplicated element
    Set<int> optionsSet = {};

    // generate the seed (1 of 2 correct answers)
    int num = Random().nextInt(sum - 1) + 1;

    optionsSet.add(num);
    do {
      int element = Random().nextInt(sum - 1) + 1;
      optionsSet.add(element);

      // to ensure that the question only has 1 correct answer
      if (!onlyOneAns(optionsSet.toList(), sum)) {
        optionsSet.remove(element);
      }
    } while (optionsSet.length != numOfOptions - 1);

    // for 5 + 5 situation
    List<int> optionsList = optionsSet.toList();
    optionsList.add(sum - num);

    return shuffle(optionsList);
  }

  bool onlyOneAns(List<int> optionsList, int sum) {
    for (int i = 0; i < optionsList.length - 1; i++) {
      for (int j = i + 1; j < optionsList.length; j++) {
        if (optionsList[i] + optionsList[j] == sum) {
          return false;
        }
      }
    }
    return true;
  }

  List<int> shuffle(List<int> list) {
    // start from the last element and swapp one by one
    for (int i = list.length - 1; i > 0; i--) {
      // pick a random index from 0 to i
      int j = Random().nextInt(i + 1);

      int temp = list[i];
      list[i] = list[j];
      list[j] = temp;
    }
    return list;
  }
}
