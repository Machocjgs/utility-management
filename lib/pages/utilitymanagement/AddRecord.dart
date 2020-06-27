import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:utilitymanagement/model/record.dart';
import 'package:utilitymanagement/services/firestore.dart';
import 'package:utilitymanagement/utils/utils.dart';

class AddRecord extends StatefulWidget {
  AddRecord({this.recordType});
  final String recordType;

  @override
  _AddRecordState createState() => _AddRecordState();
}

class _AddRecordState extends State<AddRecord> {
  final _formKey = GlobalKey<FormState>();

  String _dateString;
  String _selectedArea;
  Record _previousData;
  Record _presentData;
  DateTime _selectedDate;
  
  /*
  Map of our text controllers:
    [0] : previous reading
    [1] : present consumption
    [2] : previous consumption
    [3] : variance
    [4] : percentage
  */
  List<TextEditingController> textControllers = List<TextEditingController>(5);
  List<FocusNode> focusNodes = List<FocusNode>(10);

  @override
  void initState(){
    // Initialize focus Nodes
    for (var i = 0; i < focusNodes.length; i++) {
      focusNodes[i] = FocusNode();
    }
    // Initialize text editing controllers
    for (var i = 0; i < textControllers.length; i++) {
      textControllers[i] = TextEditingController();
    }
    // Initialize record data
    _presentData = Utility.createRecord();
    _previousData = Utility.createRecord();
    // Initialize date time
    _selectedDate = DateTime.now();
    _dateString = "${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}";

    super.initState();
  }

  @override
  void dispose() {
    // Cleanup text controllers
    for (var i = 0; i < textControllers.length; i++) {
      textControllers[i].dispose();
    }
    super.dispose();
  }

  void _getAreaData() async {
    // Get previous data
    Record previousData  
      = await RecordService()
        .getUtilityDayRecord(widget.recordType, _selectedArea, _selectedDate);
    // Set previous data
    textControllers[0].text = previousData.presentreading;
    textControllers[2].text = previousData.presentconsumption;

    setState(() {
      _previousData = previousData;
      _dateString = "${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}";
    });
  }

  void _calculateRecord() {
  // Present Consumption = Present Reading - Previous Reading
    _presentData.presentconsumption 
      = Utility.subtract(_presentData.presentreading, _previousData.presentreading);
  // Variance = Present Consumption - Previous Consumption
    _presentData.variance
      = Utility.subtract(_presentData.presentconsumption, _previousData.presentconsumption);
  // Percentage = (Present Reading - Previous Reading) / Previous Reading
    String percentageVar = Utility.subtract(_presentData.presentreading, _presentData.previousreading).toString();
    _presentData.percentage
      = (double.parse(percentageVar) / double.parse(_presentData.previousreading)).toString();
    textControllers[1].text = _presentData.presentconsumption;
    textControllers[3].text 
      = (double.parse(_presentData.variance) < 0) 
        ? (double.parse(_presentData.variance) * -1).toString()
        : _presentData.variance;
    textControllers[4].text = _presentData.percentage.toString().toLowerCase() == 'infinity' ? '' : _presentData.percentage;
  }

  Future _submitData() async {
    return RecordService().addUtilityRecord(widget.recordType, _dateString, _presentData);
  }

  Widget _showTargetForm(){
    return Text(
      "New ${widget.recordType} Record",
      style: TextStyle(fontSize: 34),
      textAlign: TextAlign.center,
    );
  }

  Widget _showTenantArea(BuildContext context){

    Future<Null> _selectDate(BuildContext context) async {
      final DateTime picked = await showDatePicker(
          context:context,
          initialDate: _selectedDate,
          firstDate: DateTime(2018, 1),
          lastDate: DateTime(2101)
      );
      if (picked != null && picked != _selectedDate) {
        _selectedDate = picked;
        _getAreaData();
      }
    }

    return Card(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: TextFormField(
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: 'Tenant/Common Area'),
              onSaved: (String area) => _presentData.area = area,
              focusNode: focusNodes[0],
              onFieldSubmitted: (String area) {
                _selectedArea = area;
                focusNodes[0].unfocus();
                FocusScope.of(context).requestFocus(focusNodes[1]);
                _getAreaData();
              },
            ),
          ),
          Expanded(
            child: FlatButton(
              onPressed: () => _selectDate(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(_dateString),
                  Icon(Icons.date_range, color: Colors.teal[300],),
                ],
              )
            )
          ),
        ],
      ),
    );
  }

  Widget _showMeterMultArea(){
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextFormField(
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: 'Meter Number'),
              onSaved: (String meter) => _presentData.meter = meter,
              focusNode: focusNodes[1],
              onFieldSubmitted: (_) {
                focusNodes[1].unfocus();
                FocusScope.of(context).requestFocus(focusNodes[2]);
              },
            ),
          ),
          Expanded(
            child: TextFormField(
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: 'Multiplier'),
              onSaved: (String mult) =>_presentData.mult = mult,
              focusNode: focusNodes[2],
              onFieldSubmitted: (_) {
                focusNodes[2].unfocus();
                FocusScope.of(context).requestFocus(focusNodes[3]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _showReadingArea(){
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: TextFormField(
              keyboardType: TextInputType.number,
              inputFormatters: [BlacklistingTextInputFormatter(RegExp('[, -]'))],
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: 'Present Reading'),
              onSaved: (String presentreading) => _presentData.presentreading = presentreading,
              focusNode: focusNodes[3],
              onFieldSubmitted: (String presentreading) {
                _presentData.presentreading = presentreading;
                _calculateRecord();
                focusNodes[3].unfocus();
                FocusScope.of(context).requestFocus(focusNodes[4]);
              },
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: textControllers[0],
              keyboardType: TextInputType.number,
              inputFormatters: [BlacklistingTextInputFormatter(RegExp('[, -]'))],
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: 'Previous Reading'),
              onSaved: (String previousreading) => _presentData.previousreading = previousreading,
              focusNode: focusNodes[4],
              onFieldSubmitted: (String previousreading) {
                _previousData.presentreading = previousreading;
                _presentData.previousreading = previousreading;
                _calculateRecord();
                focusNodes[4].unfocus();
                FocusScope.of(context).requestFocus(focusNodes[5]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _showConsumptionArea(){
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextFormField(
              controller: textControllers[1],
              keyboardType: TextInputType.number,
              inputFormatters: [BlacklistingTextInputFormatter(RegExp('[, -]'))],
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: 'Present Consumption'),
              onSaved: (String presentconsumption) => _presentData.presentconsumption = presentconsumption,
              focusNode: focusNodes[5],
              onFieldSubmitted: (String presentconsumption) {
                _presentData.presentconsumption = presentconsumption;
                _calculateRecord();
                focusNodes[5].unfocus();
                FocusScope.of(context).requestFocus(focusNodes[6]);
              },
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: textControllers[2],
              keyboardType: TextInputType.number,
              inputFormatters: [BlacklistingTextInputFormatter(RegExp('[, -]'))],
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: 'Previous Consumption'),
              onSaved: (String previousconsumption) => _presentData.previousconsumption = previousconsumption,
              focusNode: focusNodes[6],
              onFieldSubmitted: (String previousconsumption) {
                _presentData.previousconsumption = previousconsumption;
                _previousData.presentconsumption = previousconsumption;
                _calculateRecord();
                focusNodes[6].unfocus();
                FocusScope.of(context).requestFocus(focusNodes[7]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _showVarPercentageArea(){
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextFormField(
              controller: textControllers[3],
              keyboardType: TextInputType.number,
              inputFormatters: [BlacklistingTextInputFormatter(RegExp('[, -]'))],
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: 'Variance'),
              onSaved: (String variance) => _presentData.variance = variance,
              focusNode: focusNodes[7],
              onFieldSubmitted: (_) {
                focusNodes[7].unfocus();
                FocusScope.of(context).requestFocus(focusNodes[8]);
              },
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: textControllers[4],
              keyboardType: TextInputType.number,
              inputFormatters: [BlacklistingTextInputFormatter(RegExp('[, -]'))],
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: 'Percentage'),
              onSaved: (String percentage) => _presentData.percentage = percentage,
              focusNode: focusNodes[8],
              onFieldSubmitted: (_) {
                focusNodes[8].unfocus();
                FocusScope.of(context).requestFocus(focusNodes[9]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _showRemarksArea(){
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: TextFormField(
        keyboardType: TextInputType.text,
        decoration: InputDecoration(labelText: 'Remarks',),
        onSaved: (String remarks) => _presentData.remarks = remarks,
        focusNode: focusNodes[9],
      ),
    );
  }

  Widget _showSubmitButtonArea(){
    return RaisedButton(
      color: Colors.teal[200],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Text(
        "Submit",
      ),
      onPressed: () {
        if(_formKey.currentState.validate()){
          _formKey.currentState.save();
          // TODO: Change User to get from our Auth
          _presentData.user = "Macho";
          _presentData.date = _dateString;
          _showDialog();
        }
      },
    );
  }

  void _showDialog() async {
    
    Widget _showBabies(String text, Icon icon, bool state){
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              icon,
              Text(text)
            ],
          ),
          RaisedButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Text("OK"),
                onPressed: () {
                  if(state) {
                    Navigator.of(context).pop();
                  } else {
                    int count = 0;
                    Navigator.of(context).popUntil((_) => count++ == 2);
                  }
                },
              ),
        ],
      );
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
            height: 200,
            width: 200,
            child: Center (
              child :FutureBuilder(
                future: _submitData(),
                builder: (context, snapshot) {
                  if(snapshot.hasError) {
                    return _showBabies(
                      "Something went wrong",
                      Icon(Icons.sentiment_very_dissatisfied, color: Colors.red[500], size: 80),
                      true);
                  } else if(snapshot.connectionState == ConnectionState.done) {
                    return _showBabies(
                      "Success", Icon(Icons.check_circle_outline, color: Colors.teal[500], size: 80,),
                      false
                      );
                  } else {
                    return SizedBox(
                      height: 80,
                      width: 80,
                      child: CircularProgressIndicator(strokeWidth: 7,),
                    );
                  }
                },
              ),
            ),
          ),
        );
      }
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.teal[500],),
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            _showTargetForm(),
            _showTenantArea(context),
            _showMeterMultArea(),
            _showReadingArea(),
            _showConsumptionArea(),
            _showVarPercentageArea(),
            _showRemarksArea(),
            _showSubmitButtonArea()
          ],
        )
      )
    );
  }
}