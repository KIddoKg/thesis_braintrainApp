
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomLottieDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 300,
        height: 440,
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              'assets/email-notification-animation.json', // Replace with your animation file path
              // width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16),
        Text(
          'Cho phép thông báo',
          style: TextStyle(
            color: Colors.teal,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
            SizedBox(height: 16),

            Text("Ứng dụng của chúng tôi muốn gửi thông báo cho bạn",textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
              ),),
            SizedBox(height: 36),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(
                      minimumSize: Size(120, 60),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Không',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 18,

                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: TextButton(
                    onPressed: () =>
                        AwesomeNotifications()
                            .requestPermissionToSendNotifications()
                            .then((_) => Navigator.pop(context)),
                    style: TextButton.styleFrom(
                      minimumSize: Size(120, 60),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.teal,

                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Có',
                      style: TextStyle(
                        color: Colors.teal,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
