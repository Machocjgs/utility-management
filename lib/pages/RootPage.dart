import 'package:flutter/material.dart';
import 'package:utilitymanagement/pages/HomePage.dart';

// Page to determine which page to start with
class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  @override
  Widget build(BuildContext context) {
    return HomePage();
  }
}



