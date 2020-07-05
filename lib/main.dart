import 'package:flutter/material.dart';
import 'package:utilitymanagement/pages/RootPage.dart';
import 'package:utilitymanagement/services/authentication.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        accentColor: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: RootPage(auth: Auth()),
    );
  }
}
