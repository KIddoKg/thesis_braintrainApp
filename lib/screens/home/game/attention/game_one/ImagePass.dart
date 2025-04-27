import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'attention_game1.dart';



class ImagePassScreen extends StatelessWidget {
  final ImagePass imagePass;

  ImagePassScreen({required this.imagePass});
  late double screenHeight, screenWidth, boxHeight, boxWidth;
  List  imageUrls = [];
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    boxHeight = screenHeight * 0.5;
    boxWidth = screenWidth;
    imageUrls = imagePass.message;
    //print(imagePass.message);
    final size = MediaQuery.of(context).size;
    return  WillPopScope(
        onWillPop: () async {

      return false;
    },
      child: Column(
        children: [
          Container(
            // margin: const EdgeInsets.all(16),
            height: size.height*0.3,
            padding: const EdgeInsets.symmetric(
                vertical: 16, horizontal: 16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFFD740), Color(0xFFF9A825)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
            ),

            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                onPressed: () async {
                                  // Navigator.of(context).pop();
                                  Navigator.pop(context, "false");
                                  // stopTime = false;
                                },
                                icon: const Icon(
                                  Icons.arrow_circle_left_outlined,
                                  size: 40,
                                ),
                                color: Colors.black,
                              ),
                            ],
                          ),
                  
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.only(
                            top: 15, bottom: 10,right:20,left:20),
                        child: Text(
                          "Những ảnh mà bạn đã vượt qua sẽ được lưu ở đây:",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              fontSize: 20),
                        ),
                      ),
                  
                  
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
                height: size.height*0.9,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: imagePass.message.length,
                  itemBuilder: (BuildContext context, int index) {
                    return
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.all(15),
                            width: boxWidth,
                            height: boxHeight,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                image: DecorationImage(
                                  image: NetworkImage(imagePass.message[index]['img']), // Sửa từ Image.network() thành NetworkImage()
                                  fit: BoxFit.scaleDown,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    offset: Offset.zero,
                                  ),
                                ]
                            ),
                          ),

                          // Container(
                          //     margin: EdgeInsets.only(left: 25),
                          //     child: Text(widget.subCategory!.parts[index].name!,
                          //         textAlign: TextAlign.left,
                          //         style: TextStyle(color: Colors.red)
                          //     )
                          // )
                        ],
                      );

                  },
                )
            ),
          )
        ],
      ),
    );

  }
}
//
// class ImagePassScreen extends StatelessWidget {
//   final ImagePass imagePass;
//
//   ImagePassScreen({required this.imagePass});
//   int _selectedItemIndex = 0;
//   List<String> imageUrls = [];
//   @override
//   Widget build(BuildContext context) {
//     imageUrls = imagePass.message;
//
//     // List<Image> _images = [
//     //   Image.asset(imagePass.message[2]),
//     //
//     // ];
//     List<Widget> items =[];
//     for(var i =0; i<imagePass.message.length; i++){
//      items.add(Image.asset(imagePass.message[i]));
//
//     }
//     print(items);
//
//
//     return Center(
//       child: ListWheelScrollView.useDelegate(
//           itemExtent: 300,
//           childDelegate: ListWheelChildLoopingListDelegate(
//               children: items
//                   .map((e) => Center(
//                   child: Image(
//                     image: e,
//                   )))
//                   .toList())),
//     );
//   }
//
// }
