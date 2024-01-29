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

import 'package:cloud_firestore/cloud_firestore.dart';

//import './values.dart';


typedef CloseRestaurantPressedCallback = void Function();

class Offers {


  final String? id;
  final double price;
  final String rest_id;
  final String client_loc;
  final String cuisine_id;
  final String? phone;
  final String? deliveryDuration;

  final String client_id;
  final Timestamp created;
  // final String menuID;
  // final int? PFee;

  Offers._({

    this.id = null,
    required this.price,
    required this.rest_id,
    required this.client_loc,
    required this.cuisine_id,
    this.phone,
    this.deliveryDuration,
     required this.client_id,
    required this.created,
    // this.PFee,
    // required this.menuID,


  });

  factory Offers.fromSnapshot(DocumentSnapshot snapshot) {
    final _snapshot = snapshot.data() as Map<String, dynamic>;
    return Offers._(
      id: snapshot.id,
      price: _snapshot['total_price'],
      rest_id: _snapshot['rest_id'],
      client_loc: _snapshot['client_loc'],
      cuisine_id: _snapshot['cuisine_id'],
      phone: _snapshot['phone_number'],
      client_id: _snapshot['user_id'],
      created: _snapshot['created'],
      deliveryDuration: _snapshot['deliveryDuration'],
      // price: _snapshot['price'],
      // old_price: _snapshot['old_price'],
      // rest_id: _snapshot['rest_id_selected'],
      // PFee: _snapshot['Pfee'],
    );
  }

}
