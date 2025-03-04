import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app_pro_1/data/hive_data_store.dart';
import 'package:todo_app_pro_1/models/task.dart';
import 'package:todo_app_pro_1/views/home/home_view.dart';

Future<void> main() async {
  // Init hive db before runapp
  await Hive.initFlutter();

  // register hive adapter
  Hive.registerAdapter<Task>(TaskAdapter());

  // open a box
  Box box = await Hive.openBox<Task>(HiveDataStore.boxName);

  // (optional)
  // by implementing this line tasks that have been written but not marked
  // as done within a day wil be automated
  // and removed from the database the following day
  box.values.forEach((task) {
    if (task.createdAtTime.day != DateTime.now().day) {
      task.delete();
    } else {
      // do nothing
    }
  });

  // runApp(const MainApp());
  runApp(BaseWidget(child: const MainApp()));
}

// Creating a inherited widget to streamlinethe management of our app data
class BaseWidget extends InheritedWidget {
  BaseWidget({Key? key, required this.child}) : super(key: key, child: child);
  final HiveDataStore dataStore = HiveDataStore();
  final Widget child;

  static BaseWidget of(BuildContext context) {
    final base = context.dependOnInheritedWidgetOfExactType<BaseWidget>();
    if (base != null) {
      return base;
    } else {
      throw StateError('Could not find ancestor widget of type BaseWidget');
    }
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    throw false;
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeView(),
      // home: TaskView(),
    );
  }
}
