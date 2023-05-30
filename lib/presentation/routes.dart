import 'package:flutter/material.dart';
import 'package:todo_list/presentation/ui/screens/auth/login_page.dart';
import 'package:todo_list/presentation/ui/screens/auth/register_page.dart';
import 'package:todo_list/presentation/ui/screens/home_page.dart';

allRoutes(RouteSettings settings) {
  switch (settings.name) {
    case LoginPage.ROUTE_NAME:
      return _getDefaultRoute(const LoginPage());
    case RegisterPage.ROUTE_NAME:
      return _getDefaultRoute(const RegisterPage());
    case HomePage.ROUTE_NAME:
      return _getDefaultRoute(const HomePage());
    default:
      return _getDefaultRoute(const LoginPage());
  }
}

Route _getDefaultRoute(Widget widget, {bool withAnimation = true}) {
  if (!withAnimation) {
    return PageRouteBuilder(
      pageBuilder: (context, animation1, animation2) => widget,
      transitionDuration: Duration.zero,
    );
  }

  return MaterialPageRoute(builder: (BuildContext context) {
    return widget;
  });
}

class SlideLeftRoute extends PageRouteBuilder {
  final Widget page;
  SlideLeftRoute({required this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
}
