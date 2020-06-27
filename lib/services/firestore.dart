import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:utilitymanagement/model/record.dart';
import 'package:utilitymanagement/utils/utils.dart';



abstract class FireStoreService {

  Future<List<Record>> getUtilityRecords(String recordtype, String date);

  Future<Record> getUtilityDayRecord(String recordtype, String area, DateTime date);

  Future<void> addUtilityRecord(String recordtype, String date, Record recordData);

  

}

class RecordService implements FireStoreService {
  // TODO: Implement Auth
  final firestoreInstance = Firestore.instance;
  final utilitycollection = "utility-monitoring";

  Future<List<Record>> getUtilityRecords(String recordtype, String date) async {
    List<DocumentSnapshot> docs = (await firestoreInstance.collection(utilitycollection)
      .document(recordtype.toLowerCase())
      .collection(date)
      .getDocuments()).documents;
      
    List<Record> _recordList = docs.map((e) => Record.create(e.data)).toList();

    return _recordList;
  }

  Future<Record> getUtilityDayRecord(String recordtype, String area, DateTime date) async {
    String previousdate = "${date.year}-${date.month}-${date.day-1}";
    DocumentSnapshot doc = 
      await firestoreInstance.collection(utilitycollection)
      .document(recordtype.toLowerCase())
      .collection(previousdate)
      .document(area)
      .get();
    Record recordData;
    try {
      recordData = Record.create(doc.data);
    } catch (error) {
      recordData = Utility.createRecord();
    }
    return recordData;
  }
  
  Future<void> addUtilityRecord(String recordtype, String date, Record recordData) async {
    final mapData = Utility.recordToMap(recordData);
    Future<void> snapshot = 
      firestoreInstance
      .collection(utilitycollection)
      .document(recordtype.toLowerCase())
      .collection(date)
      .document(recordData.area)
      .setData(mapData);

    return snapshot;
  }
}

