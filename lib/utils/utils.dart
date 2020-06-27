import 'package:utilitymanagement/model/record.dart';

class Utility {

  static Map<String, dynamic> recordToMap(Record recordData) {
    Map<String, dynamic> mapData = {
    'area'                : recordData.area,
    'meter'               : recordData.meter,
    'mult'                : recordData.mult,
    'presentreading'      : recordData.presentreading,
    'previousreading'     : recordData.previousreading,
    'presentconsumption'  : recordData.presentconsumption,
    'previousconsumption' : recordData.previousconsumption,
    'variance'            : recordData.variance,
    'percentage'          : recordData.percentage,
    'remarks'             : recordData.remarks,
    'date'                : recordData.date,
    'user'                : recordData.user,
    };
    return mapData;
  }

  static Record createRecord() {
    Map<String, dynamic> mapData = {
    'area'                : '',
    'meter'               : '',
    'mult'                : '',
    'presentreading'      : '0.0',
    'previousreading'     : '0.0',
    'presentconsumption'  : '0.0',
    'previousconsumption' : '',
    'variance'            : '0.0',
    'percentage'          : '0.0',
    'remarks'             : '',
    'date'                : '',
    'user'                : '',
    };
    return Record.create(mapData);
  }

  static Record mapToRecord(Map<String, dynamic> mapData) {
    return Record.create(mapData);
  }

  static String subtract(String a, String b) {
    String result = '0.0';

    try {
      result = (double.parse(a) - double.parse(b)).toString();
    } catch (error) {
      print(error.toString());
    }

    return result;
  }

}