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

//import '../model/filter.dart';
//import '../model/restaurant.dart';
import '../model/feature.dart';
import '../model/offers.dart';
//import '../model/review.dart';

abstract class OfferProvider {
  Stream<List<Offers>> get allOffers;
  void loadAllOffers();
  void dispose();
}

class FirestoreOffersProvider implements OfferProvider {

  FirestoreOffersProvider() {
    allOffers = _allOffersController.stream;
  }

  final StreamController<List<Offers>> _allOffersController = StreamController();

  var userid = FirebaseAuth.instance.currentUser!.uid.toString();


  @override
  late final Stream<List<Offers>> allOffers;

  // @override
  // Future<void> addRestaurant(Offers restaurant) {
  //   final restaurants = FirebaseFirestore.instance.collection('restaurants');
  //   return restaurants.add({
  //
  //     'photo': restaurant.photo,
  //   });
  // }
  // @override
  // void addRestaurantsBatch(List<Offers> Offers) =>
  //     Offers.forEach(addRestaurant);

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
  void loadAllOffers() {
    final _querySnapshot = FirebaseFirestore.instance
        .collection('order')
        .where('biker', isEqualTo: userid)
        .where('confirm', whereIn:[1,2] )
        .snapshots();

    _querySnapshot.listen((event) {
      final _Offers = event.docs.map((DocumentSnapshot doc) {
        return Offers.fromSnapshot(doc);
      }).toList();

      _allOffersController.add(_Offers);
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
    _allOffersController.close();
  }



}
