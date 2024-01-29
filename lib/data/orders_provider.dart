/*
 *  Copyright 2022 Google LLC
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *       http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/order.dart';
//import '../model/review.dart';

abstract class OrderProvider {
  Stream<List<Order>> get allMenus;

  void loadOrderdMenus();

  void dispose();
}

class FirestoreOrderProvider implements OrderProvider {
  FirestoreOrderProvider() {
    allMenus = _allMenuController.stream;
  }

  final StreamController<List<Order>> _allMenuController =
  StreamController();

  @override
  late final Stream<List<Order>> allMenus;

  var userid = FirebaseAuth.instance.currentUser!.uid.toString();


  @override
  void loadOrderdMenus() {
    // final _querySnapshot = FirebaseFirestore.instance
    //     .collection('order')
    //     .where('user_id', isEqualTo:userid)
    //     .where('confirm', isNotEqualTo:4)
    //     .orderBy('confirm')
    //     .orderBy('created', descending: false)
    //     .snapshots();

    final _querySnapshot = FirebaseFirestore.instance
        .collection('order')
        .where('biker',  isEqualTo: userid)
        .where('confirm',  isEqualTo: 3)
        //.where('user_id', isEqualTo:userid)
        //.orderBy('confirm')
        //.orderBy('created', descending: true)
        .snapshots();

    _querySnapshot.listen((event) {
      final _features = event.docs.map((DocumentSnapshot doc) {
        return Order.fromSnapshot(doc);
      }).toList();
      _allMenuController.add(_features);
    });
  }


  @override

  void dispose() {
    _allMenuController.close();
  }



}
