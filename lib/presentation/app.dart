// import 'package:daybed_tenant/utils/theme_states.dart';
// import 'package:device_preview/device_preview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/core/theme/size_config.dart';
import 'package:todo_list/domain/models/user_model.dart';
import 'package:todo_list/presentation/routes.dart';
import 'package:todo_list/presentation/ui/screens/auth/login_page.dart';
import 'package:todo_list/presentation/ui/screens/home_page.dart';
import 'package:todo_list/presentation/ui/widgets/auth_widget_builder.dart';
import 'package:todo_list/domain/viewmodel/auth_provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        SizeConfig().init(constraints, orientation);
        /*
          * MultiProvider for top services that do not depends on any runtime values
          * such as user uid/email.
          */
        return AuthWidgetBuilder(
          builder:
              (BuildContext context, AsyncSnapshot<UserModel> userSnapshot) {
            return MaterialApp(
              title: 'Todo List',
              debugShowCheckedModeBanner: false,
              // navigatorKey: navigatorKey,
              localizationsDelegates: const <LocalizationsDelegate>[
                DefaultMaterialLocalizations.delegate,
                DefaultWidgetsLocalizations.delegate,
                DefaultCupertinoLocalizations.delegate
              ],
              home: Consumer<AuthProvider>(
                builder: (_, authProviderRef, __) {
                  if (userSnapshot.connectionState == ConnectionState.active) {
                    return userSnapshot.data?.uid != 'null'
                        ? const HomePage()
                        : const LoginPage();
                  }

                  return const Material(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
              onGenerateRoute: (RouteSettings settings) => allRoutes(settings),
            );
          },
          key: const Key('AuthWidget'),
        );
      });
    });
  }

  static Route _getDefaultRoute(Widget widget) {
    return MaterialPageRoute(builder: (BuildContext context) {
      return widget;
    });
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);
  static const ROUTE_NAME = 'home';

  @override
  Widget build(BuildContext context) {
    Provider.of<User?>(context, listen: true);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: context.watch<User?>() != null
            ? const HomePage()
            : const LoginPage());
    // if (authBloc.authState == AuthState.UnAuthenticated) {
    //   return const DashboardScreen(
    //     bottomNavIndex: 3,
    //   );
    // }
    //
    // return LoadingIndicator();
  }
}
