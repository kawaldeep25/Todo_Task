import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/core/utils/utils.dart';
import 'package:todo_list/data/remote/firebase_service.dart';
import 'package:todo_list/domain/models/todo.dart';

/*
This class represent all possible Todolist linkage to UI happens.
 */

class TodoProvider with ChangeNotifier {
  List<Todo> _todos = [];

  bool isLoader = true;

  set _isLoading(bool value) {
    isLoader = value;
    notifyListeners();
  }

  get loadScreen => isLoader;

  List<Todo> get todoList => _todos;

  List<Todo> get todos =>
      _todos.where((todo) => todo.complete == false).toList();

  List<Todo> get todosCompleted =>
      _todos.where((todo) => todo.complete == true).toList();

  //Method to retrieve all todos item from the same user based on uid
  Future<void> readAllTodo() async {
    _todos = await FirebaseApi.instance!.readData()!;
    // _todos.sort((a, b) => a.time.compareTo(b.time));
    _isLoading = false;
    notifyListeners();
    return;
  }

  //Method to view/edit todoModel entry
  Future<bool> viewTodo(Todo todo, String uid, BuildContext context) async {
    if (uid == todo.userId) {
      notifyListeners();

      return true;
    } else {
      showSnackBar(context, 'You cannot edit this task',
          color: Colors.red); // Displaying the error message
      notifyListeners();

      return false;
    }
  }

  //Method to delete todoModel entry
  void deleteTodo(Todo todo, String uid, BuildContext context) async {
    if (uid == todo.userId) {
      var result = await FirebaseApi.instance!.deleteTodo(todo, uid);
      if (result == 'Success') {
        _todos.remove(todo);
      } else {
        showSnackBar(context, 'Some Error Occurred',
            color: Colors.red); // Displaying the error message
      }
    } else {
      showSnackBar(context, 'You cannot delete this task',
          color: Colors.red); // Displaying the error message
    }
    notifyListeners();
  }

  //
  //Method to mark all todoModel to be complete
  bool toggleTodoStatus(Todo todo, String userId, BuildContext context) {
    todo.complete = !todo.complete;
    FirebaseApi.instance!.updateTodo(todo, userId);

    return todo.complete;
  }

  Future<String?> updateTodo(
      Todo todo, String userId, BuildContext context) async {
    // todo.title = title;
    // todo.desc = description;
    // todo.time = updateddate;
    var result = await FirebaseApi.instance!.updateTodo(todo, userId);
    if (result == 'Success') {
      for (var element in _todos) {
        if (element.id == todo.id) {
          element = todo;
        }
      }
    } else {
      showSnackBar(context, 'Some Error Occurred',
          color: Colors.red); // Displaying the error message
    }
    notifyListeners();
    return 'Success';
  }

  Future<String?> updateTodoCompleted(Todo todo, String userId) async {
    todo.complete = true;
    return await FirebaseApi.instance!.updateTodo(todo, userId);
  }

  //Method to create/update todoModel
  Future<String?> addTaskToFirebase(User user, String title, String description,
      DateTime taskdate, String place) async {
    var userId = user.uid;
    var isComleted = false;

    final todoTask = Todo(
        title: title,
        place: place,
        desc: description,
        time: taskdate,
        complete: isComleted,
        userId: userId);
    return await FirebaseApi.instance!.createTodo(todoTask);
  }
}
