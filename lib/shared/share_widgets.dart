import 'dart:io';
import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:brain_train_app/shared/app_styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:vector_math/vector_math.dart' as v_math;

import 'package:brain_train_app/models/result_model.dart';
import 'package:brain_train_app/models/user_model.dart';
import 'light_colors.dart';

class MyHours extends StatelessWidget {
  int hours;
  int select;

  MyHours({super.key, required this.hours,required this.select});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Center(
        child: Text(
          "$hours",
          style: TextStyle(
            fontSize: 40,
            color:
            select == hours
                ? Colors.green
                : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
class MyMinutes extends StatelessWidget {
  int mins;
  int select;

  MyMinutes({super.key, required this.mins,required this.select});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Center(
        child: Text(
          mins < 10 ? '0' + mins.toString() : mins.toString(),
          style: TextStyle(
            fontSize: 40,
            color:
            select == mins
                ? Colors.green
                : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}



typedef OnChange = void Function(int index);

class ReviewSlider extends StatefulWidget {
  const ReviewSlider({
    Key? key,
    required this.onChange,
    this.initialValue = 2,
    this.options = const ['Bực tức', 'Khó chịu', 'Ổn', 'Thoải mái', 'Tuyệt'],
    this.optionStyle,
    this.width,
    this.circleDiameter = 60,
  })  : assert(
  initialValue >= 0 && initialValue <= 4,
  'Initial value should be between 0 and 4',
  ),
        assert(
        options.length == 5,
        'Reviews options should be 5',
        ),
        super(key: key);


  final OnChange onChange;
  final int initialValue;
  final List<String> options;
  final TextStyle? optionStyle;
  final double? width;
  final double circleDiameter;

  @override
  _ReviewSliderState createState() => _ReviewSliderState();
}

class _ReviewSliderState extends State<ReviewSlider>
    with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late double _animationValue;
  late double _xOffset;

  late AnimationController _controller;
  late Tween<double> _tween;

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void initState() {
    super.initState();
    var initValue = widget.initialValue.toDouble();
    _controller = AnimationController(
      value: initValue,
      vsync: this,
      duration:const Duration(milliseconds: 400),
    );
    _tween = Tween(end: initValue);
    _animation = _tween.animate(
      CurvedAnimation(
        curve: Curves.easeIn,
        parent: _controller,
      ),
    )..addListener(() {
      setState(() {
        _animationValue = _animation.value;
      });
    });
    _animationValue = initValue;
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
  }

  _afterLayout(_) {
    widget.onChange(widget.initialValue);
  }

  void handleTap(int state) {
    _controller.duration =const Duration(milliseconds: 400);
    _tween.begin = _tween.end;
    _tween.end = state.toDouble();
    _controller.reset();
    _controller.forward();

    widget.onChange(state);
  }

  void _onDrag(double dx, innerWidth) {
    var newAnimatedValue = _calcAnimatedValueFormDragX(dx, innerWidth);

    if (newAnimatedValue > 0 && newAnimatedValue < widget.options.length - 1) {
      setState(
            () {
          _animationValue = newAnimatedValue;
        },
      );
    }
  }

  void _onDragEnd(_) {
    _controller.duration =const Duration(milliseconds: 100);
    _tween.begin = _animationValue;
    _tween.end = _animationValue.round().toDouble();
    _controller.reset();
    _controller.forward();

    widget.onChange(_animationValue.round());
  }

  void _onDragStart(x, width) {
    var oneStepWidth =
        (width - widget.circleDiameter) / (widget.options.length - 1);
    _xOffset = x - (oneStepWidth * _animationValue);
  }

  _calcAnimatedValueFormDragX(x, innerWidth) {
    x = x - _xOffset;
    return x /
        (innerWidth - widget.circleDiameter) *
        (widget.options.length - 1);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:const EdgeInsets.symmetric(horizontal: paddingSize),
      height: 150,
      child: LayoutBuilder(
        builder: (context, size) {
          return Stack(
            children: <Widget>[
              MeasureLine(
                states: widget.options,
                handleTap: handleTap,
                animationValue: _animationValue,
//                width: size.maxWidth,
                width: widget.width != null && widget.width! < size.maxWidth
                    ? widget.width!
                    : size.maxWidth,
                optionStyle: widget.optionStyle,
                circleDiameter: widget.circleDiameter,
              ),
              MyIndicator(
                circleDiameter: widget.circleDiameter,
                animationValue: _animationValue,
                width: widget.width != null && widget.width! < size.maxWidth
                    ? widget.width
                    : size.maxWidth,
                onDragStart: (details) {
                  _onDragStart(
                      details.globalPosition.dx,
                      widget.width != null && widget.width! < size.maxWidth
                          ? widget.width
                          : size.maxWidth);
                },
                onDrag: (details) {
                  _onDrag(
                      details.globalPosition.dx,
                      widget.width != null && widget.width! < size.maxWidth
                          ? widget.width
                          : size.maxWidth);
                },
                onDragEnd: _onDragEnd,
              ),
            ],
          );
        },
      ),
    );
  }
}

//const double circleDiameter = 30;
const double paddingSize = 10;

class MeasureLine extends StatelessWidget {
  const MeasureLine({super.key,
    required this.handleTap,
    required this.animationValue,
    required this.states,
    required this.width,
    this.optionStyle,
    required this.circleDiameter,
  });

  final double animationValue;
  final Function handleTap;
  final List<String> states;
  final double width;
  final TextStyle? optionStyle;
  final double circleDiameter;

  List<Widget> _buildUnits() {
    var res = <Widget>[];
    var animatingUnitIndex = animationValue.round();
    var unitAnimatingValue = (animationValue * 10 % 10 / 10 - 0.5).abs() * 2;

    states.asMap().forEach((index, text) {
      var paddingTop = 0.0;
      var scale = 0.7;
      var opacity = .3;
      if (animatingUnitIndex == index) {
        paddingTop = unitAnimatingValue * 5;
        scale = (1 - unitAnimatingValue) * 0.7;
        opacity = 0.3 + unitAnimatingValue * 0.7;
      }
      res.add(LimitedBox(
        key: ValueKey(text),
        maxWidth: circleDiameter,
        child: GestureDetector(
          onTap: () {
            handleTap(index);
          },
          child:Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Transform.scale(
                  scale: scale,
                  child: Stack(
                    children: [
                      Head(
                        circleDiameter: circleDiameter,
                      ),
                      Face(
                        circleDiameter: circleDiameter,
                        color: Colors.white,
                        animationValue: index.toDouble(),
                      )
                    ],
                  )),
              Padding(
                padding: EdgeInsets.only(top: paddingTop),
                child: Opacity(
                  opacity: opacity,
                  child: Text(
                    text,
                    style: optionStyle ?? const TextStyle(color: Colors.black),
                  ),
                ),
              )
            ],
          ),
        ),
      ));
    });
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: circleDiameter / 2,
          left: 20,
          width: width - 40,
          child: Container(
            width: width,
            color: const Color(0xFFeceeef),
            height: 3,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _buildUnits(),
        ),
      ],
    );
  }
}

class Face extends StatelessWidget {
  const Face({super.key,
    this.color = const Color(0xFF616154),
    required this.animationValue,
    required this.circleDiameter,
  });

  final double animationValue;
  final Color color;
  final double circleDiameter;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: circleDiameter,
      width: circleDiameter,
      child: CustomPaint(
        size: const Size(300, 300),
        painter: MyPainter(animationValue, color: color),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  MyPainter(
      animationValue, {
        this.color = const Color(0xFF615f56),
      })  : activeIndex = animationValue.floor(),
        unitAnimatingValue = (animationValue * 10 % 10 / 10);

  final int activeIndex;
  Color color;
  final double unitAnimatingValue;

  @override
  void paint(Canvas canvas, Size size) {
    _drawEye(canvas, size);
    _drawMouth(canvas, size);
  }

  @override
  bool shouldRepaint(MyPainter oldDelegate) {
    return unitAnimatingValue != oldDelegate.unitAnimatingValue ||
        activeIndex != oldDelegate.activeIndex;
  }

  _drawEye(canvas, size) {
    var angle = 0.0;
    var wide = 0.0;

    switch (activeIndex) {
      case 0:
        angle = 55 - unitAnimatingValue * 50;
        wide = 80.0;
        break;
      case 1:
        wide = 80 - unitAnimatingValue * 80;
        angle = 5;
        break;
    }
    var degree1 = 90 * 3 + angle;
    var degree2 = 90 * 3 - angle + wide;
    var x1 = size.width / 2 * 0.65;
    var x2 = size.width - x1;
    var y = size.height * 0.41;
    var eyeRadius = 5.0;

    var paint = Paint()..color = color;
    canvas.drawArc(
      Rect.fromCircle(
        center: Offset(x1, y),
        radius: eyeRadius,
      ),
      v_math.radians(degree1),
      v_math.radians(360 - wide),
      false,
      paint,
    );
    canvas.drawArc(
      Rect.fromCircle(
        center: Offset(x2, y),
        radius: eyeRadius,
      ),
      v_math.radians(degree2),
      v_math.radians(360 - wide),
      false,
      paint,
    );
  }

  _drawMouth(Canvas canvas, size) {
    var upperY = size.height * 0.70;
    var lowerY = size.height * 0.77;
    var middleY = (lowerY - upperY) / 2 + upperY;

    var leftX = size.width / 2 * 0.65;
    var rightX = size.width - leftX;
    var middleX = size.width / 2;

    late double y1, y3, x2, y2;
    Path? path2;
    switch (activeIndex) {
      case 0:
        y1 = lowerY;
        x2 = middleX;
        y2 = upperY;
        y3 = lowerY;
        break;
      case 1:
        y1 = lowerY;
        x2 = middleX;
        y2 = unitAnimatingValue * (middleY - upperY) + upperY;
        y3 = lowerY - unitAnimatingValue * (lowerY - upperY);
        break;
      case 2:
        y1 = unitAnimatingValue * (upperY - lowerY) + lowerY;
        x2 = middleX;
        y2 = unitAnimatingValue * (lowerY + 3 - middleY) + middleY;
        y3 = upperY;
        break;
      case 3:
        y1 = upperY;
        x2 = middleX;
        y2 = lowerY + 3;
        y3 = upperY;
        path2 = Path()
          ..moveTo(leftX, y1)
          ..quadraticBezierTo(
            x2,
            y2,
            upperY - 2.5,
            y3 - 2.5,
          )
          ..quadraticBezierTo(
            x2,
            y2 - unitAnimatingValue * (y2 - upperY + 2.5),
            leftX,
            upperY - 2.5,
          )
          ..close();
        break;
      case 4:
        y1 = upperY;
        x2 = middleX;
        y2 = lowerY + 3;
        y3 = upperY;
        path2 = Path()
          ..moveTo(leftX, y1)
          ..quadraticBezierTo(
            x2,
            y2,
            upperY - 2.5,
            y3 - 2.5,
          )
          ..quadraticBezierTo(
            x2,
            upperY - 2.5,
            leftX,
            upperY - 2.5,
          )
          ..close();
        break;
    }
    var path = Path()
      ..moveTo(leftX, y1)
      ..quadraticBezierTo(
        x2,
        y2,
        rightX,
        y3,
      );

    canvas.drawPath(
        path,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 5);

    if (path2 != null) {
      canvas.drawPath(
        path2,
        Paint()
          ..color = color
          ..style = PaintingStyle.fill
          ..strokeCap = StrokeCap.round,
      );
    }
  }
}

class MyIndicator extends StatelessWidget {
  const MyIndicator({super.key,
    required this.animationValue,
    required width,
    required this.onDrag,
    required this.onDragStart,
    required this.onDragEnd,
    required this.circleDiameter,
  })  : width = width - circleDiameter,
        possition = animationValue == 0 ? 0 : animationValue / 4;

  final double animationValue;
  final Function(DragUpdateDetails) onDrag;
  final Function(DragEndDetails) onDragEnd;
  final Function(DragStartDetails) onDragStart;
  final double possition;
  final double width;
  final double circleDiameter;

  _buildIndicator() {
    var opacityOfYellow = possition > 0.5 ? 1.0 : possition * 2;
    return GestureDetector(
      onHorizontalDragStart: onDragStart,
      onHorizontalDragUpdate: onDrag,
      onHorizontalDragEnd: onDragEnd,
      child: SizedBox(
        width: circleDiameter,
        height: circleDiameter,
        child: Stack(
          children: <Widget>[
            Head(
              color: const Color(0xFFf4b897),
              hasShadow: true,
              circleDiameter: circleDiameter,
            ),
            Opacity(
              opacity: opacityOfYellow,
              child: Head(
                color: const Color(0xFFfee385),
                circleDiameter: circleDiameter,
              ),
            ),
            Face(
              animationValue: animationValue,
              circleDiameter: circleDiameter,
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: width * possition,
      child: _buildIndicator(),
    );
  }
}

class Head extends StatelessWidget {
  const Head({super.key,
    this.color = const Color(0xFFc9ced2),
    this.hasShadow = false,
    required this.circleDiameter,
  });

  final Color color;
  final bool hasShadow;
  final double circleDiameter;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: circleDiameter,
      width: circleDiameter,
      decoration: BoxDecoration(
        boxShadow: hasShadow
            ? const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 2),
            blurRadius: 5.0,
          )
        ]
            : null,
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}


class ButtonSubmit extends StatelessWidget {
  String title;
  Color? backgroundColor;
  Color? fontColor;
  FontWeight fontWeight;
  double fontSize;
  double height;
  void Function()? onTap;

    ButtonSubmit(this.title,
      {super.key, this.onTap,
        this.backgroundColor = Colors.transparent,
        this.fontColor = Colors.blue,
        this.fontSize = 20,
        this.height = 50,
        this.fontWeight = FontWeight.w500});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
            color: backgroundColor == Colors.transparent
                ? Colors.black
                : backgroundColor,
            border: Border.all(
                width: 1,
                color: backgroundColor == Colors.transparent
                    ? Colors.black
                    : backgroundColor!),
            borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: backgroundColor == Colors.transparent
                      ? fontColor
                      : Colors.white,
                  fontSize: fontSize,
                  fontWeight: fontWeight),
            ),
          ),
        ),
      ),
    );
  }
}


class AvatarLoad extends StatelessWidget {
  // local path or url link
  String pathImage;
  double size;
  bool editAvatar;
  Function(String pathImage)? onPickerImage;

  AvatarLoad(this.pathImage,
      {super.key, this.size = 25, this.editAvatar = false, this.onPickerImage});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        radius: pathImage.isNotEmpty ? size * 1.5 : size,
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            pathImage.isNotEmpty && pathImage.contains('https')
                ? CachedNetworkImage(
                imageUrl: pathImage,
                placeholder: (ctx, url) => const CircularProgressIndicator(
                  color: Colors.amber,
                  strokeWidth: 2,
                  backgroundColor: Colors.transparent,
                ),
                // errorWidget: (ctx, url, error) => SvgPicture.asset(
                //   "assets/img/user.svg",
                //   height: size + 5,
                //   width: size + 5,
                //   color: Colors.white,
                // ),
                errorWidget: (ctx, url, error) => const Icon(Icons.person))
                : pathImage.isNotEmpty && !pathImage.contains('https')
                ? Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50)),
                child: Image.file(
                  File(UserModel.instance.profileUrl),
                  fit: BoxFit.contain,
                  // width: 100,
                  // height: 100,
                ))
                : Icon(
              // const FaIcon(FontAwesomeIcons.user) as IconData?,
              Icons.person,
              size: size + 16,
            ),
            if (editAvatar)
              Positioned(
                  bottom: -2,
                  right: -2,
                  child: GestureDetector(
                    onTap: () async {
                      var picker = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);
                      if (picker != null && onPickerImage != null) {
                        onPickerImage!(picker.path);
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 125, 125, 125),
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                              width: 2,
                              color: Colors.black)),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.camera_alt,
                          size: pathImage.isNotEmpty ? 20 : 15,
                          color: const Color.fromARGB(255, 242, 242, 242),
                        ),
                      ),
                    ),
                  ))
          ],
        ));
  }
}


class UserRow extends StatelessWidget {
  UserRow(
      {super.key,
        this.title,
        this.child,
        this.padding,
        this.spacing,
        this.height = 32,
        this.crossAxisAlignment = CrossAxisAlignment.center});

  EdgeInsets? padding;
  Widget? title;
  Widget? child;
  double? spacing;
  double? height;
  CrossAxisAlignment? crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: const EdgeInsets.only(bottom: 1),
      child: Padding(
        padding: padding == null ? const EdgeInsets.only(bottom: 0) : padding!,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: crossAxisAlignment!,
          children: [
            if (title != null) title!,
            if (spacing != null)
              SizedBox(
                width: spacing,
              ),
            if (child != null) child!
          ],
        ),
      ),
    );
  }
}
class UserRowText extends StatelessWidget {
  UserRowText(this.title, this.value,
      {super.key,
        this.styleTitle,
        this.styleValue,
        this.padding,
        this.spacing});
  String title, value;
  TextStyle? styleValue, styleTitle;
  EdgeInsets? padding;
  double? spacing;

  @override
  Widget build(BuildContext context) {
    return UserRow(
      spacing: spacing,
      padding: padding,
      title: Text(
        title,
        style: styleTitle ??
            const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: Colors.grey),
      ),
      child: Text(
        value,
        style: styleValue ??
            const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black),
      ),
    );
  }
}

Future<dynamic> showAlert(context, String title, String message,
    {List<CupertinoButton>? actions,
      List<ElevatedButton>? actionAndroids}) async {
  if (Platform.isIOS) {
    return showCupertinoDialog(
        context: context!,
        builder: (context) => CupertinoAlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            if (actions != null)
              ...actions
            else
              CupertinoButton(
                  child: const Text('Đồng ý'),
                  onPressed: () {
                    Navigator.pop(context);
                  })
          ],
        ));
  }

  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        if (actionAndroids != null)
          ...actionAndroids
        else
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Đồng ý'))
      ],
    ),
  );
}

class DolDurmaClipper extends CustomClipper<Path> {
  final double holeRadius;
  final double right;

  DolDurmaClipper({required this.holeRadius,required this.right,});

  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width - right - holeRadius, 0.0)
      ..arcToPoint(
        Offset(size.width - right, 0),
        clockwise: false,
        radius: const Radius.circular(1),
      )
      ..lineTo(size.width, 0.0)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width - right, size.height)
      ..arcToPoint(
        Offset(size.width - right - holeRadius, size.height),
        clockwise: false,
        radius: const Radius.circular(1),
      );

    path.lineTo(0.0, size.height);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(DolDurmaClipper oldClipper) => true;
}
class LoadingIndicator extends StatefulWidget {
  final bool isLoading;
  final Widget child;
  final Duration loadingDuration;

  const LoadingIndicator({super.key,
    required this.isLoading,
    required this.child,
    this.loadingDuration = const Duration(seconds: 1), // Default duration
  });

  @override
  _LoadingIndicatorState createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<LoadingIndicator> {
  bool _showLoading = true;

  @override
  void initState() {
    super.initState();

    if (widget.isLoading == true) {
      // Start the loading process
      _showLoading = true;
      Future.delayed(widget.loadingDuration, () {
        if (!mounted) return;
        _showLoading = false;
        setState(() {

        });
      });
    } else {
      _showLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _showLoading == true
        ? const Center(child:  ColorLoader3(
      radius: 10,
      dotRadius: 6.0,
      centerDot: false,
      dotColor2: LightColors.ColorbgCart,
      dotColor: LightColors.ColorbgCart,
      dotQuality:8,
    ))
        : widget.child;
  }
}

class LoadingDot extends StatelessWidget {
  LoadingDot({super.key, this.text = 'Đang tải dữ liệu', this.style});

  String? text;
  TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Center(child:  ColorLoader3(
      radius: 10,
      dotRadius: 6.0,
      centerDot: false,
      dotColor2: AppColors.primaryColor,
      dotColor: AppColors.primaryColor,
      dotQuality:8,
    ));
  }
}



class ColorLoader3 extends StatefulWidget {
  final double radius;
  final double dotRadius;
  final Color? dotColor;
  final Color? dotColor2;
  final bool centerDot;
  final int dotQuality;

  const ColorLoader3({super.key, this.radius = 30.0, this.dotRadius = 3.0,this.centerDot = true,this.dotColor = Colors.white,this.dotColor2 = Colors.yellow, this.dotQuality=0});

  @override
  _ColorLoader3State createState() => _ColorLoader3State();
}


class _ColorLoader3State extends State<ColorLoader3> with SingleTickerProviderStateMixin {
  late Animation<double> animation_rotation;
  late AnimationController controller;

  late double radius;
  late double dotRadius;

  late int visibleDotCount ; // Number of visible dots
  int time =3000;
  @override
  void initState() {
    super.initState();

    radius = widget.radius;
    dotRadius = widget.dotRadius;
    visibleDotCount = widget.dotQuality;
    controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    animation_rotation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 1.0, curve: Curves.linear),
      ),
    );


    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          visibleDotCount++; // Show the next dot
          if (visibleDotCount <= 8) {
            controller.forward(from: 0.0); // Start the animation again
          } else {
            controller.repeat(); // Repeat the rotation animation
          }
        });
      }
    });

    controller.forward(); // Start the loading animation
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100.0,
      height: 100.0,
      child: Center(
        child: RotationTransition(
          turns: animation_rotation,
          child: Stack(
            children: <Widget>[
              if(widget.centerDot)
                  Transform.translate(
                  offset: const Offset(0.0, 0.0),
                  child: Dot(
                    radius: radius,
                    color: widget.dotColor,
                  ),
                ),
              for (var i = 0; i < 8; i++)
                if (i < visibleDotCount)
                  Transform.translate(
                    offset: Offset(
                      ( radius+10) * cos(i * pi / 4),
                      (radius+10) * sin(i * pi / 4),
                    ),
                    child: Dot(
                      radius: dotRadius,
                      color: i%2==0 ? widget.dotColor : widget.dotColor2,
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}


class Dot extends StatelessWidget {
  final double? radius;
  final Color? color;

  Dot({this.radius, this.color});

  @override
  Widget build(BuildContext context) {
    return   Center(
      child: Container(
        width: radius,
        height: radius,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),

      ),
    );
  }
}

class ButtonVertical extends StatelessWidget {
  final List<String> buttonTitles;
  final int selectedButtonIndex;
  final double height;
  final ValueChanged<int> onButtonTap;

  const ButtonVertical({super.key,
    required this.buttonTitles,
    required this.selectedButtonIndex,
    required this.height,
    required this.onButtonTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: buttonTitles.length,
        itemBuilder: (context, index) {
          final bool isSelected = selectedButtonIndex == index;
          final double scale = isSelected ? 1.2 : 1.0;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Material(
              borderRadius: BorderRadius.circular(8.0),
              color: isSelected ? LightColors.kDarkYellow : null,
              child: Transform.scale(
                scale: scale,
                child: ElevatedButton(
                  onPressed: () {
                    onButtonTap(
                        index); // Call the callback function with the selected index
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSelected ? AppColors.primaryColor : LightColors.ColorbgCart,
                    elevation: 0.0,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    buttonTitles[index],
                    style: TextStyle(
                      color: isSelected ? Colors.white: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
class ButtonVerticalCenter extends StatelessWidget {
  final List<String> buttonTitles;
  final int selectedButtonIndex;
  final double height;
  final ValueChanged<int> onButtonTap;

  const ButtonVerticalCenter({super.key,
    required this.buttonTitles,
    required this.selectedButtonIndex,
    required this.height,
    required this.onButtonTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Center(
        child: Row( // Sử dụng Row thay vì ListView.builder
          mainAxisAlignment: MainAxisAlignment.center,
          children: buttonTitles.asMap().entries.map((entry) {
            final int index = entry.key;
            final String title = entry.value;
            final bool isSelected = selectedButtonIndex == index;
            final double scale = isSelected ? 1.2 : 1.0;

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                borderRadius: BorderRadius.circular(8.0),
                color: isSelected ? LightColors.kDarkYellow : null,
                child: Transform.scale(
                  scale: scale,
                  child: ElevatedButton(
                    onPressed: () {
                      onButtonTap(index); // Gọi hàm callback với index đã chọn
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:isSelected ? AppColors.primaryColor : LightColors.ColorbgCart,
                      elevation: 0.0,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      title,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class ExpandedSection extends StatefulWidget {
  final Widget child;
  final bool expand;

  const ExpandedSection({super.key, this.expand = true, required this.child});

  @override
  _ExpandedSectionState createState() => _ExpandedSectionState();
}

class _ExpandedSectionState extends State<ExpandedSection>
    with SingleTickerProviderStateMixin {
  late AnimationController expandController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    prepareAnimations();
  }

  ///Setting up the animation
  void prepareAnimations() {
    expandController =
        AnimationController(vsync: this, duration:const Duration(milliseconds: 500));
    Animation<double> curve = CurvedAnimation(
      parent: expandController,
      curve: Curves.fastOutSlowIn,
    );
    animation = Tween(begin: 0.0, end: 1.0).animate(curve)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void didUpdateWidget(ExpandedSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.expand) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
        axisAlignment: 1.0, sizeFactor: animation, child: widget.child);
  }
}

class LoadingFragment extends StatelessWidget {
  LoadingFragment({super.key, this.text = 'Đang tải dữ liệu', this.style,this.noText});

  String? text;
  TextStyle? style;
  bool? noText = false;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              backgroundColor: Colors.transparent,
              // backgroundColor: Color.fromARGB(128, 158, 158, 158),
              radius: 10,
              child: SizedBox(
                width: 25,
                height: 25,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.amber,
                ),
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            if(noText == false)
            Text(
              text!,
              style: style == null ? const TextStyle(color: Colors.grey) : style,
            )
          ],
        ));
  }
}

class ResultScreen extends StatelessWidget {
  final Result result;
  void Function()? onTap;
  ResultScreen({super.key, required this.result, required this.onTap});

  @override
  Widget build(BuildContext context) {
    double scrHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child:SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Chúc mừng!',
                    style: TextStyle(
                      color: Color.fromARGB(255, 228, 45, 32),
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.3,
                    ),
                  ),
                  SizedBox(height: scrHeight / 60),
                  const Text(
                    'Bạn đã hoàn thành tất cả các lượt chơi',
                    style: TextStyle(
                      color: Color.fromARGB(255, 83, 74, 73),
                      fontSize: 19,
                    ),
                  ),
                  SizedBox(height: scrHeight / 30),
                  Lottie.asset(
                    'assets/congratulation.json',
                    height: 300,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: scrHeight / 30),
                  SizedBox(
                    child: DefaultTextStyle(
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                      child: AnimatedTextKit(
                        animatedTexts: [
                          TyperAnimatedText(
                            'Điểm:${result.score}\nDanh sách từ đúng : ${result.list}',
                            textStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontFamily: 'RobotoSlab',
                              wordSpacing: 1.2,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                        isRepeatingAnimation: false,
                      ),
                    ),
                  ),
                  SizedBox(height: scrHeight / 15),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          const Color.fromARGB(255, 53, 28, 92)),
                      elevation: MaterialStateProperty.all(1),
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(horizontal: 50, vertical: 25)),
                      shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
                            (_) => RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    onPressed: onTap,
                    child: const Text(
                      'Quay lại màn hình chính',
                      style:   TextStyle(fontSize: 19),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
class PageButton extends StatelessWidget {
  IconData icon;
  Color? backgroundColor;
  Color? border;
  Color? fontColor;
  FontWeight fontWeight;
  double fontSize;
  double height;
  bool disable;
  bool size;
  double width;
  void Function()? onTap;

  PageButton(this.icon,
      {super.key,
        this.onTap,
        this.width = 10,
        this.disable = false,
        this.size = false,
        this.backgroundColor = Colors.transparent,
        this.border = Colors.transparent,
        this.fontColor = Colors.blue,
        this.fontSize = 16,
        this.height = 40,
        this.fontWeight = FontWeight.w500});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: disable == false ? onTap : null,
        child: Padding(
          padding:
          const EdgeInsets.only(top: 10, bottom: 10, right: 0, left: 0),
          child: Center(
            // child: Text(
            //   title,
            //   textAlign: TextAlign.center,
            //   style: TextStyle(
            //       color: disable == true ? AppColors.bgButton:fontColor, fontSize: fontSize, fontWeight: fontWeight),
            // ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: fontSize,
                  color: disable == false ? fontColor : Colors.grey,
                ),
              ],
            ),
          ),
        ));
  }
}

class CardTime extends StatelessWidget {
  Widget? child;
  Color? backgroundColor;
  Color? borderColor;

  CardTime({super.key, this.child, this.backgroundColor, this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
            width: 1,
            color: borderColor == null
                ? AppColors.primaryColor
                : borderColor!),
        borderRadius: BorderRadius.circular(8),
        color: backgroundColor == null
            ? AppColors.primaryColor
            : backgroundColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: child,
      ),
    );
  }
}

class ErrorsNoti extends StatelessWidget {
  ErrorsNoti({super.key, this.text = 'Không có dữ liệu', this.style});

  String? text;
  TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.warning,size: 70,color: Colors.orange,),
            Center(
              child: Text(
                text!,
                textAlign: TextAlign.center,
                style: style == null ? const TextStyle(color: Colors.grey) : style,
              ),
            )
          ],
        ));
  }
}

Widget buildGameSectionMain(String imageAsset, String titleMain,) {
  return  Padding(
    padding: const EdgeInsets.only(right: 15,left: 15,top:8,bottom: 8),
    child: Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.primaryColor,
          ),
          padding: const EdgeInsets.all(15.0),
          width: double.infinity,
          child: Row(
            children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Center(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 21,
                              backgroundColor: const Color(0xff37EBBC),
                              child: CircleAvatar(
                                radius: 18,
                                backgroundImage: AssetImage(
                                  imageAsset,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10,),
                      AnimatedDefaultTextStyle(
                        duration:const Duration(
                            milliseconds: 300),
                        style:const TextStyle(
                            fontSize:  16,
                            color:  Colors.black,
                            fontWeight
                                : FontWeight
                                .normal),
                        child: Text(
                          titleMain,
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget buildGameSection(String imageAsset, String titleMain, void Function() onTap) {
  return Padding(
    padding: const EdgeInsets.only(top: 8.0, left: 35, bottom: 8, right: 8),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.primaryColorYellow,
      ),
      padding: const EdgeInsets.all(15.0),
      width: double.infinity,
      child: Row(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 21,
                        backgroundColor: const Color(0xff37EBBC),
                        child: CircleAvatar(
                          radius: 18,
                          backgroundImage: AssetImage(
                            imageAsset,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10,),
                TextButton(
                  onPressed: onTap, // Corrected this line
                  child: Text(
                    titleMain,
                    style:const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

createCircle({required int index, required int currentIndex}) {
  return AnimatedContainer(
      duration:const Duration(milliseconds: 100),
      margin:const EdgeInsets.only(right: 4),
      height: 10,
      width: currentIndex == index ? 25 : 10,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)));
}

class BottomButtons extends StatelessWidget {
  final int currentIndex;
  final int dataLength;
  final PageController controller;

  const BottomButtons(
      {Key? key, required this.currentIndex, required this.dataLength, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: currentIndex == dataLength - 1
          ? [
        Expanded(
          child: ConstrainedBox(
              constraints:  const BoxConstraints(
                maxHeight: 50.0,
              ),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context,"false");
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                        side: BorderSide.none,
                      ),
                    ),
                    minimumSize: MaterialStateProperty.all(
                      Size(MediaQuery.of(context).size.width * 0.6, MediaQuery.of(context).size.height * 0.1),
                    ),
                  ),
                  child:  const Text(
                    "Bắt đầu chơi thôi !",
                    style: TextStyle(
                        fontSize: 16.0, color: Colors.black, fontWeight: FontWeight.w500),
                  ))),
        )
      ]
          : [
        TextButton(

          onPressed: () {
            SharedAppData.setValue<String, bool>(context, 'stoptime',
                false);
            Navigator.pop(context,"false");
          },
          child: const Text(
            "Bỏ qua",
            style: TextStyle(
                fontSize: 16.0, color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
        Row(
          children: [
            TextButton(

              onPressed: () {
                controller.nextPage(
                    duration: Duration(milliseconds: 200),
                    curve: Curves.easeInOut);
              },
              child:const Text(
                "Tiếp tục",
                style: TextStyle(
                    fontSize: 16.0, color: Colors.white, fontWeight: FontWeight.w500),
              ),
            ),
            Container(
                alignment: Alignment.center,
                child:const Icon(
                  Icons.arrow_right_alt,
                  color: Colors.white,
                ))
          ],
        )
      ],
    );
  }
}


class TabSelector extends StatefulWidget {
  @override
  _TabSelectorState createState() => _TabSelectorState();
}

class _TabSelectorState extends State<TabSelector> {
  final PageController _pageController = PageController();
  String indexTab = "Tất cả";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Container(
              width: 332,
              height: 35,
              margin: const EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(20.0),
                ),
                border: Border.all(
                  color: Colors.transparent,
                  width: 1.0,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10.0),
                        topLeft: Radius.circular(10.0),
                      ),
                      color: indexTab == "Tất cả"
                          ? Colors.blue // Replace with your desired color
                          : Colors.yellow, // Replace with your desired color
                    ),
                    width: 110,
                    child: TextButton(
                      onPressed: () {
                        _pageController.animateToPage(0,
                            duration:const Duration(milliseconds: 500),
                            curve: Curves.ease);
                        indexTab = "Tất cả";
                        setState(() {});
                      },
                      child: Text(
                        "Tất cả",
                        style: TextStyle(
                          color: indexTab == "Tất cả"
                              ? Colors.white
                              : Colors.black,
                          fontWeight: indexTab == "Tất cả"
                              ? FontWeight.w700
                              : FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 110,
                    decoration: BoxDecoration(
                      color: indexTab == "Thành tựu"
                          ? Colors.blue // Replace with your desired color
                          : Colors.yellow, // Replace with your desired color
                      border:const Border(
                        left: BorderSide(
                          color: Colors.white,
                          width: 1.0,
                        ),
                        right: BorderSide(
                          color: Colors.white,
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: TextButton(
                      onPressed: () {
                        _pageController.animateToPage(1,
                            duration:const Duration(milliseconds: 500),
                            curve: Curves.ease);
                        indexTab = "Thành tựu";
                        setState(() {});
                      },
                      child: Text(
                        "Thành tựu",
                        style: TextStyle(
                          color: indexTab == "Thành tựu"
                              ? Colors.white
                              : Colors.black,
                          fontWeight: indexTab == "Thành tựu"
                              ? FontWeight.w700
                              : FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                      ),
                      color: indexTab == "Biểu đồ"
                          ? Colors.blue // Replace with your desired color
                          : Colors.yellow, // Replace with your desired color
                    ),
                    width: 110,
                    child: TextButton(
                      onPressed: () {
                        indexTab = "Biểu đồ";
                        setState(() {});
                        _pageController.animateToPage(2,
                            duration:const Duration(milliseconds: 500),
                            curve: Curves.ease);
                      },
                      child: Text(
                        "Biểu đồ",
                        style: TextStyle(
                          color: indexTab == "Biểu đồ"
                              ? Colors.white
                              : Colors.black,
                          fontWeight: indexTab == "Biểu đồ"
                              ? FontWeight.w700
                              : FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
