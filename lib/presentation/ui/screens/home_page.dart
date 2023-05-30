// ignore_for_file: prefer_const_constructors

import 'package:circular_progress_stack/circular_progress_stack.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/core/constants/app_consts.dart';
import 'package:todo_list/core/theme/app_assets.dart';
import 'package:todo_list/domain/viewmodel/auth_provider.dart';
import 'package:todo_list/domain/viewmodel/todo_provider.dart';
import 'package:todo_list/presentation/ui/screens/auth/login_page.dart';
import 'package:todo_list/presentation/ui/screens/tasks/add_task.dart';
import 'package:todo_list/presentation/ui/screens/tasks/completed_task_list.dart';
import 'package:todo_list/presentation/ui/screens/tasks/task_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const ROUTE_NAME = 'HomePage';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    context.read<TodoProvider>().readAllTodo();
  }

  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Container(
          color: Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                currentAccountPicture: Icon(
                  Icons.account_circle_sharp,
                  color: Colors.white,
                  size: 84,
                ),
                accountEmail: Text(user.email!),
                accountName: null,
                decoration: BoxDecoration(color: Colors.blue.shade300),
              ),
              ListTile(
                title: GestureDetector(
                    onTap: (() {
                      _showLogoutDialog().then((value) {
                        if (value) {
                          final authProvider =
                              Provider.of<AuthProvider>(context, listen: false);

                          authProvider.signOut();
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              LoginPage.ROUTE_NAME,
                              (Route<dynamic> route) => false);
                          // RestartWidget.restartApp(context);
                        }
                      });
                    }),
                    child: Text(
                      AppConsts.settingLogoutButton,
                      style: TextStyle(color: Colors.black87),
                    )),
                trailing: Icon(Icons.logout),
              )
            ],
          ),
        ),
      ),
      key: _scaffoldKey,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.only(bottom: 0, top: 0),
                child: Stack(alignment: Alignment.center, children: [
                  Image.asset(AppAssets.mountain,
                      colorBlendMode: BlendMode.srcOver,
                      color: Colors.white.withOpacity(0.1)),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: ClipRect(
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2.4,
                        height: MediaQuery.of(context).size.height / 2.58,
                        decoration: BoxDecoration(
                            color: Colors.black54.withOpacity(0.1)),
                      ),
                    ),
                  ),
                  Positioned(
                      left: 0,
                      bottom: 0,
                      child: SizedBox(
                        height: 25,
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: <Widget>[
                            Container(
                              height: 5.0,
                              width: MediaQuery.of(context).size.width / 1.7,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: const [
                                      Color(0xFF8FA6FC),
                                      Color(0xFF3366FF),
                                      Color(0xFF00CCFF),
                                    ],
                                    begin: const FractionalOffset(0.0, 0.0),
                                    end: const FractionalOffset(1.0, 0.0),
                                    stops: const [0.0, 0.5, 1.0],
                                    tileMode: TileMode.clamp),
                              ),
                            ),
                            Container(
                              height: 5.0,
                              color: Colors.transparent,
                            ),
                          ],
                        ),
                      )),
                  Positioned(
                    left: 30,
                    top: 50,
                    child: Builder(builder: (context) {
                      return GestureDetector(
                        onTap: () {
                          Scaffold.of(context).openDrawer();
                        },
                        child: Icon(Icons.menu, color: Colors.white),
                      );
                    }),
                  ),
                  Positioned(
                    right: 0,
                    top: 40,
                    child: IconButton(
                        icon: Icon(
                          Icons.logout,
                          size: 30,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          _showLogoutDialog().then((value) {
                            if (value) {
                              final authProvider = Provider.of<AuthProvider>(
                                  context,
                                  listen: false);

                              authProvider.signOut();
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  LoginPage.ROUTE_NAME,
                                  (Route<dynamic> route) => false);
                              // RestartWidget.restartApp(context);
                            }
                          });
                        }),
                  ),
                  Positioned(
                    left: 35,
                    child: SizedBox(
                      width: 150,
                      child: Text(
                        AppConsts.things,
                        style: TextStyle(color: Colors.white, fontSize: 48),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Positioned(
                      bottom: 50,
                      left: 45,
                      child: Text(
                        (DateFormat.yMMMMd().format(DateTime.now())),
                        style: TextStyle(color: Colors.white),
                      )),
                  Positioned(
                      bottom: 50,
                      right: 25,
                      child: Row(
                        children: [
                          Center(
                            child: GradientStackCircularProgressBar(
                              size: 30,
                              progressStrokeWidth: 3,
                              backStrokeWidth: 3,
                              startAngle: 0,
                              mergeMode: true,
                              maxValue: 100,
                              backColor: Colors.indigo,
                              bars: [
                                GradientBarValue(
                                  barColores: [
                                    Colors.indigo.shade300,
                                    Colors.cyanAccent.shade200,
                                  ],
                                  barValues: context
                                          .watch<TodoProvider>()
                                          .todoList
                                          .isNotEmpty
                                      ? ((context
                                                  .watch<TodoProvider>()
                                                  .todosCompleted
                                                  .length /
                                              context
                                                  .watch<TodoProvider>()
                                                  .todoList
                                                  .length) *
                                          100)
                                      : 0,
                                  fullProgressColors: Colors.red,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            ' ${context.watch<TodoProvider>().todoList.isNotEmpty ? ((context.watch<TodoProvider>().todosCompleted.length / context.watch<TodoProvider>().todoList.length) * 100).toInt() : 0}% done',
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ))
                ]),
              )),
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Row(
                        children: [
                          Text(AppConsts.inbox),
                        ],
                      ),
                    ),
                    TaskList(),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Row(
                        children: [
                          Text(AppConsts.completed),
                        ],
                      ),
                    ),
                    CompletedTaskList()
                  ]),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var result = await Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddTask()));
          if (result != null && result) {
            context.read<TodoProvider>().readAllTodo();
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<bool> _showLogoutDialog() async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Logout"),
          content: Text("Are you sure you want to logout ?"),
          actions: <Widget>[
            ElevatedButton(
              child: Text("Yes"),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
            ElevatedButton(
              child: Text("No"),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
          ],
        );
      },
    );
  }
}
