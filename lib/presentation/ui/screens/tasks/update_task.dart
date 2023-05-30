import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/core/constants/app_consts.dart';
import 'package:todo_list/core/theme/app_assets.dart';
import 'package:todo_list/core/theme/size_config.dart';
import 'package:todo_list/core/utils/show_snackbar.dart';
import 'package:todo_list/domain/models/todo.dart';
import 'package:todo_list/domain/viewmodel/todo_provider.dart';

import '../../widgets/custom_button.dart';

class UpdateTask extends StatefulWidget {
  final Todo todo;

  const UpdateTask({super.key, required this.todo});
  @override
  State<UpdateTask> createState() => _UpdateTaskState();
}

class _UpdateTaskState extends State<UpdateTask> {
  final _titleController = TextEditingController();
  final _placeController = TextEditingController();
  final _descController = TextEditingController();
  DateTime? chosenDateTime;
  String? dob;
  bool isCompleted = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final user = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() {
    _titleController.text = widget.todo.title;
    _placeController.text = widget.todo.place;
    _descController.text = widget.todo.desc;
    isCompleted = widget.todo.complete;
    var dateTime =
        DateFormat("yyyy-MM-dd").parse(widget.todo.time.toString(), true);
    var dateLocal = DateFormat.yMMMMd().format(dateTime.toLocal());
    dob = dateLocal;
    chosenDateTime = widget.todo.time;
  }

  //android datepicker
  androidDatePicker(BuildContext context) async {
    chosenDateTime = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
    );
    print(chosenDateTime);

    setState(() {
      if (chosenDateTime != null) {
        dob =
            '${chosenDateTime!.day}-${chosenDateTime!.month}-${chosenDateTime!.year}';
      } else {
        dob = null;
      }
    });
  }

  //ios date picker
  iosDatePicker(BuildContext context) {
    var now = DateTime.now();
    var minDate = DateTime.now();
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext builder) {
          return Container(
              height: MediaQuery.of(context).copyWith().size.height * 0.30,
              color: Colors.white,
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              chosenDateTime = null;
                              Navigator.of(context).pop();
                            },
                            child: const DefaultTextStyle(
                              style: TextStyle(),
                              child: Text(
                                AppConsts.cancelButton,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () =>
                                Navigator.of(context).pop(chosenDateTime),
                            child: const DefaultTextStyle(
                              style: TextStyle(),
                              child: Text(
                                AppConsts.doneButton,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    flex: 3,
                    child: CupertinoDatePicker(
                      maximumDate: DateTime(2050),
                      minimumDate: minDate,
                      mode: CupertinoDatePickerMode.date,
                      onDateTimeChanged: (value) {
                        chosenDateTime = value;
                        if (chosenDateTime != null) {
                          dob =
                              '${chosenDateTime!.day}-${chosenDateTime!.month}-${chosenDateTime!.year}';
                        } else {
                          dob = null;
                        }
                        // print(chosenDateTime);
                      },
                      initialDateTime:
                          DateTime.now().subtract(const Duration(minutes: 1)),
                      minimumYear: 1920,
                      maximumYear: DateTime.now().year,
                    ),
                  )
                ],
              ));
        }).then((value) {
      if (value != null) {
        setState(() {});
        print('value is ${value.toString()}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.blueAccent,
        ),
        backgroundColor: Colors.indigo,
        title: const Text("Update Task",
            style: TextStyle(fontWeight: FontWeight.w400)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Scaffold(
        body: Container(
          color: Colors.indigo,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(70),
                        border:
                            Border.all(color: Colors.white.withOpacity(0.6))),
                    padding: const EdgeInsets.all(25),
                    margin: const EdgeInsets.all(10),
                    child: Image.asset(
                      AppAssets.pen,
                      fit: BoxFit.contain,
                      height: 50,
                      width: 50,
                    )),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _titleController,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  decoration: const InputDecoration(
                      hintText: AppConsts.title,
                      hintStyle: TextStyle(
                        color: Colors.white,
                      )),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _descController,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  decoration: const InputDecoration(
                      hintText: AppConsts.description,
                      hintStyle: TextStyle(
                        color: Colors.white,
                      )),
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () async {
                    if (defaultTargetPlatform == TargetPlatform.macOS ||
                        defaultTargetPlatform == TargetPlatform.iOS) {
                      iosDatePicker(context);
                    } else {
                      androidDatePicker(context);
                    }
                  },
                  child: Container(
                    // height: 50,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: 1, color: Colors.black54),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: SizeConfig.textMultiplier! * 1.5,
                          horizontal: SizeConfig.textMultiplier! * 0.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            dob != null ? dob! : AppConsts.pleaseSelect,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.only(top: 0),
                            child: const Icon(
                              Icons.arrow_drop_down_outlined,
                              color: Colors.white,
                              size: 24,
                            ),
                            height: 20,
                            width: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _placeController,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  decoration: const InputDecoration(
                      hintText: AppConsts.place,
                      hintStyle: TextStyle(
                        color: Colors.white,
                      )),
                ),
                const SizedBox(
                  height: 10,
                ),
                SwitchListTile(
                  title: const Text(
                    AppConsts.completed2,
                    style: TextStyle(color: Colors.white),
                  ),
                  visualDensity: VisualDensity.compact,
                  contentPadding: EdgeInsets.zero, activeColor: Colors.white,
                  value: isCompleted,

                  onChanged: (val) {
                    // widget.todo.complete=val;
                    setState(() {
                      isCompleted = val;
                    });
                  }, // changed from (value) => updateValue
                ),
                const SizedBox(
                  height: 40,
                ),
                CustomButton(
                    onTap: () {
                      context
                          .read<TodoProvider>()
                          .updateTodo(
                              Todo(
                                  title: _titleController.text.trim(),
                                  place: _placeController.text,
                                  desc: _descController.text,
                                  time: chosenDateTime!,
                                  id: widget.todo.id,
                                  complete: isCompleted,
                                  userId: user.uid),
                              user.uid,
                              context)
                          .whenComplete(() {
                        showSnackBar(context, AppConsts.updateSuccess,
                            color: Colors.green); //
                        Future.delayed(
                            const Duration(seconds: 3),
                            () => Navigator.of(context)
                                .pop(true)); // Displaying the error message
                      });
                    },
                    text: AppConsts.update)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
