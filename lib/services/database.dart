

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:game_app/models/user.dart';

class DatabaseService{
  final CollectionReference onlineResults = Firestore.instance.collection('The Bored');

  Future update() async{
    return await onlineResults.document("new").setData({
      'name': "Anna",
      'score': 55
    });
  }

  Stream<QuerySnapshot> get res{
    return onlineResults.snapshots();
  }
}