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

typedef CloseRestaurantPressedCallback = void Function();

class Menu {
  final String? id;
  final String? menu_desc;
  final String? name;
  final String? photo;
  final int? price;
  final String? rest_id;
  final String? status;
  final int? PFee;

  Menu._({
    this.id = null,
     this.menu_desc,
     this.name,
     this.photo,
    this.price,
    this.rest_id,
    this.status,
    this.PFee,

  });

  factory Menu.fromSnapshot(DocumentSnapshot snapshot) {
    final _snapshot = snapshot.data() as Map<String, dynamic>;
    return Menu._(
      id: snapshot.id,
      menu_desc: _snapshot['cuisine_menu'],
      name: _snapshot['cuisine_name'],
      photo: _snapshot['photo_url'],
      price: _snapshot['price'],
      rest_id: _snapshot['rest_id_selected'],
      status: _snapshot['status_active'].toString(),
      PFee: _snapshot['PFee'],
    );
  }

}
