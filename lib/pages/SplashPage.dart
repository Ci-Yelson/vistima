import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Container(
            child: Text(
              "欢迎使用VISTIMA~",
              style: TextStyle(fontSize: 24),
            ),
          ),
        ),
      ),
    );
  }
}
