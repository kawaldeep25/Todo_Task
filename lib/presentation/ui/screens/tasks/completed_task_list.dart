import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/core/constants/app_consts.dart';
import 'package:todo_list/core/theme/app_textstyles.dart';
import 'package:todo_list/domain/viewmodel/todo_provider.dart';

class CompletedTaskList extends StatefulWidget {
  const CompletedTaskList({super.key});

  @override
  State<CompletedTaskList> createState() => _CompletedTaskListState();
}

class _CompletedTaskListState extends State<CompletedTaskList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return Consumer<TodoProvider>(builder: ((context, todoData, _) {
      if (todoData.todosCompleted.isEmpty) {
        return const SizedBox();
      } else if (todoData.todosCompleted.isNotEmpty) {
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: ((context, index) {
            var dateTime = DateFormat("yyyy-MM-dd")
                .parse(todoData.todosCompleted[index].time.toString(), true);
            var dateLocal = DateFormat.yMMMMd().format(dateTime.toLocal());
            return Column(
              children: [
                ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.done),
                  ),
                  onTap: () async {
                    // bool response = await context.read<TodoProvider>().viewTodo(
                    //     todoData.todosCompleted[index], user.uid, context);
                    // if (response) {
                    //   var result = await Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //           builder: (context) => UpdateTask(
                    //                 todo: todoData.todosCompleted[index],
                    //               )));
                    //   if (result != null && result) {
                    //     context.read<TodoProvider>().readAllTodo();
                    //   }
                    // }
                  },
                  subtitle: Text(todoData.todosCompleted[index].place),
                  title: Text(todoData.todosCompleted[index].title),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(dateLocal),
                      IconButton(
                          onPressed: () {
                            context.read<TodoProvider>().deleteTodo(
                                todoData.todosCompleted[index],
                                user.uid,
                                context);
                          },
                          icon: const Icon(Icons.delete))
                    ],
                  ),
                ),
                const Divider(
                  thickness: 2,
                ),
              ],
            );
          }),
          itemCount: todoData.todosCompleted.length,
        );
      } else {
        return const Center(
            child: Text(
          AppConsts.todosErrorTopMsgTxt,
          style: AppTextStyles.body2,
        ));
      }
    }));
  }
}
