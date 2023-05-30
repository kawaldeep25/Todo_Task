import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/domain/viewmodel/auth_provider.dart';
import 'package:todo_list/domain/viewmodel/todo_provider.dart';
import 'package:todo_list/presentation/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(),
        ),
        ChangeNotifierProvider<TodoProvider>(
          create: (context) => TodoProvider(),
        )
      ],
      child: const MyApp(
        key: Key('MyApp'),
      )));
}
