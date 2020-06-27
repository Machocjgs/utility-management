import 'package:flutter/material.dart';
import 'package:utilitymanagement/pages/utilitymanagement/UtilityManagement.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Widget _showUtilityMonitoring_temp(){
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

  Widget _showUtilityMonitoring(){
    return Card(
      margin: EdgeInsets.all(10),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Text("Utility Monitoring"),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration( shape: BoxShape.circle, color: Colors.teal[500]),
                  child: FlatButton(
                    child: Icon(Icons.flash_on, color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UtilityManagement())
                      );
                    },
                  ),
                ),
                Container(
                  decoration: BoxDecoration( shape: BoxShape.circle, color: Colors.teal[500]),
                  child: FlatButton(
                    child: Icon(Icons.local_drink, color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UtilityManagement())
                      );
                    },
                  ),
                )
                
              ],
            ),
          ],
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.teal[300],),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
            _showUtilityMonitoring_temp(),
            // _showUtilityMonitoring()
          ],),
        )
    )
    );
  }
}
