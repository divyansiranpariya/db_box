import 'package:db_box/views/homepage.dart';
import 'package:db_box/views/intro_screen.dart';
import 'package:flutter/material.dart';
import 'views/splash_screen.dart';
import 'services/shared_preferences_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesHelper.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: SharedPreferencesHelper.themeNotifier,
      builder: (context, bool isDarkTheme, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: isDarkTheme ? ThemeData.dark() : ThemeData.light(),
          routes: {
            '/': (context) => SplashScreen(),
            'intro_screen': (context) => IntroScreen(),
            'home_page': (context) => HomePage(),
          },
        );
      },
    );
  }
}
