import 'package:flutter/material.dart';
import 'package:notex/pages/auth_pages/authLogin.dart';
import 'package:notex/pages/auth_pages/authSignup.dart';
import 'package:notex/pages/homePage/body.dart';
import 'package:notex/pages/mainPages.dart';
import 'package:notex/pages/splash.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String signup = '/signup';
  //static const String home = '/home';
  static const String main = '/main';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => OnboardingScreen());
      case login:
        return MaterialPageRoute(
          builder: (_) => SignInPage(),
        );
      case signup:
        return MaterialPageRoute(builder: (_) => SignUpPage());

      // case home:
      //   return MaterialPageRoute(
      //     builder: (_) => HomeBody(),
      //     fullscreenDialog: true,
      //   );
      case main:
        return MaterialPageRoute(
          builder: (_) => Mainpages(),
        );
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
