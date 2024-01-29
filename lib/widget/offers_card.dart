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


import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
//import '../model/restaurant.dart';
import '../app_theme.dart';
import '../check_out_for_offers.dart';
import '../main.dart';
import '../model/feature.dart';
import '../model/offers.dart';
//import '../widgets/star_rating.dart';

class OfferdCard extends StatefulWidget {
  OfferdCard({
    required this.OffersHere,

  }) ;

  final Offers OffersHere;

  @override
  State<OfferdCard> createState() => _OfferdCardState();
}

class _OfferdCardState extends State<OfferdCard> {
  CollectionReference users = FirebaseFirestore.instance.collection('biker');

  CollectionReference client = FirebaseFirestore.instance.collection('Users');

  CollectionReference order = FirebaseFirestore.instance.collection('order');

  CollectionReference rests = FirebaseFirestore.instance.collection('restaurant');

  CollectionReference food = FirebaseFirestore.instance.collection('cuisine');

  var userid = FirebaseAuth.instance.currentUser!.uid.toString();

  String currentDeliveryDuration = '';

  late StreamController<String> _timeController;
  late Stream<String> _timeStream;
  late Timer _timer;
  late Timer _countdownTimer; // New Timer for countdown

  late StreamController<String> _countdownController; // New StreamController
  late Stream<String> _countdownStream; // New Stream


// Store a reference to the Timer

  @override
  void initState() {
    super.initState();

    // Initialize the time controller and stream
    _timeController = StreamController<String>();
    _timeStream = _timeController.stream;

    // Initialize the countdown controller and stream
    _countdownController = StreamController<String>();
    _countdownStream = _countdownController.stream;


    // Start a timer to update the elapsed time
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!mounted) {
        // Check if the widget is still mounted before updating the stream
        return;
      }
      final now = DateTime.now();
      final difference = now.difference(widget.OffersHere.created.toDate());
      final formattedTimeCounted =
          '${difference.inHours} : ${difference.inMinutes.remainder(60)} : ${difference.inSeconds.remainder(60)}';

      _timeController.add(formattedTimeCounted);
    });

    const countdownDuration = const Duration(minutes: 45);
    int remainingSeconds = countdownDuration.inSeconds;

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        // Check if the widget is still mounted before updating the stream
        return;
      }

      if (remainingSeconds >= 0) {
        final formattedCountdown =
            '${remainingSeconds ~/ 3600} : ${(remainingSeconds ~/ 60) % 60} : ${remainingSeconds % 60}';
        _countdownController.add(formattedCountdown);
        remainingSeconds--;
      } else {
        // You can handle what to do after the countdown finishes here
        // For example, set a flag to indicate that the countdown is complete
        // and stop the countdown timer.
        // You can also display a different message.
        // Stop the countdown timer for now.
        _countdownTimer.cancel();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timeController.close();

    // Cancel the Timer when disposing of the widget
    _timer.cancel();
  }
  @override
  Widget build(BuildContext context) {

      return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: InkWell(
        splashColor: Colors.transparent,
        // onTap: callback,
        onTap: () {
          // Navigator.push<dynamic>(
          //   context,
          //   MaterialPageRoute<dynamic>(
          //       builder: (BuildContext context) => CheckOutOffer(
          //         menu: OffersHere, restID: OffersHere.rest_id, menuID: OffersHere.menuID,
          //       )
          //   ),
          // );
        },


        child: Container(
          decoration: BoxDecoration(
            color: HexColor('#F8FAFB'),
            borderRadius: BorderRadius.circular(15),
          ),
          height: 280,
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 8,right: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    timeBuilder(),
                    statusBuilder(),

                  ],
                ),
              ),

              Center(

                child:Column(
                  children: [
                  StreamBuilder<String>(
                  stream: _timeStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      currentDeliveryDuration = snapshot.data!;

                      // Split the time string and get the relevant parts (hours, minutes, seconds)
                      List<String> timeParts = snapshot.data!.split(':');
                      int hours = int.parse(timeParts[0]);
                      int minutes = int.parse(timeParts[1]);
                      int seconds = int.parse(timeParts[2]);

                      // Convert the time to total minutes
                      int totalMinutes = hours * 60 + minutes;

                      // Update the current duration
                      Color backgroundColor = Colors.green; // Default color

                      // Determine background color based on duration
                      if (totalMinutes >= 45) {
                        backgroundColor = Colors.red;
                      } else if (totalMinutes >= 45) {
                        backgroundColor = Colors.green;
                      }

                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          snapshot.data!,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                            letterSpacing: 0.27,
                            color: Colors.white,
                          ),
                        ),
                      );
                    } else {
                      return const Text("Calculating...");
                    }
                  },
                ),

                    const SizedBox(
                      height: 5,
                    ),

                  // Chip(
                    //   avatar: const CircleAvatar(
                    //     backgroundColor: Colors.white,
                    //     child: Icon(
                    //       Icons.access_time,
                    //       color: Colors.amber,
                    //       size: 20.0,
                    //     ),
                    //   ),
                    //   label: StreamBuilder<String>(
                    //     stream: _countdownStream, // Use the new countdown stream
                    //     builder: (context, snapshot) {
                    //       if (snapshot.hasData) {
                    //         return Text(snapshot.data!,
                    //           style: const TextStyle(
                    //             fontWeight: FontWeight.w800,
                    //             fontSize: 15,
                    //             letterSpacing: 0.27,
                    //           ),
                    //         );
                    //       } else {
                    //         return const Text("Calculating...");
                    //       }
                    //     },
                    //   ),
                    // ),

                    foodName(),
                    restName(),
                  ],
                ),
              ),

              priceBuilder(),

              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FutureBuilder<DocumentSnapshot>(
                      future: order.doc(widget.OffersHere.id).get(),
                      builder:
                          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return const Text("Something went wrong");
                        }

                        if (snapshot.hasData && !snapshot.data!.exists) {
                          return const Text("Document does not exist");
                        }

                        if (snapshot.connectionState == ConnectionState.done) {
                          Map<String, dynamic> data =
                          snapshot.data!.data() as Map<String, dynamic>;

                          if (data['confirm'] == 1) {
                            return ElevatedButton.icon(
                              style: ButtonStyle(
                                  backgroundColor:
                                  MaterialStateProperty.all(Colors.black),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(35.0),
                                      ))),

                              // Within the `FirstRoute` widget
                              onPressed: () {
                                outOfTheKitchenOrder(this.context);
                              },
                              icon: const Icon(Icons.directions_bike),
                              label: const Text("On the way "),
                            );

                            }
                          if (data['confirm'] == 2) {
                            return ElevatedButton.icon(
                              style: ButtonStyle(
                                  backgroundColor:
                                  MaterialStateProperty.all(Colors.black),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(35.0),
                                      ))),
                              // Within the `FirstRoute` widget
                              onPressed: () {
                                orderOnTheWay(this.context);

                                //showAlertDialogDeliverOrder(context);
                              },
                              icon: const Icon(Icons.directions_bike),
                              label: const Text("Delivered"),
                            );
                          }

                          // return ElevatedButton.icon(
                          //   style: ButtonStyle(
                          //       backgroundColor:
                          //       MaterialStateProperty.all(Colors.black),
                          //       shape: MaterialStateProperty.all<
                          //           RoundedRectangleBorder>(
                          //           RoundedRectangleBorder(
                          //             borderRadius: BorderRadius.circular(35.0),
                          //           ))),
                          //   // Within the `FirstRoute` widget
                          //   onPressed: () {
                          //     //showAlertDialogOutOfTheKitchenOrder(context);
                          //     outOfTheKitchenOrder(context);
                          //   },
                          //   icon: const Icon(Icons.directions_bike),
                          //   label: const Text("On the way "),
                          // );
                        }

                        return SizedBox.fromSize();
                      },
                    ),
                  ],
                ),
              ),
              Center(
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      clientLoc(),
                      SizedBox(
                        width: 6,
                      ),
                      clientPhone(),
                    ],
                  )
              ),


            ],
          ),
        ),



      ),


    );
  }

  Widget restName() => FutureBuilder<DocumentSnapshot>(
    future: rests.doc(widget.OffersHere.rest_id).get(),
    builder: (BuildContext context,
        AsyncSnapshot<DocumentSnapshot> snapshot) {
      if (snapshot.hasError) {
        return const Text("Something went wrong");
      }
      if (snapshot.hasData && !snapshot.data!.exists) {
        return const Text("Document does not exist");
      }

      if (snapshot.connectionState == ConnectionState.done) {
        Map<String, dynamic> data =
        snapshot.data!.data() as Map<String, dynamic>;
        // return Text("Data: ${data['displayName']}");

        return SelectableText(
          "${data['rest_name']}",
          textAlign: TextAlign.right,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15,
            letterSpacing: 0.27,
            //color: Colors.white,
          ),
        );
      }

      return const Text("loading");
    },
  );

  Widget foodName() => FutureBuilder<DocumentSnapshot>(
    future: food.doc(widget.OffersHere.cuisine_id).get(),
    builder: (BuildContext context,
        AsyncSnapshot<DocumentSnapshot> snapshot) {
      if (snapshot.hasError) {
        return const Text("Something went wrong");
      }
      if (snapshot.hasData && !snapshot.data!.exists) {
        return const Text("Document does not exist");
      }

      if (snapshot.connectionState == ConnectionState.done) {
        Map<String, dynamic> data =
        snapshot.data!.data() as Map<String, dynamic>;
        // return Text("Data: ${data['displayName']}");

        return SelectableText(
          "${data['cuisine_name']}",
          textAlign: TextAlign.right,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15,
            letterSpacing: 0.27,
            //color: Colors.white,
          ),
        );
      }

      return const Text("loading");
    },
  );

  Widget actionBuilder() => FutureBuilder<DocumentSnapshot>(
    future: order.doc(widget.OffersHere.id).get(),
    builder:
        (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
      if (snapshot.hasError) {
        return const Text("Something went wrong");
      }

      if (snapshot.hasData && !snapshot.data!.exists) {
        return const Text("Document does not exist");
      }

      if (snapshot.connectionState == ConnectionState.done) {
        Map<String, dynamic> data =
        snapshot.data!.data() as Map<String, dynamic>;

        if (data['confirm'] == 1) {
          return Row(
            children: [
              ElevatedButton.icon(
                  style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all(Colors.black),
                      shape: MaterialStateProperty.all<
                          RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(35.0),
                          ))),
                // Within the `FirstRoute` widget
                onPressed: () {
                  //showAlertDialogOutOfTheKitchenOrder(context);
                },
                icon: const Icon(Icons.directions_bike),
                label: const Text("On the way "),
              ),
              const SizedBox(
                width: 5,
              ),

            ],
          );
        }
        if (data['confirm'] == 2) {
          return Row(
            children: [
              ElevatedButton.icon(
                  style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all(Colors.black),
                      shape: MaterialStateProperty.all<
                          RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(35.0),
                          ))),
                // Within the `FirstRoute` widget
                onPressed: () {
                  orderOnTheWay(context);

                  //showAlertDialogDeliverOrder(context);
                },
                icon: const Icon(Icons.directions_bike),
                label: const Text("Delivered"),
              ),
              const SizedBox(
                width: 5,
              ),


            ],
          );
        }

        // return ElevatedButton.icon(
        //   style: ButtonStyle(
        //       backgroundColor:
        //       MaterialStateProperty.all(Colors.black),
        //       shape: MaterialStateProperty.all<
        //           RoundedRectangleBorder>(
        //           RoundedRectangleBorder(
        //             borderRadius: BorderRadius.circular(35.0),
        //           ))),
        //   // Within the `FirstRoute` widget
        //   onPressed: () {
        //     //showAlertDialogOutOfTheKitchenOrder(context);
        //     outOfTheKitchenOrder(context);
        //   },
        //   icon: const Icon(Icons.directions_bike),
        //   label: const Text("On the way "),
        // );
      }

      return SizedBox.fromSize();
    },
  );

  Widget clientLoc() => ElevatedButton.icon(
      style: ButtonStyle(
          backgroundColor:
          MaterialStateProperty.all(Colors.amber),
          shape: MaterialStateProperty.all<
              RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(35.0),
              ))),

      // Within the `FirstRoute` widget
      onPressed: () =>
      // Clipboard.setData(ClipboardData(text: OffersHere.client_loc))
      //     .then((value) { //only if ->
      //   //ScaffoldMessenger.of(context).showSnackBar(snackBar); // -> show a notification
      // },
      launch(widget.OffersHere.client_loc.toString()),

      icon: const Icon(Icons.location_pin),
      label: const Text("Go to client"));

  Widget clientPhone() => FutureBuilder<DocumentSnapshot>(
    future: client.doc(widget.OffersHere.client_id).get(),
    builder:
        (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
      if (snapshot.hasError) {
        return Text("Something went wrong");
      }

      if (snapshot.hasData && !snapshot.data!.exists) {
        return Text("Document does not exist");
      }

      if (snapshot.connectionState == ConnectionState.done) {
        Map<String, dynamic> data =
        snapshot.data!.data() as Map<String, dynamic>;

        return ElevatedButton.icon(
            style: ButtonStyle(
                backgroundColor:
                MaterialStateProperty.all(Colors.green),
                shape: MaterialStateProperty.all<
                    RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(35.0),
                    ))),

            // Within the `FirstRoute` widget
            onPressed: () =>
            // Clipboard.setData(ClipboardData(text: OffersHere.client_loc))
            //     .then((value) { //only if ->
            //   //ScaffoldMessenger.of(context).showSnackBar(snackBar); // -> show a notification
            // },
            launch("tel://"+data['phoneNumber'].toString().replaceRange(0, 4, 0.toString())),

            icon: const Icon(Icons.phone),
            label: const Text("Call client"));
      }

      return Text("loading");
    },
  );

  Widget timeBuilder() => FutureBuilder<DocumentSnapshot>(
    future: order.doc(widget.OffersHere.id).get(),
    builder:
        (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
      if (snapshot.hasError) {
        return const Text("Something went wrong");
      }

      if (snapshot.hasData && !snapshot.data!.exists) {
        return const Text("Document does not exist");
      }

      if (snapshot.connectionState == ConnectionState.done) {
        Map<String, dynamic> data =
        snapshot.data!.data() as Map<String, dynamic>;
        var formatedTime= DateTime.parse(data['created'].toDate().toString());
        //String formattedTime = DateFormat.jm().format(formatedTime);
        String formattedTime = DateFormat('E, MMM d, hh:mm a').format(data['created'].toDate());

        return Chip(
          avatar: const CircleAvatar(
              backgroundColor: Colors.white,
              //backgroundColor: DesignCourseAppTheme.delivery,
              child: Icon(
                Icons.access_time,
                color: Colors.amber,
                size: 20.0,
              )),
          label:  Text(formattedTime),
        );

      }

      return const Text("loading");
    },
  );

  Widget statusBuilder() => FutureBuilder<DocumentSnapshot>(
    future: order.doc(widget.OffersHere.id).get(),
    builder:
        (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
      if (snapshot.hasError) {
        return const Text("Something went wrong");
      }

      if (snapshot.hasData && !snapshot.data!.exists) {
        return const Text("Document does not exist");
      }

      if (snapshot.connectionState == ConnectionState.done) {
        Map<String, dynamic> data =
        snapshot.data!.data() as Map<String, dynamic>;

        if ((data['confirm']).toString() == '0') {
          return const Chip(
            avatar: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.play_for_work_rounded,
                  color: Colors.amber,
                  size: 20.0,
                )),
            label: Text('In process'),
          );
        } else if ((data['confirm']).toString() == '1') {
          return const Chip(
            avatar: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.food_bank_outlined,
                  color: Colors.amber,
                  size: 20.0,
                )),
            label: Text('Preparing'),
          );
        } else if ((data['confirm']).toString() == '2') {
          return const Chip(
            avatar: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.directions_bike,
                  color: Colors.amber,
                  size: 20.0,
                )),
            label: Text('On the way'),
          );
        }

      }

      // return const Chip(
      //   avatar: CircleAvatar(
      //       backgroundColor: Colors.white,
      //       child: Icon(
      //         Icons.directions_bike,
      //         color: Colors.amber,
      //         size: 12.0,
      //       )),
      //   label: Text('On the way'),
      // );
      return SizedBox.fromSize();
    },
  );

  Widget priceBuilder() => FutureBuilder<DocumentSnapshot>(
        future: order.doc(widget.OffersHere.id).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return const Text("Document does not exist");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
            snapshot.data!.data() as Map<String, dynamic>;

            var foodPrice =data['total_price'] - (data['delivery_fee'] + (data['service_charge'] ?? 0) + data['delivery_discount']);

               return Padding(
              padding: const EdgeInsets.only(right: 18.0,top: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Table(
                    defaultColumnWidth: const FixedColumnWidth(100.0),

                    children:  [
                      TableRow(children: [

                        const Text("Food price",
                            textScaleFactor: 1,
                            textAlign: TextAlign.right),
                        Text(foodPrice.toString(),
                            textScaleFactor: 1,
                            textAlign: TextAlign.right),
                      ]),



                      TableRow(children: [

                        const Text("Delivery fee",
                            textScaleFactor: 1,
                            textAlign: TextAlign.right),
                        Text(data['delivery_fee'].toString(),
                            textScaleFactor: 1,
                            textAlign: TextAlign.right),
                      ]),

                      TableRow(children: [

                        const Text("Service charge",
                            textScaleFactor: 1,
                            textAlign: TextAlign.right),
                        Text(data['service_charge'].toString(),
                            textScaleFactor: 1,
                            textAlign: TextAlign.right),
                      ]),

                      TableRow(children: [
                        const Text("Total pay",
                            textScaleFactor: 1,
                            textAlign: TextAlign.right,
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                            letterSpacing: 0.27,
                            //color: Colors.white,
                          ),
                        ),
                        Text(
                          "ETB "+data['total_price'].toString(),
                            textScaleFactor: 1,
                            textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            letterSpacing: 0.27,
                            //color: Colors.white,
                          ),

                        ),
                      ]),

                    ],
                  ),

                ],
              ),
            );


          }

          // return const Chip(
          //   avatar: CircleAvatar(
          //       backgroundColor: Colors.white,
          //       child: Icon(
          //         Icons.directions_bike,
          //         color: Colors.amber,
          //         size: 12.0,
          //       )),
          //   label: Text('On the way'),
          // );
          return SizedBox.fromSize();
        },
      );


  outOfTheKitchenOrder(BuildContext context) {
    // set up the buttons


    Widget cancelButton = FloatingActionButton.extended(
      label: const Text('Cancel'), // <-- Text
      backgroundColor: Colors.grey,
      icon: const Icon( // <-- Icon
        Icons.cancel_outlined,
        size: 24.0,
      ),
      onPressed: () {
        //Navigator.pop(context);

       // Navigator.of(context).pop();
         Navigator.of(context, rootNavigator: true).pop();
      },
    );


    Widget continueButton = FloatingActionButton.extended(
      label: const Text('Continue'), // <-- Text
      backgroundColor: Colors.amber,
      icon: Icon( // <-- Icon
        Icons.check_box_outlined,
        size: 24.0,
      ),
      onPressed: () {
        outOfTheKitchen();
       // Navigator.pop(context);
        Navigator.of(context, rootNavigator: true).pop();
      },
    );


    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Did you take the food from restaurant?"),
      content: Text("The ordered food is now being delivered to the client "),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> outOfTheKitchen() {
    return order.doc(widget.OffersHere.id).update({'confirm': 2}).then((value) =>
        print("success"),
    );
  }

  orderOnTheWay(BuildContext context) {
    // set up the buttons


    Widget cancelButton = FloatingActionButton.extended(
      label: const Text('Cancel'), // <-- Text
      backgroundColor: Colors.grey,
      icon: const Icon( // <-- Icon
        Icons.cancel_outlined,
        size: 24.0,
      ),
      onPressed: () {
        //Navigator.pop(context);
        Navigator.of(context, rootNavigator: true).pop();
      },
    );


    Widget continueButton =
    FloatingActionButton.extended(
      label: const Text('Continue'), // <-- Text
      backgroundColor: Colors.amber,
      icon: Icon( // <-- Icon
        Icons.check_box_outlined,
        size: 24.0,
      ),
      onPressed: () {
        onTheWay();
        //Navigator.pop(context);
        Navigator.of(context, rootNavigator: true).pop();
      },
    );


    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Did you deliver the food?"),
      content: const Text("The ordered food has been successfully delivered to the client  "),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> onTheWay() {
    return order.doc(widget.OffersHere.id).update({
      'confirm': 3,
      'deliveryDuration': currentDeliveryDuration,

    }).then((value) =>
       // print("success"),
      users.doc(userid).update({'totalDeliveries': FieldValue.increment(1)}).then((value) =>
          users.doc(userid).update({'totalIncome': FieldValue.increment(widget.OffersHere.price)}))
    );
  }

}
