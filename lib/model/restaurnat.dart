// Copyright 2022 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

//import './values.dart';

typedef RestaurantPressedCallback = void Function(Restaurant restaurant);

typedef CloseRestaurantPressedCallback = void Function();

class Restaurant {
  final String? id;
  final String rest_name;
  final String? sefer;
  final double rate;
  final int status_active;
  final String? photo;
  final DocumentReference? reference;
  //final Array? categories;
  final  List<String> categories;
  final  Map location;

  Restaurant._({
    this.id = null,
    required this.rest_name,
    this.sefer,
    required this.status_active,
    this.photo,
    this.rate = 0,
     required this.categories,
    this.reference = null,
    required this.location,
  });

  factory Restaurant.fromSnapshot(DocumentSnapshot snapshot) {
    final _snapshot = snapshot.data() as Map<String, dynamic>;
    return Restaurant._(
      id: snapshot.id,
      rest_name: _snapshot['rest_name'],
      sefer: _snapshot['sefer'],
      rate: _snapshot['rate'].toDouble(),
      status_active: _snapshot['status_active'],
      photo: _snapshot['photo_url'],
      reference: snapshot.reference,
      // categories: _snapshot.['categories'],
        categories: List.from(snapshot['categories']),
       location: snapshot['location'],


    );
  }

  // factory Restaurant.random() {
  //   return Restaurant._(
  //     category: getRandomCategory(),
  //     city: getRandomCity(),
  //     name: getRandomName(),
  //     price: Random().nextInt(3) + 1,
  //     photo: getRandomPhoto(),
  //   );
  // }
}
