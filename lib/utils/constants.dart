import 'package:flutter/widgets.dart';
import 'package:ftoast/ftoast.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:todo_app_pro_1/main.dart';
import 'package:todo_app_pro_1/utils/app_str.dart';

String lottieURL = 'assets/lottie/1.json';

// empty title or subtitle textfield warning

dynamic emptyWarning(BuildContext context) {
  return FToast.toast(
    context,
    msg: AppStr.oopsMsg,
    subMsg: 'You Must fill all fields',
    corner: 20,
    duration: 2000,
    padding: EdgeInsets.all(20),
  );
}

//nothing entered when user try to edit or update the current task
dynamic updateTaskWarning(BuildContext context) {
  return FToast.toast(
    context,
    msg: AppStr.oopsMsg,
    subMsg: 'You Must edit the tasks then try to update it',
    corner: 20,
    duration: 3000,
    padding: EdgeInsets.all(20),
  );
}

// No task warning dialog box for deleting
dynamic noTaskWarning(BuildContext context) {
  return PanaraInfoDialog.showAnimatedGrow(
    context,
    title: AppStr.oopsMsg,
    message:
        "There is no task for delete!\n Try adding some and then try to delete it",
    buttonText: "Okay",
    onTapDismiss: () {
      Navigator.pop(context);
    },
    panaraDialogType: PanaraDialogType.warning,
  );
}

// delete all task from db dialog
dynamic deleteAllTask(BuildContext context) {
  return PanaraConfirmDialog.show(
    context,
    title: AppStr.areYouSure,
    message:
        "Do you really want to delete all tasks? you will not be able to undo this action",
    confirmButtonText: "yes",
    cancelButtonText: "No",
    onTapConfirm: () {
      // we will clear all the box data using this command later on
      BaseWidget.of(context).dataStore.box.clear();
      Navigator.pop(context);
    },
    onTapCancel: () {
      Navigator.pop(context);
    },
    panaraDialogType: PanaraDialogType.error,
    barrierDismissible: false,
  );
}
