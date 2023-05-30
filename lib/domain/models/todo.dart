import 'package:todo_list/core/utils/utils.dart';

class Todo {
  String? id;
  String title;
  String place;
  String desc;
  DateTime time;
  bool complete;
  final String? userId;

  Todo({
    this.id,
    required this.title,
    required this.place,
    required this.desc,
    required this.time,
    this.userId,
    this.complete = false,
  });

  // factory Todo.fromMap(Map<String, dynamic> data, String documentId) {
  //   String title = data['title'];
  //   String place = data['place'];
  //   String desc = data['desc'];
  //   DateTime time = data['time'];
  //   String userId = data['userId'];
  //
  //   bool complete = data['complete'];
  //
  //   return Todo(
  //       id: documentId,
  //       title: title,
  //       place: place,
  //       desc: desc,
  //       time: time,
  //       userId: userId,
  //       complete: complete);
  // }

  static Todo fromJson(Map<String, dynamic> json) => Todo(
        time: (json['time']),
        title: json['title'],
        desc: json['desc'],
        id: json['id'],
        complete: json['complete'],
        userId: json['userId'],
        place: json['place'],
      );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'place': place,
      'desc': desc,
      'time': Utils.fromDateTimeToJson(time),
      'userId': userId,
      'complete': complete,
    };
  }

  // Map<String, dynamic> toMap() {
  //   return {
  //     'id': id,
  //     'title': title,
  //     'place': place,
  //     'desc': desc,
  //     'time': Utils.fromDateTimeToJson(time),
  //     'userId': userId,
  //     'complete': complete,
  //   };
  // }
}
