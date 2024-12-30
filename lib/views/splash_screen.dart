import 'package:flutter/material.dart';
import 'homepage.dart';
import 'intro_screen.dart';

import '../services/shared_preferences_helper.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2), () {
      bool isFirstTime = SharedPreferencesHelper.getFirstTime();
      Navigator.of(context)
          .pushReplacementNamed(isFirstTime ? 'intro_screen' : 'home_page');
    });

    return Scaffold(
        body: Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Image.network(
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQhWEgecbJc9XUhTkU6_S_AVWf-2br67IeNNw&s"),
    ));
  }
}
