import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:utilitymanagement/model/record.dart';
import 'package:utilitymanagement/pages/utilitymanagement/AddRecord.dart';
import 'package:utilitymanagement/services/firestore.dart';

class UtilityManagement extends StatefulWidget {
  @override
  _UtilityManagementState createState() => _UtilityManagementState();
}

class _UtilityManagementState extends State<UtilityManagement> {
  int _selectedIndex = 0;
  String _selectedItem = "Electricity";
  String _dateString;
  Icon _selectedIcon = Icon(Icons.flash_on);
  Future <List<Record>> futureRecords;
  CalendarController _calendarController;

  @override
  void initState() {
    DateTime now = DateTime.now();
    _dateString = "${now.year}-${now.month}-${now.day}";
    futureRecords =  RecordService().getUtilityRecords(_selectedItem, _dateString);
    _calendarController = CalendarController();
    super.initState();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }
  
  void _loadRecords(String dateString) async {
    setState(() {
      _dateString = dateString;
      futureRecords =  RecordService().getUtilityRecords(_selectedItem, dateString);
    });
  }

  Future<Null> _refresh() async {
    _loadRecords(_dateString);
  }

  void _onItemTapped(int index){
    DateTime now = DateTime.now();
    String _dateString = "${now.year}-${now.month}-${now.day}";
    
    setState(() {
      _selectedIndex = index;
      switch(index) {
        case 1:
          _selectedItem = "Water";
          _selectedIcon = Icon(Icons.local_drink);
          break;
        default:
          _selectedItem = "Electricity";
          _selectedIcon = Icon(Icons.flash_on);
          break;
      }
    });

    _loadRecords(_dateString);
  }

  Widget _showRecordList(var recordList) {
    return ListView.builder(
      itemCount: recordList.length,
      itemBuilder: (context, index) {
        return Card(
          color: Colors.teal[300],
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text("${recordList[index].area}", style: TextStyle(fontSize: 24),),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
                child: Text("Previous Reading: ${recordList[index].previousreading}", style: TextStyle(fontSize: 12),),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
                child: Text("Present Reading: ${recordList[index].presentreading}", style: TextStyle(fontSize: 12),),
              ),
            ],
          )
          // child: Text("${recordList[index].area} : ${recordList[index].presentconsumption}"),
        );
      },
    );
  }

  Widget _showCalendar() {
    return TableCalendar(
      calendarController: _calendarController,
      onDaySelected: (DateTime day, List events) => _loadRecords("${day.year}-${day.month}-${day.day}"),
      availableCalendarFormats: const {CalendarFormat.month: 'view as month', CalendarFormat.week: 'view as week'},
      calendarStyle: CalendarStyle(
        selectedColor: Theme.of(context).accentColor,
        todayColor:Theme.of(context).primaryColor
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.teal[500], title: Text(_dateString),),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _showCalendar(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: FutureBuilder<List<Record>>(
                future: futureRecords,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return _showRecordList(snapshot.data);
                  } else if (snapshot.hasError){
                    print("${snapshot.error}");
                    return Text("${snapshot.error}");
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Row(children: <Widget>[Text("Create "), _selectedIcon, Text(" Record")],),
        backgroundColor: Colors.amber[800],
        onPressed: () {
          Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => AddRecord(recordType: _selectedItem,))
          ).then((_) => _refresh());
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.flash_on),
            title: Text('Electricity')
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_drink),
            title: Text('Water')
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

class Empty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      )
    );
  }
}
