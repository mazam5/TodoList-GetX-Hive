import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_list_app/controller/hive_controller.dart';
import 'package:todo_list_app/controller/notifications_controller.dart';
import 'package:todo_list_app/model/task_model.dart';
import 'package:todo_list_app/view/tasks_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // if (Platform.isAndroid) {
  //   debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  // }
  // Initialize Hive and register the Task adapter
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());

  // Open the tasks box
  await Hive.openBox<Task>('newtasks');

  // Initialize notifications
  await NotificationController.initializeLocalNotifications();
  await NotificationController.initializeIsolateReceivePort();

  // Run the Flutter app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      title: 'Todo List App',
      navigatorKey: navigatorKey,
      home: MainScreen(),
    );
  }
}
