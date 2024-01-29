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

import 'dart:core';
import 'dart:core';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pick_delivery_adama_biker/widget/star_rating.dart';

//import '../model/restaurant.dart';
import '../model/restaurnat.dart';
//import '../widgets/star_rating.dart';

class RestaurantCard extends StatelessWidget {
  final userloc;

   RestaurantCard({
    required this.restaurant,
    this.userloc,
    required RestaurantPressedCallback onRestaurantPressed,
  }) : _onPressed = onRestaurantPressed;

  final Restaurant restaurant;
  final RestaurantPressedCallback _onPressed;






  @override
  Widget build(BuildContext context) {


    //
    // Map<String, dynamic> locationdata =
    // restaurant.location as Map<String, dynamic>;
    //
    // double Restlat = locationdata['geopoint'].latitude;
    // double Restlong = locationdata['geopoint'].longitude;


   // var distance = userloc.distance(lat: Restlat, lng: Restlong);



    return Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight:Radius.circular(25)),
        ),
        child: InkWell(
          onTap: () => _onPressed(restaurant),
          splashColor: Colors.blue.withAlpha(30),
          child: Container(
            decoration: BoxDecoration(
              //color: HexColor('#F8FAFB'),
              borderRadius: BorderRadius.circular(25),
            ),

            height: 110,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Hero(
                    tag: 'restaurant-image-${restaurant.id}',
                    child: Container(
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),

                        image: DecorationImage(
                          image: CachedNetworkImageProvider(
                            restaurant.photo!,
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              restaurant.rest_name,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ),

                        ],
                      ),

                      Container(
                        alignment: Alignment.bottomLeft,
                        // child: Text(
                        //   '● ${restaurant.sefer} ● ${restaurant.sefer}',
                        //   style: Theme.of(context).textTheme.caption,
                        // ),

                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            StaticStarRating(
                              rating: restaurant.rate,
                              color: Colors.amber,
                              size: 12,
                            ),
                            Text('  ${restaurant.rate} ',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'WorkSans',
                                  fontSize: 12,
                                  letterSpacing: 0.27,
                                  color: Colors.grey,
                                ),
                            ),

                          ],
                        ),

                      ),




                      Container(
                        alignment: Alignment.bottomLeft,

                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.location_pin,
                              color: Colors.amber,
                              size: 13,
                            ),

                            Text(
                              restaurant.sefer.toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontFamily: 'WorkSans',
                                fontSize: 13,
                                letterSpacing: 0.27,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),

                      ),

                      FutureBuilder<Widget>(
                          future: buildDistance(),
                          initialData: const SizedBox.shrink(),// async work
                          builder: ( context, snapshot) {


                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.amber,
                                ),
                              );
                            }

                            else if(snapshot.hasError){

                              return Padding(
                                padding: EdgeInsets.all(40),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      child: Column(
                                        children: [
                                          const Icon(Icons.location_off),
                                          Text(
                                            '${snapshot.error}',
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            else if(snapshot.hasData){
                              return Container(
                                alignment: Alignment.bottomLeft,

                                child:snapshot.data,

                              );

                            }


                            return SizedBox.fromSize();
                          }

                      ),

                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Future<Widget> buildDistance() async => FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('delivery_price').doc('YPwApLUvywada1QDRqbp').get(), // async work
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        //   switch (snapshotLocation.connectionState) {
        //     case ConnectionState.waiting:
        //       return Center(
        //         child: Padding(
        //           padding: EdgeInsets.all(40),
        //           child: Column(
        //             mainAxisAlignment: MainAxisAlignment.center,
        //             children: [
        //               Container(
        //                 alignment: Alignment.center,
        //                 child: const CircularProgressIndicator(color: Colors.amber,),
        //               ),
        //             ],
        //           ),
        //         ),
        //       );
        //     case ConnectionState.done:
        //       return FutureBuilder<DocumentSnapshot>(
        //         future: restaurnatHere, // async work
        //         builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshotRest) {
        //
        //
        //           switch (snapshotRest.connectionState) {
        //             case ConnectionState.waiting:
        //               return Center(
        //                 child: Padding(
        //                   padding: EdgeInsets.all(40),
        //                   child: Column(
        //                     mainAxisAlignment: MainAxisAlignment.center,
        //                     children: [
        //                       Container(
        //                         alignment: Alignment.center,
        //                         child: CircularProgressIndicator(color: Colors.amber,),
        //                       ),
        //                     ],
        //                   ),
        //                 ),
        //               );
        //
        //             default:
        //               if (snapshotRest.hasError) {
        //                 return Padding(
        //                   padding: EdgeInsets.all(40),
        //                   child: Column(
        //                     mainAxisAlignment: MainAxisAlignment.center,
        //                     children: [
        //                       Container(
        //                         alignment: Alignment.center,
        //                         child: Column(
        //                           children: [
        //                             const Icon(Icons.location_off),
        //                             Text(
        //                               '${snapshotRest.error}',
        //                               textAlign: TextAlign.center,
        //                             ),
        //                           ],
        //                         ),
        //                       ),
        //                     ],
        //                   ),
        //                 );
        //               } else {
        //                 geo = Geoflutterfire();
        //                 var hereUserLat = snapshotLocation.data!.latitude;
        //                 var hereUserLong = snapshotLocation.data!.longitude;
        //
        //                 var myLocationPoint =
        //                 geo.point(latitude: hereUserLat, longitude: hereUserLong);
        //                 Map<String, dynamic> dataRest =
        //                 snapshotRest.data?.data() as Map<String, dynamic>;
        //
        //
        //
        //                   restaurant_name=dataRest["rest_name"];
        //
        //
        //
        //                 Map<String, dynamic> locationdata =
        //                 dataRest['location'] as Map<String, dynamic>;
        //
        //                 double Restlat = locationdata['geopoint'].latitude;
        //                 double Restlong = locationdata['geopoint'].longitude;
        //
        //                 var distance =
        //                 myLocationPoint.distance(lat: Restlat, lng: Restlong);
        //
        //                 double distanceFormated = double.parse((distance).toStringAsFixed(1)); // total distance
        //
        //                 var deliveryFee = 0.0;
        //                 var deliveryFeeBeforeDis = 0.0;
        //                 var totalPrice = 0.0;
        //
        //                 // if (widget.foodItemDoc.data()!.containsKey('PFee') )
        //
        //                 if (widget.menu.PFee == 0) {
        //                   PFee = dataRest['package_fee'];
        //                 }
        //                 else {
        //                   PFee = widget.menu.PFee!;
        //                 }
        //
        //                 if (distance < 2) {
        //                   deliveryFeeBeforeDis = price1.toDouble();
        //                   deliveryFee = price1.toDouble() -
        //                       (price1.toDouble() * (deliveryDiscount / 100));
        //                   totalPrice = (widget.menu.price)! * amount +
        //                       deliveryFee + (PFee) * amount;
        //
        //                   totalPriceHere = totalPrice;
        //                 }
        //                 else if (distance > 2 && distance < 4) {
        //                   deliveryFeeBeforeDis = price2.toDouble();
        //                   deliveryFee = price2.toDouble() -
        //                       (price2.toDouble() * (deliveryDiscount / 100));
        //                   totalPrice =  (widget.menu.price)! * amount +
        //                       deliveryFee +  (PFee) * amount;
        //
        //                   totalPriceHere = totalPrice;
        //                 }
        //                 else if (distance > 4 && distance < 6) {
        //                   deliveryFeeBeforeDis = price3.toDouble();
        //                   deliveryFee = price3.toDouble() -
        //                       (price3.toDouble() * (deliveryDiscount / 100));
        //                   totalPrice =  (widget.menu.price)! * amount +
        //                       deliveryFee + (PFee) * amount;
        //
        //                   totalPriceHere = totalPrice;
        //                 }
        //                 else if (distance > 6 && distance < 9) {
        //                   deliveryFeeBeforeDis = price4.toDouble();
        //                   deliveryFee = price4.toDouble() -
        //                       (price4.toDouble() * (deliveryDiscount / 100));
        //                   totalPrice =  (widget.menu.price)! * amount +
        //                       deliveryFee + (PFee) * amount;
        //
        //                   totalPriceHere = totalPrice;
        //                 } // Test For Longer Distances
        //                 if (distance > 9) {
        //                   return (const Padding(
        //                     padding: EdgeInsets.all(8.0),
        //                     child: Center(
        //                       child: Text(
        //                         "We currently provide deliveries from restaurants in the range of 9kms maximum."
        //                             "Please choose another restaurant nearby, Thank you",
        //                         textAlign: TextAlign.center,
        //                         style: TextStyle(
        //                           fontWeight: FontWeight.w400,
        //                           fontSize: 12,
        //                           letterSpacing: 0.27,
        //                           color: Colors.grey,
        //                         ),
        //                       ),
        //                     ),
        //                   ));
        //                 }
        //
        //                 if (distance < 20) {
        //                   return ((Padding(
        //                     padding: const EdgeInsets.all(8.0),
        //                     child: Column(
        //                       mainAxisSize: MainAxisSize.min,
        //                       children: [
        //                         Table(
        //
        //                           // textDirection: TextDirection.rtl,
        //                           // defaultVerticalAlignment: TableCellVerticalAlignment.bottom,
        //                           // border:TableBorder.all(width: 2.0,color: Colors.red),
        //
        //                           children: [
        //                             TableRow(children: [
        //                               Text("Subtotal",
        //                                   textScaleFactor: 1,
        //                                   textAlign: TextAlign.right),
        //                               Text(
        //                                   (widget.menu.price! * amount).toString(),
        //                                   textScaleFactor: 1,
        //                                   textAlign: TextAlign.right),
        //                             ]),
        //                             TableRow(children: [
        //                               Text("Packaging fee",
        //                                   textScaleFactor: 1,
        //                                   textAlign: TextAlign.right),
        //                               Text(
        //                                   (PFee * amount).toString(),
        //                                   textScaleFactor: 1,
        //                                   textAlign: TextAlign.right),
        //                             ]),
        //                             TableRow(children: [
        //                               Text("Delivery fee",
        //                                   textScaleFactor: 1,
        //                                   textAlign: TextAlign.right),
        //                               Text(deliveryFeeBeforeDis.toString(),
        //                                   textScaleFactor: 1,
        //                                   textAlign: TextAlign.right),
        //                             ]),
        //                             TableRow(children: [
        //                               Text("Delivery discount",
        //                                   textScaleFactor: 1,
        //                                   textAlign: TextAlign.right),
        //                               Text(deliveryDiscount.toString() + "%",
        //                                   textScaleFactor: 1,
        //                                   textAlign: TextAlign.right),
        //                             ]),
        //                             TableRow(children: [
        //                               Text("Amount",
        //                                   textScaleFactor: 1,
        //                                   textAlign: TextAlign.right),
        //                               Text(NumberToWord().convert('en-in', amount),
        //                                   textScaleFactor: 1,
        //                                   textAlign: TextAlign.right),
        //                             ]),
        //                             TableRow(children: [
        //                               Text("Total pay",
        //                                   textScaleFactor: 1.5,
        //                                   textAlign: TextAlign.right),
        //                               Text("ETB " + totalPriceHere.toString(),
        //                                   textScaleFactor: 1.5,
        //                                   textAlign: TextAlign.right),
        //                             ]),
        //                           ],
        //                         ),
        //                         const SizedBox(
        //                           height: 10,
        //                         ),
        //                         const Center(
        //                           child: Text(
        //                             "We currently accept only cash up on delivery, Thanks for your understanding",
        //                             textAlign: TextAlign.right,
        //                             style: TextStyle(
        //                               fontWeight: FontWeight.w400,
        //                               fontSize: 12,
        //                               letterSpacing: 0.27,
        //                               color: Colors.grey,
        //                             ),
        //                           ),
        //                         ),
        //                         const SizedBox(
        //                           height: 6,
        //                         ),
        //                         Center(
        //                           child: SizedBox(
        //                             width: double.infinity, // <-- match-parent
        //                             child: ElevatedButton(
        //                               style: ButtonStyle(
        //                                 backgroundColor:
        //                                 MaterialStateProperty.all(Colors.amber),
        //                                 shape: MaterialStateProperty.all<
        //                                     RoundedRectangleBorder>(
        //                                     RoundedRectangleBorder(
        //                                       borderRadius: BorderRadius.circular(24.0),
        //                                     )),
        //                               ),
        //                               child: const Text(
        //                                 'Confirm order',
        //                                 style: TextStyle(
        //                                   fontWeight: FontWeight.w800,
        //                                   fontSize: 13,
        //                                   letterSpacing: 0.27,
        //                                   color: Colors.white,
        //                                 ),
        //                               ),
        //                               onPressed: () {
        //
        //
        //                                 order(
        //                                     deliveryDiscount,
        //                                     deliveryFeeBeforeDis,
        //                                     totalPriceHere,
        //                                     amount,
        //                                     hereUserLat,
        //                                     hereUserLong,
        //                                     Restlat,
        //                                     Restlong);
        //
        //
        //
        //                                 // Navigator.of(context).pop();
        //
        //                                 Navigator.push<dynamic>(
        //                                   context,
        //                                   MaterialPageRoute<dynamic>(
        //                                     builder: (BuildContext context) =>
        //                                         ProfilePage(),
        //                                   ),
        //                                 );
        //                               },
        //                             ),
        //                           ),
        //                         )
        //                       ],
        //                     ),
        //                   )));
        //                 }
        //
        //                 return (SizedBox.fromSize());
        //               }
        //           }
        //         },
        //       );
        //
        // }


        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.amber,
            ),
          );
        }

        else if(snapshot.hasError){

          return Padding(
            padding: EdgeInsets.all(40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      const Icon(Icons.location_off),
                      Text(
                        '${snapshot.error}',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        else if(snapshot.hasData){
          Map<String, dynamic> data =
          snapshot.data?.data() as Map<String, dynamic>;


          Map<String, dynamic> locationdata = restaurant.location as Map<String, dynamic>;
          double Restlat = locationdata['geopoint'].latitude;
          double Restlong = locationdata['geopoint'].longitude;

          var distance = userloc.distance(lat: Restlat, lng: Restlong);

          double price1=0;

          if (distance < 0.5) {


            price1 = data['p1'].toDouble();



        }

          else if (distance > 0.5 && distance < 1) {
            price1 = data['p2'].toDouble();


          }

          else if (distance > 1 && distance < 1.5) {
            price1 = data['p3'].toDouble();


          }

          else if (distance > 1.5 && distance < 2) {
            price1 = data['p4'].toDouble();


          }

          else if (distance > 2 && distance < 3) {
            price1 = data['p5'].toDouble();


          }

          else if (distance > 3 && distance < 4) {
            price1 = data['p6'].toDouble();


          }

          else if (distance > 4 && distance < 5) {
            price1 = data['p7'].toDouble();


          }

          else if (distance > 5 && distance < 5.5) {
            price1 = data['p8'].toDouble();



          }

          else if (distance > 5.5 && distance < 6) {
            price1 = data['p9'].toDouble();




          }

          else if (distance > 6) {
            price1 = 00;

          }



          return Container(
            alignment: Alignment.bottomLeft,

            child:Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Icon(
                  Icons.directions_bike,
                  color: Colors.amber,
                  size: 13,
                ),
                SizedBox(
                  width: 3,
                ),


                Text(
                    price1.toInt().toString()+" Birr",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontFamily: 'WorkSans',
                    fontSize: 13,
                    letterSpacing: 0.27,
                    color: Colors.grey,
                  ),),


              ],
            ),

          );

        }


        return SizedBox.fromSize();
      }

  );

}
