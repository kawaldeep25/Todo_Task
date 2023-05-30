import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/core/constants/app_consts.dart';
import 'package:todo_list/core/theme/app_textstyles.dart';
import 'package:todo_list/core/utils/utils.dart';
import 'package:todo_list/domain/viewmodel/todo_provider.dart';
import 'package:todo_list/presentation/ui/screens/tasks/update_task.dart';

class TaskList extends StatefulWidget {
  const TaskList({super.key});

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return Consumer<TodoProvider>(builder: ((context, todoData, _) {
      if (todoData.loadScreen) {
        return buildLoader();
      } else if (todoData.todos.isEmpty) {
        return const Center(
            child: Text(
          AppConsts.noTask,
          style: AppTextStyles.body2,
        ));
      } else if (todoData.todos.isNotEmpty) {
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: ((context, index) {
            var dateTime = DateFormat("yyyy-MM-dd")
                .parse(todoData.todos[index].time.toString(), true);
            var dateLocal = DateFormat.yMMMMd().format(dateTime.toLocal());
            return Column(
              children: [
                ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.edit),
                  ),
                  onTap: () async {
                    bool response = await context
                        .read<TodoProvider>()
                        .viewTodo(todoData.todos[index], user.uid, context);
                    if (response) {
                      var result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UpdateTask(
                                    todo: todoData.todos[index],
                                  )));
                      if (result != null && result) {
                        context.read<TodoProvider>().readAllTodo();
                      }
                    }
                  },
                  subtitle: Text(todoData.todos[index].place),
                  title: Text(todoData.todos[index].title),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(dateLocal),
                      IconButton(
                          onPressed: () {
                            context.read<TodoProvider>().deleteTodo(
                                todoData.todos[index], user.uid, context);
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
          itemCount: todoData.todos.length,
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
