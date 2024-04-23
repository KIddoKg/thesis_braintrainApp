import 'package:brain_train_app/shared/app_styles.dart';
import 'package:flutter/material.dart';

import '../../shared/share_widgets.dart';

import 'explanation.dart';



class OnBoarding extends StatefulWidget {
  final List<ExplanationData> data;

  const OnBoarding({super.key, required this.data});

  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> /*with ChangeNotifier*/ {
  final _controller = PageController();

  int _currentIndex = 0;

  // OpenPainter _painter = OpenPainter(3, 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: widget.data[_currentIndex].backgroundColor,
          child: SafeArea(
              child: Container(
            padding:const EdgeInsets.all(16),
            color: widget.data[_currentIndex].backgroundColor,
            alignment: Alignment.center,
            child: Column(children: [
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                        flex: 8,
                        child: Container(
                            alignment: Alignment.center,
                            child: PageView(
                                scrollDirection: Axis.horizontal,
                                controller: _controller,
                                onPageChanged: (value) {
                                  // _painter.changeIndex(value);
                                  setState(() {
                                    _currentIndex = value;
                                  });
                                  // notifyListeners();
                                },
                                children: widget.data
                                    .map((e) => ExplanationPage(data: e))
                                    .toList()))),
                    Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(widget.data.length,
                                      (index) => createCircle(index: index,currentIndex:_currentIndex)),
                                )),
                            BottomButtons(
                              currentIndex: _currentIndex,
                              dataLength: widget.data.length,
                              controller: _controller,
                            )
                          ],
                        ))
                  ],
                ),
              )
            ]),
          ))),
    );
  }
}
