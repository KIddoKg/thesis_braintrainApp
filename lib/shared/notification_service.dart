import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:brain_train_app/screens/home/home_page/leader.dart';
// import 'package:brain_train_app/screens/second_screen.dart';

import 'package:flutter/material.dart';

import '../main.dart';

class NotificationService {
  static Future<void> initializeNotification() async {
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelGroupKey: 'notification_daily',
          channelKey: 'notification_daily',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: const Color(0xFFFFFFFF),
          ledColor: Colors.white,
          importance: NotificationImportance.Max,
          channelShowBadge: true,
          playSound: true,
          criticalAlerts: true,
        ),
        NotificationChannel(
          channelGroupKey: 'notification_checkout',
          channelKey: 'notification_checkout',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: const Color(0xFFFFFFFF),
          ledColor: Colors.white,
          importance: NotificationImportance.Max,
          channelShowBadge: true,
          onlyAlertOnce: true,
          playSound: true,
          criticalAlerts: true,
        ),
        NotificationChannel(
          channelGroupKey: 'notification_reminder',
          channelKey: 'notification_reminder',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: const Color(0xFFFFFFFF),
          ledColor: Colors.white,
          importance: NotificationImportance.Max,
          channelShowBadge: true,
          playSound: true,
          criticalAlerts: true,
        )
      ],
      channelGroups: [
        NotificationChannelGroup(
          channelGroupKey: 'notification_daily',
          channelGroupName: 'Group 1',
        )
      ],
      debug: true,
    );

    // await AwesomeNotifications().isNotificationAllowed().then(
    //   (isAllowed) async {
    //     if (!isAllowed) {
    //       await AwesomeNotifications().requestPermissionToSendNotifications();
    //     }
    //   },
    // );

    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
      onNotificationCreatedMethod: onNotificationCreatedMethod,
      onNotificationDisplayedMethod: onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: onDismissActionReceivedMethod,
    );
  }

  /// Use this method to detect when a new notification or a schedule is created
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint('onNotificationCreatedMethod');
  }

  /// Use this method to detect every time that a new notification is displayed
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint('onNotificationDisplayedMethod');
  }

  /// Use this method to detect if the user dismissed a notification
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    debugPrint('onDismissActionReceivedMethod');
  }

  /// Use this method to detect when the user taps on a notification or action button
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    debugPrint('onActionReceivedMethod');
    final payload = receivedAction.payload ?? {};
    if (payload["navigate"] == "true") {
      MyApp.navigatorKey.currentState?.push(
        MaterialPageRoute(
            builder: (context) => BottomNavBar(index: 1,)
        ),
      );
    }
  }

  static Future<void> DailyNotification() async {
    // Define the list of specific times you want to show notifications (7 AM, 12 PM, 6 PM, and 9 PM).
    String localTimeZone =
    await AwesomeNotifications().getLocalTimeZoneIdentifier();
    List<int> notificationTimes = [8, 12, 18, 21];

    for (int i = 0; i < notificationTimes.length; i++) {

      await AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: i+1,
              // -1 is replaced by a random number
              channelKey: 'notification_daily',
              title: 'Quay lại Brain Train ngay nào',
              body: "Hãy quay lại để hoàn thành các bài tập và duy trì thói quen rèn luyện nhận thức 30 phút/ngày nhé.",
              payload: {
                "navigate": "true"
              }),
          actionButtons: [
            NotificationActionButton(key: 'REDIRECT', label: 'Quay lại nào!'),
          ],
          schedule: NotificationCalendar(
              hour: notificationTimes[i], timeZone: localTimeZone, repeats: false));
    }
  }

  static Future<void> TwoDayNotification() async {
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 6, // -1 is replaced by a random number
            channelKey: 'notification_checkout',
            title: 'Quay lại Brain Train ngay nào',
            body:
                "Đã 2 ngày bạn chưa rèn luyện nhận thức, hãy quay trở lại với BrainTrain ngay hôm nay!",
            payload: {
              "navigate": "true"
            }),
        actionButtons: [
          NotificationActionButton(key: 'REDIRECT', label: 'Quay lại nào!'),
        ],
        schedule: NotificationCalendar.fromDate(
            date: DateTime.now().add(const Duration(days: 2))));
  }

  static Future<void> FiveDayNotification() async {
    String localTimeZone =
        await AwesomeNotifications().getLocalTimeZoneIdentifier();
    String utcTimeZone =
        await AwesomeNotifications().getLocalTimeZoneIdentifier();
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 7, // -1 is replaced by a random number
            channelKey: 'notification_checkout',
            title: 'Quay lại Brain Train ngay nào',
            body:
                "Đã 5 ngày bạn chưa rèn luyện nhận thức, hãy quay trở lại với BrainTrain ngay hôm nay!",
            payload: {
              "navigate": "true"
            }),
        actionButtons: [
          NotificationActionButton(key: 'REDIRECT', label: 'Quay lại nào!'),
        ],
        schedule: NotificationCalendar.fromDate(
            date: DateTime.now().add(const Duration(days: 5))));
  }

  static Future<void> WeekNotification() async {
    String localTimeZone =
        await AwesomeNotifications().getLocalTimeZoneIdentifier();
    String utcTimeZone =
        await AwesomeNotifications().getLocalTimeZoneIdentifier();
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 8, // -1 is replaced by a random number
            channelKey: 'notification_checkout',
            title: 'Quay lại Brain Train ngay nào',
            body:
                "Đã 1 tuần bạn chưa rèn luyện nhận thức, hãy quay trở lại với BrainTrain ngay hôm nay!",
            payload: {
              "navigate": "true"
            }),
        actionButtons: [
          NotificationActionButton(key: 'REDIRECT', label: 'Quay lại nào!'),
        ],
        schedule: NotificationCalendar.fromDate(
            date: DateTime.now().add(const Duration(days: 7))));
  }

  static Future<void> ReminderNotification() async {
    String localTimeZone =
        await AwesomeNotifications().getLocalTimeZoneIdentifier();
    String utcTimeZone =
        await AwesomeNotifications().getLocalTimeZoneIdentifier();
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 9, // -1 is replaced by a random number
            channelKey: 'notification_reminder',
            title: 'Chào buổi sáng!',
            body: "Chào bạn ngày mới, bắt đầu luyện tập nào!",
            notificationLayout: NotificationLayout.BigPicture,
            bigPicture:
                "https://cdn.dribbble.com/users/793051/screenshots/11081607/media/ad0290a9e90885d64ecc080c181a1f33.jpg", // Replace with your GIF image URL or local file path
            // customSound: "custom_sound.mp3",
            payload: {
              "navigate": "true"
            }),
        actionButtons: [
          NotificationActionButton(key: 'REDIRECT', label: 'Luyện tập nào!'),
        ],
        schedule: NotificationCalendar(
            hour: 7, timeZone: localTimeZone, repeats: true));
  }

  static Future<void> cancelNotifications() async {
    await AwesomeNotifications()
        .cancelNotificationsByChannelKey("notification_daily");
  }

  static Future<void> cancelCheckoutNotifications() async {
    await AwesomeNotifications()
        .cancelNotificationsByChannelKey("notification_checkout");
  }

  static Future<void> showNotification({
    required final String title,
    required final String body,
    final String? summary,
    final Map<String, String>? payload,
    final ActionType actionType = ActionType.Default,
    final NotificationLayout notificationLayout = NotificationLayout.Default,
    final NotificationCategory? category,
    final String? bigPicture,
    final List<NotificationActionButton>? actionButtons,
    final bool scheduled = false,
    final int? interval,
    final bool repeats = false,
  }) async {
    assert(!scheduled || (scheduled && interval != null));

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: -1,
        channelKey: 'notification_daily',
        title: title,
        body: body,
        actionType: actionType,
        notificationLayout: notificationLayout,
        summary: summary,
        category: category,
        payload: payload,
        bigPicture: bigPicture,
      ),
      actionButtons: actionButtons,
      schedule: scheduled
          ? NotificationInterval(
              interval: Duration(milliseconds: 1000),
              timeZone:
                  await AwesomeNotifications().getLocalTimeZoneIdentifier(),
              preciseAlarm: true,
            )
          : null,
    );
  }
}
