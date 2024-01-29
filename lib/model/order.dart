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

class Order {
  final String? id;
  final int amount;
  final int confirm;
  final Timestamp created;
  final String? cuisine_id;
  final int order_num;
  final String rest_id;
  final double total_price;
  final String user_id;
  final String? deliveryDuration;

  Order._({
    required this.confirm,
    required this.created,
    this.cuisine_id,
    required this.order_num,
    required this.rest_id,
    required this.total_price,
    required this.user_id,
    this.id,
    required this.amount,
    this.deliveryDuration,

  });

  factory Order.fromSnapshot(DocumentSnapshot snapshot) {
    final _snapshot = snapshot.data() as Map<String, dynamic>;
    return Order._(
      id: snapshot.id,
      confirm: _snapshot['confirm'],
      created: _snapshot['created'],
      cuisine_id: _snapshot['cuisine_id'],
      order_num: _snapshot['order_num'],
      rest_id: _snapshot['rest_id'],
      total_price: _snapshot['total_price'],
      user_id: _snapshot['user_id'],
      amount: _snapshot['amount'],
      deliveryDuration: _snapshot['deliveryDuration'],
    );
  }

}


