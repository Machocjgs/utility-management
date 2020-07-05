import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:utilitymanagement/model/record.dart';
import 'package:utilitymanagement/model/user.dart';
import 'package:utilitymanagement/utils/utils.dart';



abstract class RecordFireStoreService {

  Future<List<Record>> getUtilityRecords(String recordtype, String date);

  Future<Record> getUtilityDayRecord(String recordtype, String area, DateTime date);

  Future<void> addUtilityRecord(String recordtype, String date, Record recordData);
}

abstract class UserFireStoreService {

  Future<User> getUserDetailsByPhone(String phone);

}

class UserService implements UserFireStoreService{
  final firestoreInstance = Firestore.instance;

  Future<User> getUserDetailsByPhone(String phone) async {
    DocumentSnapshot doc = await firestoreInstance.collection("accounts").document(phone).get();
    if(doc.data != null) {
      return User(doc.data['email'], doc.data['password'], doc.data['name'], doc.data['role']);
    } else {
      return null;
    }
  }

}

class RecordService implements RecordFireStoreService {
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

