import 'package:flutter/material.dart';
import 'package:notex/pages/auth_pages/authLogin.dart';
import 'package:notex/pages/auth_pages/authSignup.dart';
import 'package:notex/pages/homePage/body.dart';

class AppRoutes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => SignInPage());
      case signup:
        return MaterialPageRoute(builder: (_) => SignUpPage());
      case home:
        return MaterialPageRoute(builder: (_) => HomeBody());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
