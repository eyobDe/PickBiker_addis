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

//import '../model/filter.dart';
//import '../model/restaurant.dart';
import '../model/feature.dart';
import '../model/menu.dart';
//import '../model/review.dart';

abstract class MenuProvider {

  String? restIDD;
  String? catIDD;
  Stream<List<Menu>> get allMenus;
  Stream<List<Menu>> get filteredMenus;

  Future<void> addRestaurant(Features restaurant);
  //Future<void> addReview(
  //    {required String restaurantId, required Review review});
 // void addRestaurantsBatch(List<Menu> restaurants);
  loadAllMenus();

  loadRestMenus();
 // void loadRestMenus(String restID);
  loadFilteredMenus();
 // Future<Menu> getRestaurantById(String restaurantId);
  void dispose();
}

class FirestoreMenuProvider implements MenuProvider {
  FirestoreMenuProvider(String rest, String cat) {
    restIDD = rest;
    catIDD = cat;
    allMenus = _allMenuController.stream.asBroadcastStream();
    filteredMenus = _filteredMenuController.stream.asBroadcastStream();
  }

  final StreamController<List<Menu>> _allMenuController = StreamController();
  final StreamController<List<Menu>> _filteredMenuController = StreamController();

  @override
  late final Stream<List<Menu>> allMenus;
  @override
  late final Stream<List<Menu>> filteredMenus;


  @override
  Future<void> addRestaurant(Features restaurant) {
    final restaurants = FirebaseFirestore.instance.collection('restaurants');
    return restaurants.add({
      'photo': restaurant.photo,
    });
  }

  @override
  // void addRestaurantsBatch(List<Menu> features) =>
  //     features.forEach(addRestaurant);


  @override
  loadAllMenus() {
    final _querySnapshot = FirebaseFirestore.instance
        .collection('cuisine')
        .snapshots();
    _querySnapshot.listen((event) {
      final _features = event.docs.map((DocumentSnapshot doc) {
        return Menu.fromSnapshot(doc);
      }).toList();

      _allMenuController.add(_features);
    });
  }



  @override
   loadRestMenus() {

    final _querySnapshot = FirebaseFirestore.instance
        .collection('cuisine')
        .where('rest_id_selected', isEqualTo:restIDD)
        .snapshots();

    _querySnapshot.listen((event) {
      final _features = event.docs.map((DocumentSnapshot doc) {
        return Menu.fromSnapshot(doc);
      }).toList();
      _allMenuController.add(_features);
    });
  }

   @override
  loadFilteredMenus() {

    // final _querySnapshot = FirebaseFirestore.instance
    //     .collection('cuisine')
    //     .where('rest_id_selected', isEqualTo:restID)
    //     .where('status_active', isEqualTo:1)
    //     .snapshots();

    final _querySnapshot = FirebaseFirestore.instance
        .collection('cuisine')
        .where('rest_id_selected', isEqualTo:restIDD)
        .where('categories', arrayContains:catIDD)
        .snapshots();

    _querySnapshot.listen((event) {
      final _features = event.docs.map((DocumentSnapshot doc) {
        return Menu.fromSnapshot(doc);
      }).toList();
      _filteredMenuController.add(_features);
    });
  }



  @override

  void dispose() {
    _allMenuController.close();
    _filteredMenuController.close();
  }

  @override
  String? catIDD;

  @override
  String? restIDD;

  // @override
  // Future<Menu> getRestaurantById(String featureId) {
  //   return FirebaseFirestore.instance
  //       .collection('cuisines')
  //       .doc(featureId)
  //       .get()
  //       .then((DocumentSnapshot doc) => Menu.fromSnapshot(doc));
  // }


}
