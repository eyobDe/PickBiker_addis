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
import 'package:pick_delivery_adama_biker/widget/star_rating.dart';

//import '../model/filter.dart';
//import '../model/restaurant.dart';
import '../model/restaurnat.dart';
//import '../model/review.dart';

abstract class RestaurantProvider {

  String? catIDD;


  Stream<List<Restaurant>> get allRestaurants;
  Stream<List<Restaurant>> get filteredRestaurants;

  //Future<void> addRestaurant(Restaurant restaurant);
  //Future<void> addReview(
  //{required String restaurantId, required Review review});
  //void addRestaurantsBatch(List<Restaurant> restaurants);

  loadAllRestaurants();
  loadFilteredRestaurants();

  //void loadFilteredRestaurants(Filter filter);
  Future<Restaurant> getRestaurantById(String restaurantId);
  void dispose();
}

class FirestoreRestaurantProvider implements RestaurantProvider {
  FirestoreRestaurantProvider(String cat) {
    catIDD = cat;
    allRestaurants = _allRestaurantsController.stream.asBroadcastStream();
    filteredRestaurants=_filteredRestaurantsController.stream.asBroadcastStream();
  }

  final StreamController<List<Restaurant>> _allRestaurantsController =StreamController();
  final StreamController<List<Restaurant>> _filteredRestaurantsController =StreamController();


  @override
  late final Stream<List<Restaurant>> allRestaurants;
  @override
  late final Stream<List<Restaurant>> filteredRestaurants;

  @override
  // Future<void> addRestaurant(Restaurant restaurant) {
  //   final restaurants = FirebaseFirestore.instance.collection('restaurants');
  //   return restaurants.add({
  //     'avgRating': restaurant.avgRating,
  //     'category': restaurant.category,
  //     'city': restaurant.city,
  //     'name': restaurant.name,
  //     'numRatings': restaurant.numRatings,
  //     'photo': restaurant.photo,
  //     'price': restaurant.price,
  //   });
  // }

  @override
  // void addRestaurantsBatch(List<Restaurant> restaurants) =>
  //     restaurants.forEach(addRestaurant);

  @override
  // Future<void> addReview({
  //   required String restaurantId,
  //   required Review review,
  // }) async {
  //   final restaurant = await FirebaseFirestore.instance
  //       .collection('restaurants')
  //       .doc(restaurantId);
  //   final newReview = await restaurant.collection('ratings').doc();
  //
  //   return FirebaseFirestore.instance
  //       .runTransaction((Transaction transaction) async {
  //     final DocumentSnapshot _restaurantSnapshot =
  //     await transaction.get(restaurant);
  //     final _restaurant = Restaurant.fromSnapshot(_restaurantSnapshot);
  //     final newRatings = _restaurant.numRatings + 1;
  //     final newAverage =
  //         ((_restaurant.numRatings * _restaurant.avgRating) + review.rating) /
  //             newRatings;
  //
  //     transaction.update(restaurant, {
  //       'numRatings': newRatings,
  //       'avgRating': newAverage,
  //     });
  //
  //     transaction.set(newReview, {
  //       'rating': review.rating,
  //       'text': review.text,
  //       'userName': review.userName,
  //       'timestamp': review.timestamp,
  //       'userId': review.userId,
  //     });
  //   });
  // }

  @override
  loadAllRestaurants() {
    // final _querySnapshot = FirebaseFirestore.instance
    //     .collection('restaurant')
    //     .where('status_active',  isEqualTo: 1)
    //     .orderBy('rate', descending: true)
    //     .snapshots();

    final _querySnapshot = FirebaseFirestore.instance
        .collection('restaurant')
        .orderBy('rate',descending: true)
        .snapshots();
    _querySnapshot.listen((event) {
      final _restaurants = event.docs.map((DocumentSnapshot doc) {
        return Restaurant.fromSnapshot(doc);
      }).toList();

      if (!_allRestaurantsController.isClosed){
        _allRestaurantsController.add(_restaurants);
      }

    });
  }
  @override
    loadFilteredRestaurants() {
    // final _querySnapshot = FirebaseFirestore.instance
    //     .collection('restaurant')
    //     .where('status_active',  isEqualTo: 1)
    //     .orderBy('rate', descending: true)
    //     .snapshots();

    final _querySnapshot = FirebaseFirestore.instance
        .collection('restaurant')
        .where('categories', arrayContains:catIDD)
      //.orderBy('rate',descending: true)
        .snapshots();

    _querySnapshot.listen((event) {
      final _restaurants = event.docs.map((DocumentSnapshot doc) {
        return Restaurant.fromSnapshot(doc);
      }).toList();


      if (!_filteredRestaurantsController.isClosed){
        _filteredRestaurantsController.add(_restaurants);
      }
    });
  }
  
  @override
  // void loadFilteredRestaurants(Filter filter) {
  //   Query collection = FirebaseFirestore.instance.collection('restaurants');
  //   if (filter.category != null) {
  //     collection = collection.where('category', isEqualTo: filter.category);
  //   }
  //   if (filter.city != null) {
  //     collection = collection.where('city', isEqualTo: filter.city);
  //   }
  //   if (filter.price != null) {
  //     collection = collection.where('price', isEqualTo: filter.price);
  //   }
  //   final _querySnapshot = collection
  //       .orderBy(filter.sort ?? 'avgRating', descending: true)
  //       .limit(50)
  //       .snapshots();
  //
  //   _querySnapshot.listen((event) {
  //     final _restaurants = event.docs.map((DocumentSnapshot doc) {
  //       return Restaurant.fromSnapshot(doc);
  //     }).toList();
  //
  //     _allRestaurantsController.add(_restaurants);
  //   });
  // }

  void dispose() {
    _allRestaurantsController.close();
    _filteredRestaurantsController.close();

  }



  @override
  Future<Restaurant> getRestaurantById(String restaurantId) {
    return FirebaseFirestore.instance
        .collection('restaurant')
        .doc(restaurantId)
        .get()
        .then((DocumentSnapshot doc) => Restaurant.fromSnapshot(doc));
  }

  @override
  String? catIDD;

// Future<List<Review>> getReviewsForRestaurant(String restaurantId) {
  //   return FirebaseFirestore.instance
  //       .collection('restaurants')
  //       .doc(restaurantId)
  //       .collection('ratings')
  //       .get()
  //       .then((QuerySnapshot snapshot) {
  //     return snapshot.docs.map((DocumentSnapshot doc) {
  //       return Review.fromSnapshot(doc);
  //     }).toList();
  //   });
  // }
}
