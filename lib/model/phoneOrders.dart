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

class PhoneOrders {


  final String? id;
  final Timestamp created;
  final int? price;
  final int? delivery_charge;
  final int? service_charge;
  final int? total_price;
  final String? desti;
  final String? order_food;
  final String? phone;
  final String? rest_name;
  final String? status;
  // final String menuID;
  // final int? PFee;

  PhoneOrders._(
       {

    this.id = null,
         required this.created,
         this.price,
         this.delivery_charge,
         this.service_charge,
         this.total_price,
         this.desti,
         this.order_food,
         this.phone,
         this.rest_name,
        this.status
    // this.PFee,
    // required this.menuID,


  });

  factory PhoneOrders.fromSnapshot(DocumentSnapshot snapshot) {
    final _snapshot = snapshot.data() as Map<String, dynamic>;
    return PhoneOrders._(
      id: snapshot.id,
      created: _snapshot['created'],
      price: _snapshot['price'],
      delivery_charge: _snapshot['delivery_charge'],
      service_charge: _snapshot['service_charge'],
      total_price: _snapshot['total_price'],
      desti: _snapshot['desti'],
      order_food: _snapshot['order_food'],
      phone: _snapshot['phone'],
      rest_name: _snapshot['rest_name'],
      status: _snapshot['status'],

    );
  }

}
