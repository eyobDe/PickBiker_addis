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
import 'package:flutter/material.dart';
import 'package:pick_delivery_adama_biker/model/feature.dart';

import '../model/offers.dart';
import 'feature_card.dart';
import 'offers_card.dart';
//import 'restaurant_card.dart';

class OfferGrid extends StatelessWidget {
  const OfferGrid({

    required List<Offers> Offers,
  })  : _Offers = Offers;


  final List<Offers> _Offers;

  @override
  Widget build(BuildContext context) {
    // return GridView.count(
    //   crossAxisCount: 2,
    //   crossAxisSpacing: 5.0,
    //   children: _restaurants
    //       .map((restaurant) => RestaurantCard(
    //     restaurant: restaurant,
    //     onRestaurantPressed: _onRestaurantPressed,
    //   ))
    //       .toList(),
    // );




    return ListView.builder(
      padding:  const EdgeInsets.only(
          top: 4, bottom: 1, right: 10,left: 0),
      itemCount: _Offers.length,
      scrollDirection: Axis.vertical,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {

        return OfferdCard(
          OffersHere: _Offers[index],
        );
      },
    );
  }
}
