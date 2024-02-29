import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{
  Future addPersonalTask(Map<String,dynamic> userPersonalMap,String id)async{
    return await FirebaseFirestore.instance.collection("Personal").doc(id).set(userPersonalMap);
  }
  Future addCollegeTask(Map<String,dynamic> userPersonalMap,String id)async{
    return await FirebaseFirestore.instance.collection("College").doc(id).set(userPersonalMap);
  }
  Future addOfficeTask(Map<String,dynamic> userPersonalMap,String id)async{
    return await FirebaseFirestore.instance.collection("Office").doc(id).set(userPersonalMap);
  }
  Future<Stream<QuerySnapshot>> getTask(String task)async{
    return await FirebaseFirestore.instance.collection(task).snapshots();
  }
  tickMethod(String id,String task) async{
    return await FirebaseFirestore.instance.collection(task).doc(id).update({"Yes":true});
  }
  removeMethod(String id,String task) async{
    return await FirebaseFirestore.instance.collection(task).doc(id).delete();
  }
  Future updateTask(String id, String updatedTask, String task) async {
    return await FirebaseFirestore.instance.collection(task).doc(id).update({
      "Work": updatedTask,
    });
  }

}