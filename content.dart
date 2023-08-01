import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'home.dart';
import 'update.dart';

class FetchData extends StatefulWidget {
  const FetchData({Key? key}) : super(key: key);

  @override
  State<FetchData> createState() => _FetchDataState();
}

class _FetchDataState extends State<FetchData> {
  final DatabaseReference databaseRef = FirebaseDatabase.instance.ref().child('Pills');
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  Map<String, Map<dynamic, dynamic>>? pillData;

  @override
  void initState() {
    super.initState();
    pillData = {};
    fetchContainerData('Container1');
    fetchContainerData('Container2');
    fetchContainerData('Container3');
    fetchContainerData('Container4');
    initializeNotifications();
  }

  Future<void> initializeNotifications() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@drawable/launch_image'); // Replace 'app_icon' with your own app icon image

    final InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);
    if (!mounted) return;
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Remove channel ID (optional if not needed)
    const String channelName = 'Smart Pillbox'; // Replace with your own channel name
    const String channelDescription = 'It is time to take your pill'; // Replace with your own channel description

    const AndroidNotificationChannel androidNotificationChannel = AndroidNotificationChannel(
      //'your_channel_id', // Replace 'your_channel_id' with your own channel ID (optional)
      channelName,
      channelDescription,
      importance: Importance.max,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidNotificationChannel);
  }

  Future<void> fetchContainerData(String containerKey) async {
    try {
      DatabaseReference containerRef = databaseRef.child(containerKey);
      DataSnapshot snapshot = await containerRef.once().then((event) => event.snapshot);
      if (!mounted) return;
      if (snapshot.value != null) {
        // Cast the snapshot value to Map<dynamic, dynamic>?
        Map<dynamic, dynamic>? containerData = snapshot.value as Map<dynamic, dynamic>?;

        if (containerData != null) {
          containerData['title'] = containerKey;
          setState(() {
            pillData![containerKey] = containerData;
          });
        }
      }
    } catch (error) {
      print('Error fetching container data: $error');
    }
  }

  Future<void> scheduleNotification(int notificationId, DateTime notificationDateTime) async {
    // Replace 'your_local_timezone' with your own timezone (e.g., 'America/New_York')
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));

    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime.from(notificationDateTime, tz.local);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    print('Notification ID: $notificationId');
    print('Scheduled Date: $scheduledDate');

    final androidPlatformChannelSpecifics = const NotificationDetails(
      android: AndroidNotificationDetails(
        'Smart Pillbox', // Replace 'Smart Pillbox' with your own channel name
        'It is time to take your pill', // Replace with your own channel description
        importance: Importance.max,
      ),
    );

    // You can add customizations for iOS notifications here if needed
    final iOSPlatformChannelSpecifics = const NotificationDetails();

    await flutterLocalNotificationsPlugin.zonedSchedule(
      notificationId,
      'Smart Pillbox',
      'It is time to take your pill from container',
      scheduledDate,
      androidPlatformChannelSpecifics,
      payload: 'default',
      matchDateTimeComponents: DateTimeComponents.time,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      // iOSPlatformChannelSpecifics: iOSPlatformChannelSpecifics,
    );
  }






  Widget buildPillItem(String containerKey) {
    if (pillData == null ||
        pillData!.isEmpty ||
        pillData![containerKey] == null ||
        pillData![containerKey]!.isEmpty) {
      return SizedBox.shrink(); // Return an empty widget or a loading indicator
    }

    final containerData = pillData![containerKey];

    if (containerData == null) {
      return SizedBox.shrink(); // Return an empty widget or a loading indicator
    }

    final String title = containerData['title'] ?? '';
    final String pillName = containerData['pillname'] ?? '';
    final String pillDose = containerData['pilldose'] ?? '';
    final String slot = containerData['slot'] ?? '';
    final int? hour = containerData['hour'] is int ? containerData['hour'] : int.tryParse(containerData['hour'].toString() ?? '');
    final int? minute = containerData['minute'] is int ? containerData['minute'] : int.tryParse(containerData['minute'].toString() ?? '');

    final String date = containerData['Date'] ?? '';
    final String description = containerData['Description'] ?? '';

    if (hour != null && minute != null && hour >= 0 && hour < 24 && minute >= 0 && minute < 60) {
      // Convert hour and minute to DateTime with today's date
      final now = DateTime.now();
      final notificationDateTime = DateTime(now.year, now.month, now.day, hour, minute);

      scheduleNotification(containerKey.hashCode, notificationDateTime);
    } else {
      print('Invalid hour or minute value: $hour:$minute');
    }


    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(5),
      color: Colors.lightBlueAccent[100],
      child: ListTile(
        shape: const RoundedRectangleBorder(
          side: BorderSide(width: 0.5, color: Colors.black12),
          borderRadius: BorderRadius.zero,
        ),
        leading: const Icon(
          Icons.medication_rounded,
          color: Colors.blue,
          size: 45.0,
        ),
        title: Text(
          containerData['title'] ?? '',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                text: 'Pill Name: ',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                children: [
                  TextSpan(
                    text: containerData['pillname'] ?? '',
                    style: const TextStyle(fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                text: 'Pill Dose: ',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                children: [
                  TextSpan(
                    text: containerData['pilldose'] ?? '',
                    style: const TextStyle(fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                text: 'Slot: ',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                children: [
                  TextSpan(
                    text: containerData['slot'] ?? '',
                    style: const TextStyle(fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                text: 'Time: ',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                children: [
                  TextSpan(
                    text: '${containerData['hour'].toString().padLeft(2, '0')}:${containerData['minute'].toString().padLeft(2, '0')}',
                    style: const TextStyle(fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                text: 'Date: ',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                children: [
                  TextSpan(
                    text: containerData['Date'] ?? '',
                    style: const TextStyle(fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                text: 'About: ',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                children: [
                  TextSpan(
                    text: containerData['Description'] ?? '',
                    style: const TextStyle(fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () async {
                final updatedData = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UpdateRecord(
                      pillsKey: containerKey,
                      containerData: containerData,
                    ),
                  ),
                );

                // Check if data was updated on the UpdateRecord page
                // and update the local data in FetchData if needed
                if (updatedData != null && updatedData is Map<String, dynamic>) {
                  setState(() {
                    // Update the local data with the updated data
                    pillData![containerKey] = updatedData;
                  });
                }
              },
              child: Icon(
                Icons.edit,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(width: 6),
            GestureDetector(
              onTap: () {
                DatabaseReference itemRef = databaseRef.child(containerKey);
                itemRef.remove().then((_) {
                  // Remove the container from pillData after successful deletion
                  setState(() {
                    pillData!.remove(containerKey);
                  });
                }).catchError((error) {
                  print('Error deleting data: $error');
                });
              },
              child: Icon(
                Icons.delete,
                color: Colors.red[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent[100],
        title: const Text('Smart Pillbox'),
      ),
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.all(20),
            child: buildPillItem('Container1'),
          ),
          Container(
            margin: const EdgeInsets.all(20),
            child: buildPillItem('Container2'),
          ),
          Container(
            margin: const EdgeInsets.all(20),
            child: buildPillItem('Container3'),
          ),
          Container(
            margin: const EdgeInsets.all(20),
            child: buildPillItem('Container4'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const homeApp()),
          );
        },
        backgroundColor: Colors.lightBlueAccent[100]!,
        splashColor: Colors.lightBlueAccent,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}
