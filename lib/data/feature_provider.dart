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
//import '../model/review.dart';

abstract class FeatureProvider {
  Stream<List<Features>> get allFeatures;
  Future<void> addRestaurant(Features restaurant);
  //Future<void> addReview(
  //    {required String restaurantId, required Review review});
  void addRestaurantsBatch(List<Features> restaurants);
  void loadAllFeatures();
  //void loadFilteredRestaurants(Filter filter);
  Future<Features> getRestaurantById(String restaurantId);
  void dispose();
}

class FirestoreFeaturesProvider implements FeatureProvider {
  FirestoreFeaturesProvider() {
    allFeatures = _allFeaturesController.stream;
  }

  final StreamController<List<Features>> _allFeaturesController =
  StreamController();

  @override
  late final Stream<List<Features>> allFeatures;

  @override
  Future<void> addRestaurant(Features restaurant) {
    final restaurants = FirebaseFirestore.instance.collection('restaurants');
    return restaurants.add({

      'photo': restaurant.photo,
    });
  }

  @override
  void addRestaurantsBatch(List<Features> features) =>
      features.forEach(addRestaurant);

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
  void loadAllFeatures() {
    final _querySnapshot = FirebaseFirestore.instance
        .collection('features')
        .snapshots();

    _querySnapshot.listen((event) {
      final _features = event.docs.map((DocumentSnapshot doc) {
        return Features.fromSnapshot(doc);
      }).toList();

      _allFeaturesController.add(_features);
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
    _allFeaturesController.close();
  }

  @override
  Future<Features> getRestaurantById(String featureId) {
    return FirebaseFirestore.instance
        .collection('features')
        .doc(featureId)
        .get()
        .then((DocumentSnapshot doc) => Features.fromSnapshot(doc));
  }


}
