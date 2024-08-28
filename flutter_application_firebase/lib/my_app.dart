import 'package:flutter/material.dart';
import 'pages/signin_page/login_screen.dart';

class MyApp extends StatelessWidget{
  const MyApp({super.key,
  });
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: SigninScreen()
      ),
    );
  }

}