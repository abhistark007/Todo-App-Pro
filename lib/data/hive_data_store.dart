import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app_pro_1/models/task.dart';

// All the CRUD operation method for hive db
class HiveDataStore {
  // Box name - String
  static const boxName = 'taskBox';

  // Our current box with all the data inside - Box<Task>
  final Box<Task> box = Hive.box<Task>(boxName);

  // Add New Task To Box
  Future<void> addTask({required Task task}) async {
    await box.put(task.id, task);
  }

  // Show Task
  Future<Task?> getTask({required String id}) async {
    return box.get(id);
  }

  // update task
  Future<void> updateTask({required Task task}) async {
    await task.save();
  }

  // delete task
  Future<void> deleteTask({required Task task}) async {
    await task.delete();
  }

  // Listen to box changes
  // using this method we will listen to box changes and update the
  // UI accordingly
  ValueListenable<Box<Task>> listenToTask() => box.listenable();
}
