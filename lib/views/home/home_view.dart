import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:todo_app_pro_1/extensions/space_exs.dart';
import 'package:todo_app_pro_1/main.dart';
import 'package:todo_app_pro_1/models/task.dart';
import 'package:todo_app_pro_1/utils/app_colors.dart';
import 'package:todo_app_pro_1/utils/app_str.dart';
import 'package:todo_app_pro_1/utils/constants.dart';
import 'package:todo_app_pro_1/views/home/components/home_app_bar.dart';
import 'package:todo_app_pro_1/views/home/components/slider_drawer.dart';
import 'package:todo_app_pro_1/views/home/widget/fab.dart';
import 'package:todo_app_pro_1/views/home/widget/task_widget.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  GlobalKey<SliderDrawerState> drawerKey = GlobalKey<SliderDrawerState>();

  // check value of circle indicator
  dynamic valueOfIndicator(List<Task> task) {
    if (task.isNotEmpty) {
      return task.length;
    } else {
      return 3;
    }
  }

  // Check done tasks
  int checkDoneTask(List<Task> tasks) {
    int i = 0;
    for (Task doneTask in tasks) {
      if (doneTask.isCompleted) {
        i++;
      }
    }
    return i;
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    final base = BaseWidget.of(context);

    return ValueListenableBuilder(
      valueListenable: base.dataStore.listenToTask(),
      builder: (ctx, Box<Task> box, Widget? child) {
        var tasks = box.values.toList();
        tasks.sort((a, b) => a.createdAtDate.compareTo(b.createdAtDate));
        return Scaffold(
          backgroundColor: Colors.white,

          // FAB
          floatingActionButton: Fab(),

          // Body
          // body: _buildHomeBody(textTheme)
          body: SliderDrawer(
            key: drawerKey,
            isDraggable: false,
            animationDuration: 1000,
            // Drawer
            slider: CustomDrawer(),

            // Drawer App Bar
            appBar: HomeAppBar(drawerKey: drawerKey),

            // Main Body
            child: _buildHomeBody(textTheme, base, tasks),
          ),
        );
      },
    );
  }

  // Home Body
  Widget _buildHomeBody(
    TextTheme textTheme,
    BaseWidget base,
    List<Task> tasks,
  ) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          // Custom AppBar
          Container(
            margin: EdgeInsets.only(top: 60),
            width: double.infinity,
            height: 100,

            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Progress Indicator
                SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    value: checkDoneTask(tasks) / valueOfIndicator(tasks),
                    backgroundColor: Colors.grey,
                    valueColor: AlwaysStoppedAnimation(AppColors.primaryColor),
                  ),
                ),

                25.w,

                // Top Level Task Info
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(AppStr.mainTitle, style: textTheme.displayLarge),
                    3.h,
                    Text(
                      "${checkDoneTask(tasks)} of ${tasks.length} task",
                      style: textTheme.titleMedium,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Divider
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Divider(thickness: 2, indent: 100),
          ),

          // Tasks
          Expanded(
            child: SizedBox(
              width: double.infinity,
              height: 720,
              child:
                  tasks.isNotEmpty
                      ? ListView.builder(
                        itemCount: tasks.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          // set single task for showing to list
                          var task = tasks[index];
                          return Dismissible(
                            direction: DismissDirection.horizontal,
                            onDismissed: (_) {
                              // We will remove current task from DB
                              base.dataStore.deleteTask(task: task);
                            },
                            background: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.delete_outline, color: Colors.grey),
                                8.w,
                                Text(
                                  AppStr.deletedTask,
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                            key: Key(task.id),
                            child: TaskWidget(task: task),
                          );
                        },
                      )
                      : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FadeIn(
                            child: SizedBox(
                              width: 200,
                              height: 200,
                              child: Lottie.asset(
                                lottieURL,
                                animate: tasks.isNotEmpty ? false : true,
                              ),
                            ),
                          ),
                          FadeInUp(from: 30, child: Text(AppStr.doneAllTask)),
                        ],
                      ),
            ),
          ),

          //
        ],
      ),
    );
  }
}
