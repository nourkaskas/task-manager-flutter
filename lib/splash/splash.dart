import 'dart:async';
import 'package:flutter/material.dart';
import 'package:task_manager_app/screens/login_screen.dart';



class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Splash Screen',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5),
            ()=>Navigator.pushReplacement(context,
            MaterialPageRoute(builder:
                (context) =>
                    LoginScreen()
            )
        )
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.blueAccent,
              Colors.white,
              Colors.cyan,
            ],
          ),
        ),

        child:Column(
          mainAxisAlignment:MainAxisAlignment.spaceAround,
          children: [
            // Image.asset('image/image4.png'),
            Center(
              child:AnimatedSize(
                duration:const Duration(seconds: 2) ,
                child: Image.asset('images/R.png'),
              ),),
          ],
        )
    );
  }
}
