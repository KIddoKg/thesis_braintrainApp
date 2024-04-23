import 'dart:math';

class Math1DataGenerator {
  final List<String> listOfOps = ['+', '-', 'x', ':'];

  Pair oneNumExp() {
    int num = Random().nextInt(100) + 1;
    return Pair(num.toString(), num);
  }

  Pair twoNumExp() {
    var op = listOfOps[Random().nextInt(listOfOps.length)];

    int num1 = 1;
    int num2 = 1;
    late int result;

    if (op == '+') {
      num1 = Random().nextInt(21) + 10;
      num2 = Random().nextInt(9) + 1;
      result = num1 + num2;
    }

    if (op == '-') {
      num1 = Random().nextInt(21) + 10;
      num2 = Random().nextInt(9) + 1;
      result = num1 - num2;
    }

    if (op == 'x') {
      num1 = Random().nextInt(9) + 1;
      num2 = Random().nextInt(8) + 2;
      result = num1 * num2;
    }

    if (op == ':') {
      // check if the dividend is an prime number
      do {
        num1 = Random().nextInt(96) + 4;
        num2 = Random().nextInt(8) + 2;
      } while (isPrime(num1));

      // to ensure that dividend % divisor == 0 and dividend != divisor
      if (num1 % num2 != 0 || num1 == num2) {
        for (int i = 9; i > 1; i--) {
          if (num1 % i == 0) {
            num2 = i;
            break;
          }
        }
      }

      result = num1 ~/ num2;
    }
    return Pair('$num1 $op $num2', result);
  }

  Pair get generateTwoNumExp => twoNumExp();

  Pair threeNumExp() {
    var op = listOfOps[Random().nextInt(listOfOps.length)];

    int num = 1;
    late int result;

    Pair genPrvTwoNumExp = Pair('', 0);
    String twoNumExp;
    int prvResult;

    if (op == '+') {
      genPrvTwoNumExp = generateTwoNumExp;
      prvResult = genPrvTwoNumExp.value;
      num = Random().nextInt(9) + 1;
      result = prvResult + num;
    }

    if (op == '-') {
      do {
        genPrvTwoNumExp = generateTwoNumExp;
        prvResult = genPrvTwoNumExp.value;
        num = Random().nextInt(9) + 1;
      } while (prvResult < num);
      result = prvResult - num;
    }

    if (op == 'x') {
      do {
        genPrvTwoNumExp = generateTwoNumExp;
        prvResult = genPrvTwoNumExp.value;
        num = Random().nextInt(8) + 2;
      } while (prvResult * num >= 100);
      result = prvResult * num;
    }

    if (op == ':') {
      // check if the dividend is an prime number
      do {
        genPrvTwoNumExp = generateTwoNumExp;
        prvResult = genPrvTwoNumExp.value;
        num = Random().nextInt(8) + 2;
      } while (isPrime(prvResult));

      // to ensure that dividend % divisor == 0
      if (prvResult % num != 0 || prvResult == num) {
        for (int i = 9; i > 1; i--) {
          if (prvResult % i == 0) {
            num = i;
            break;
          }
        }
      }
      result = prvResult ~/ num;
    }
    twoNumExp = genPrvTwoNumExp.exp;

    return Pair('($twoNumExp) $op $num', result);
  }

  Pair get generateThreeNumExp => threeNumExp();

  Pair fourNumExp() {
    var op = listOfOps[Random().nextInt(listOfOps.length)];

    int num = 1;
    late int result;

    Pair genPrvThreeNumExp = Pair('', 0);
    String threeNumExp;
    int prvResult;

    if (op == '+') {
      genPrvThreeNumExp = generateThreeNumExp;
      prvResult = genPrvThreeNumExp.value;
      num = Random().nextInt(9) + 1;
      result = prvResult + num;
    }

    if (op == '-') {
      do {
        genPrvThreeNumExp = generateThreeNumExp;
        prvResult = genPrvThreeNumExp.value;
        num = Random().nextInt(9) + 1;
      } while (prvResult < num);
      result = prvResult - num;
    }

    if (op == 'x') {
      do {
        genPrvThreeNumExp = generateThreeNumExp;
        prvResult = genPrvThreeNumExp.value;
        num = Random().nextInt(8) + 2;
      } while (prvResult * num >= 100);
      result = prvResult * num;
    }

    if (op == ':') {
      // check if the dividend is an prime number
      do {
        genPrvThreeNumExp = generateThreeNumExp;
        prvResult = genPrvThreeNumExp.value;
        num = Random().nextInt(8) + 2;
      } while (isPrime(prvResult));

      // to ensure that dividend % divisor == 0
      if (prvResult % num != 0 || prvResult == num) {
        for (int i = 9; i > 1; i--) {
          if (prvResult % i == 0) {
            num = i;
            break;
          }
        }
      }
      result = prvResult ~/ num;
    }
    threeNumExp = genPrvThreeNumExp.exp;

    return Pair('($threeNumExp) $op $num', result);
  }

  Pair get generateFourNumExp => fourNumExp();

  List<Pair> questionLv1() {
    Pair exp1, exp2;
    do {
      exp1 = oneNumExp();
      exp2 = oneNumExp();
    } while (exp1.value == exp2.value);

    return [exp1, exp2];
  }

  List<Pair> get genQuestionLv1 => questionLv1();

  List<Pair> questionLv2() {
    Pair exp1, exp2;
    do {
      exp1 = twoNumExp();
      exp2 = oneNumExp();
    } while (exp1.value == exp2.value);

    return [exp1, exp2];
  }

  List<Pair> get genQuestionLv2 => questionLv2();

  List<Pair> questionLv3() {
    Pair exp1, exp2;
    do {
      exp1 = twoNumExp();
      exp2 = twoNumExp();
    } while (exp1.value == exp2.value);

    return [exp1, exp2];
  }

  List<Pair> get genQuestionLv3 => questionLv3();

  List<Pair> questionLv4() {
    Pair exp1, exp2;
    do {
      exp1 = threeNumExp();
      exp2 = twoNumExp();
    } while (exp1.value == exp2.value);

    return [exp1, exp2];
  }

  List<Pair> get genQuestionLv4 => questionLv4();

  List<Pair> questionLv5() {
    Pair exp1, exp2;
    do {
      exp1 = threeNumExp();
      exp2 = threeNumExp();
    } while (exp1.value == exp2.value);

    return [exp1, exp2];
  }

  List<Pair> get genQuestionLv5 => questionLv5();

  List<Pair> questionLv6() {
    Pair exp1, exp2, exp3;
    do {
      exp1 = fourNumExp();
      exp2 = threeNumExp();
      exp3 = twoNumExp();
    } while (exp1.value == exp2.value && exp2.value == exp3.value);

    return [exp1, exp2, exp3];
  }

  List<Pair> get genQuestionLv6 => questionLv6();

  List<Pair> questionLv7() {
    Pair exp1, exp2, exp3;
    do {
      exp1 = fourNumExp();
      exp2 = fourNumExp();
      exp3 = twoNumExp();
    } while (exp1.value == exp2.value && exp2.value == exp3.value);

    return [exp1, exp2, exp3];
  }

  List<Pair> get genQuestionLv7 => questionLv7();

  bool isPrime(int num) {
    for (var i = 2; i < num; i++) {
      if (num % i == 0) {
        return false;
      }
    }
    return true;
  }
}

class Pair {
  final String exp;
  final int value;

  Pair(this.exp, this.value);

  @override
  String toString() => 'Pair($exp, $value)';
}
