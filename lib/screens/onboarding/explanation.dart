import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ExplanationData {
  final String title;
  final String description;
  final String localImageSrc;
  Color? backgroundColor;

  ExplanationData(
      {required this.title, required this.description, required this.localImageSrc,  this.backgroundColor});
}

class ExplanationPage extends StatelessWidget {
  final ExplanationData data;

  const ExplanationPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            margin:const EdgeInsets.only(top: 8, bottom: 8),
            child: Image.network(data.localImageSrc,
                height: MediaQuery.of(context).size.height * 0.45,
                alignment: Alignment.center)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                data.title,
                style:const TextStyle(
                    fontSize: 16.0, color: Colors.white, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    padding:const EdgeInsets.symmetric(horizontal: 48),
                    child: Text(
                      data.description,
                      style:const TextStyle(
                          fontSize: 16.0, color: Colors.white, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ))
              ],
            ),
          ),
        ),
      ],
    );
  }
}
