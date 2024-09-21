import 'package:flutter/material.dart';
import 'package:realtime_msg/view/screen/home_screen.dart';

void main(){
  runApp( MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: HomeScreen(),
    );
  }
}
