import 'package:get/get.dart';
import 'package:rxtask/bindings/home_screen_bindings.dart';
import 'package:rxtask/screens/home_screen.dart';
import 'package:rxtask/screens/login_screen.dart';

class AppRoutes {
  static const String home = '/home';
  static const String login = '/login';
}

class AppPages {
  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.home,
      page: () => HomeScreen(),
      bindings: [HomeScreenBinding()],
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => LoginScreen(),
    ),
  ];
}
