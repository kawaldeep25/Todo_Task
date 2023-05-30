import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_list/core/constants/app_consts.dart';
import 'package:todo_list/core/utils/utils.dart';
import 'package:todo_list/domain/models/todo.dart';

/*
This class represent all possible api operation for Firebase happens.
 */
class FirebaseApi {
  static FirebaseApi? _instance;
  FirebaseApi._();

  static FirebaseApi? get instance {
    // ignore: prefer_conditional_assignment
    if (_instance == null) {
      _instance = FirebaseApi._();
    }
    return _instance;
  }

  Future<String?> createTodo(Todo todo) async {
    final docTodo =
        FirebaseFirestore.instance.collection(AppConsts.collectionName).doc();

    todo.id = docTodo.id;
    await docTodo.set(todo.toJson());

    return docTodo.id;
  }

  static Stream<List<Todo>> readTodos() {
    return FirebaseFirestore.instance
        .collection(AppConsts.collectionName)
        .snapshots()
        .transform(Utils.transformer(Todo.fromJson));
  }

  Future<List<Todo>>? readData() async {
    List<Todo> toDoList = [];
    await FirebaseFirestore.instance
        .collection(AppConsts.collectionName)
        // .where('userId', isEqualTo: userId)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        print('id is ${doc['title']}');

        var todo = Todo(
            id: doc['id'],
            title: doc['title'],
            complete: doc['complete'],
            time: doc['time'].toDate(),
            desc: doc['desc'],
            userId: doc['userId'],
            place: doc['place']);
        toDoList.add(todo);
      }
    });
    return toDoList;
  }

  Future<List<Todo>>? readDataByDate(userId) async {
    List<Todo> toDoList = [];
    await FirebaseFirestore.instance
        .collection(AppConsts.collectionName)
        // .where('userId', isEqualTo: userId)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        var todo = Todo(
            id: doc['id'],
            title: doc['title'],
            complete: doc['complete'],
            time: doc['time'],
            desc: doc['desc'],
            userId: doc['userId'],
            place: doc['place']);
        toDoList.add(todo);
      }
    });
    return toDoList;
  }

  Future<String?> updateTodo(Todo updatedTodo, String userId) async {
    try {
      final docTodo = FirebaseFirestore.instance
          .collection(AppConsts.collectionName)
          .doc(updatedTodo.id);
      return docTodo.get().then((doc) async {
        await docTodo.update(updatedTodo.toJson());
        return 'Success';
      });
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> deleteTodo(Todo todo, String userId) async {
    try {
      final docTodo = FirebaseFirestore.instance
          .collection(AppConsts.collectionName)
          .doc(todo.id);
      return docTodo.get().then((doc) async {
        await docTodo.delete();
        return 'Success';
      });
    } catch (e) {
      return e.toString();
    }
  }
}
