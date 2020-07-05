import 'package:flutter/material.dart';
import 'package:utilitymanagement/pages/utilitymanagement/UtilityManagement.dart';
import 'package:utilitymanagement/services/authentication.dart';

class HomePage extends StatefulWidget {
  HomePage({this.auth, this.logoutCallBack});

  final BaseAuth auth;
  final VoidCallback logoutCallBack;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Widget _showUtilityMonitoring() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        child: Container(
          decoration: BoxDecoration(color: Colors.teal[500], borderRadius: BorderRadius.circular(10)),
          child: FlatButton(
            child: Text("Utility Monitoring", style: TextStyle(color: Colors.white),),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UtilityManagement())
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[300],
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: widget.logoutCallBack,
            )
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
            _showUtilityMonitoring(),
          ],),
        )
      )
    );
  }
}
