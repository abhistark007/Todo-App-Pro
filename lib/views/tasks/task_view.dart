import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart';
import 'package:intl/intl.dart';
import 'package:todo_app_pro_1/extensions/space_exs.dart';
import 'package:todo_app_pro_1/main.dart';
import 'package:todo_app_pro_1/models/task.dart';
import 'package:todo_app_pro_1/utils/app_colors.dart';
import 'package:todo_app_pro_1/utils/app_str.dart';
import 'package:todo_app_pro_1/utils/constants.dart';
import 'package:todo_app_pro_1/views/tasks/components/date_time_selection.dart';
import 'package:todo_app_pro_1/views/tasks/components/rep_textfield.dart';
import 'package:todo_app_pro_1/views/tasks/widget/task_view_app_bar.dart';

class TaskView extends StatefulWidget {
  const TaskView({
    super.key,
    required this.titleTaskController,
    required this.descriptionTaskController,
    this.task,
  });

  final TextEditingController? titleTaskController;
  final TextEditingController? descriptionTaskController;
  final Task? task;

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  var title;
  var subTitle;
  DateTime? time;
  DateTime? date;

  // Show selected time as String Format
  String showTime(DateTime? time) {
    if (widget.task?.createdAtTime == null) {
      if (time == null) {
        return DateFormat("hh:mm a").format(DateTime.now()).toString();
      } else {
        return DateFormat("hh:mm a").format(time).toString();
      }
    } else {
      return DateFormat(
        "hh:mm a",
      ).format(widget.task!.createdAtTime).toString();
    }
  }

  // Show selected time as String Format
  String showDate(DateTime? date) {
    if (widget.task?.createdAtDate == null) {
      if (date == null) {
        return DateFormat.yMMMEd().format(DateTime.now()).toString();
      } else {
        return DateFormat.yMMMEd().format(date).toString();
      }
    } else {
      return DateFormat.yMMMEd().format(widget.task!.createdAtDate).toString();
    }
  }

  // Show selected date as DateFormat for initTime
  DateTime showDateAsDateTime(DateTime? date) {
    if (widget.task?.createdAtDate == null) {
      if (date == null) {
        return DateTime.now();
      } else {
        return date;
      }
    } else {
      return widget.task!.createdAtDate;
    }
  }

  // if any task already exist return True otherwise false
  bool isTaskAlreadyExist() {
    if (widget.titleTaskController?.text == null &&
        widget.descriptionTaskController?.text == null) {
      return true;
    } else {
      return false;
    }
  }

  // Main function for updating or creating tasks
  dynamic isTaskAlreadyExisitUpdateOtherWiseCreate() {
    // Here we update current task
    if (widget.titleTaskController?.text != null &&
        widget.descriptionTaskController?.text != null) {
      try {
        widget.titleTaskController?.text = title;
        widget.descriptionTaskController?.text = subTitle;

        widget.task?.save();

        Navigator.pop(context);
      } catch (e) {
        // if user want to update task but entered nothing we will show
        // this warning
        updateTaskWarning(context);
      }
      // Here we create new task
    } else {
      if (title != null && subTitle != null) {
        var task = Task.create(
          title: title,
          subTitle: subTitle,
          createdAtDate: date,
          createdAtTime: time,
        );
        // we are adding this new task to hivedb
        BaseWidget.of(context).dataStore.addTask(task: task);
        Navigator.pop(context);
      } else {
        // Warning
        emptyWarning(context);
      }
    }
  }

  // delete task
  dynamic deleteTask() {
    return widget.task?.delete();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
        // Appbar
        appBar: TaskViewAppBar(),

        // body
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Top Side Texts
                _buildTopSideText(),

                // Main task view activity
                _buildMainTaskViewActivity(context),

                // bottom slide button
                _buildBottomSideButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // bottom slide button
  Widget _buildBottomSideButtons() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment:
            isTaskAlreadyExist()
                ? MainAxisAlignment.center
                : MainAxisAlignment.spaceEvenly,
        children: [
          isTaskAlreadyExist()
              ? Container()
              :
              // Delete current task button
              MaterialButton(
                onPressed: () {
                  log("Task Has Been Deleted!");
                  deleteTask();
                  Navigator.pop(context);
                },
                minWidth: 150,
                height: 55,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    Icon(Icons.close, color: AppColors.primaryColor),
                    5.w,
                    Text(
                      AppStr.deleteTask,
                      style: TextStyle(color: AppColors.primaryColor),
                    ),
                  ],
                ),
              ),

          // Add or update task
          MaterialButton(
            onPressed: () {
              log("New Task Has Been Added!");
              isTaskAlreadyExisitUpdateOtherWiseCreate();
            },
            minWidth: 150,
            height: 55,
            color: AppColors.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              isTaskAlreadyExist()
                  ? AppStr.addTaskString
                  : AppStr.updateTaskString,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // Main Task View Activity
  SizedBox _buildMainTaskViewActivity(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 530,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title of textfield
          Padding(
            padding: EdgeInsets.only(left: 30),
            child: Text(
              AppStr.titleOfTitleTextField,
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
          ),

          // Task Title
          RepTextField(
            controller: widget.titleTaskController,
            onChanged: (String inputTitle) {
              title = inputTitle;
            },
            onFieldSubmitted: (String inputTitle) {
              title = inputTitle;
            },
          ),

          10.h,

          // Task Title
          RepTextField(
            controller: widget.descriptionTaskController,
            isForDescription: true,
            onFieldSubmitted: (String inputSubTitle) {
              subTitle = inputSubTitle;
            },
            onChanged: (String inputSubTitle) {
              subTitle = inputSubTitle;
            },
          ),

          // Time Selector
          DateTimeSelectionWidget(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder:
                    (_) => SizedBox(
                      height: 280,
                      child: TimePickerWidget(
                        initDateTime: showDateAsDateTime(time),
                        onChange: (_, __) {},
                        dateFormat: "HH:mm",
                        onConfirm: (dateTime, _) {
                          setState(() {
                            if (widget.task?.createdAtTime == null) {
                              time = dateTime;
                            } else {
                              widget.task?.createdAtTime = dateTime;
                            }
                          });
                        },
                      ),
                    ),
              );
            },
            title: AppStr.timeString,
            time: showTime(time),
            isTime: false,
          ),

          // Date Selector
          DateTimeSelectionWidget(
            onTap: () {
              DatePicker.showDatePicker(
                context,
                maxDateTime: DateTime(2030, 4, 5),
                minDateTime: DateTime.now(),
                initialDateTime: showDateAsDateTime(date),
                onConfirm: (dateTime, _) {
                  setState(() {
                    if (widget.task?.createdAtDate == null) {
                      date = dateTime;
                    } else {
                      widget.task?.createdAtDate = dateTime;
                    }
                  });
                },
              );
            },
            title: AppStr.dateString,
            time: showDate(date),
            isTime: true,
          ),
        ],
      ),
    );
  }

  // Top Side Texts
  SizedBox _buildTopSideText() {
    return SizedBox(
      width: double.infinity,
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Divider - grey
          SizedBox(width: 70, child: Divider(thickness: 2)),

          // later on according to the tasks condition we
          // will decide to ADD NEW TASK or UPDATE CURRENT
          // task
          RichText(
            text: TextSpan(
              text:
                  isTaskAlreadyExist()
                      ? AppStr.addNewTask
                      : AppStr.updateCurrentTask,
              style: TextStyle(color: Colors.black, fontSize: 30),
              children: [
                TextSpan(
                  text: AppStr.taskString,
                  style: TextStyle(fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),

          // Divider - grey
          SizedBox(width: 70, child: Divider(thickness: 2)),
        ],
      ),
    );
  }
}
