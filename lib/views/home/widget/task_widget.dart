import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app_pro_1/models/task.dart';
import 'package:todo_app_pro_1/utils/app_colors.dart';
import 'package:todo_app_pro_1/views/tasks/task_view.dart';

class TaskWidget extends StatefulWidget {
  const TaskWidget({super.key, required this.task});

  final Task task;

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  TextEditingController textEditingControllerTitle = TextEditingController();
  TextEditingController textEditingControllerSubTitle = TextEditingController();

  @override
  void initState() {
    textEditingControllerTitle.text = widget.task.title;
    textEditingControllerSubTitle.text = widget.task.subTitle;
    super.initState();
  }

  @override
  void dispose() {
    textEditingControllerTitle.dispose();
    textEditingControllerSubTitle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to task view to see task details
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder:
                (ctx) => TaskView(
                  titleTaskController: textEditingControllerTitle,
                  descriptionTaskController: textEditingControllerSubTitle,
                  task: widget.task,
                ),
          ),
        );
      },
      child: AnimatedContainer(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color:
              widget.task.isCompleted
                  ? AppColors.primaryColor.withOpacity(0.1)
                  : Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.1),
              offset: Offset(0, 4),
              blurRadius: 10,
            ),
          ],
        ),
        duration: Duration(milliseconds: 600),
        child: ListTile(
          // Check Icon
          leading: GestureDetector(
            onTap: () {
              // check or uncheck the task
              widget.task.isCompleted = !widget.task.isCompleted;
              widget.task.save();
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 600),
              decoration: BoxDecoration(
                color:
                    widget.task.isCompleted
                        ? AppColors.primaryColor
                        : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey, width: 0.8),
              ),
              child: Icon(Icons.check, color: Colors.white),
            ),
          ),

          //task title
          title: Padding(
            padding: const EdgeInsets.only(bottom: 5, top: 3),
            child: Text(
              textEditingControllerTitle.text,
              style: TextStyle(
                color:
                    widget.task.isCompleted
                        ? AppColors.primaryColor
                        : Colors.black,
                fontWeight: FontWeight.w500,
                decoration:
                    widget.task.isCompleted ? TextDecoration.lineThrough : null,
              ),
            ),
          ),

          // Task description
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                textEditingControllerSubTitle.text,
                style: TextStyle(
                  color:
                      widget.task.isCompleted
                          ? AppColors.primaryColor
                          : Colors.black,
                  fontWeight: FontWeight.w300,
                  decoration:
                      widget.task.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                ),
              ),

              // Date of Task
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10, top: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('hh:mm a').format(widget.task.createdAtTime),
                        style: TextStyle(
                          fontSize: 14,
                          color:
                              widget.task.isCompleted
                                  ? Colors.white
                                  : Colors.grey,
                        ),
                      ),
                      Text(
                        DateFormat.yMMMEd().format(widget.task.createdAtDate),
                        style: TextStyle(
                          fontSize: 14,
                          color:
                              widget.task.isCompleted
                                  ? Colors.white
                                  : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
