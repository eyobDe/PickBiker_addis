import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:number_to_words/number_to_words.dart';
import 'package:pick_delivery_adama_biker/model/phoneOrders.dart';
import 'package:url_launcher/url_launcher.dart';

//import '../model/restaurant.dart';
import '../app_theme.dart';
import '../main.dart';
import '../model/order.dart';

class PhoneOrderCard extends StatefulWidget {
  PhoneOrderCard({
    required this.order,
  });

  final PhoneOrders order;

  @override
  State<PhoneOrderCard> createState() => _PhoneOrderCardState();
}

class _PhoneOrderCardState extends State<PhoneOrderCard> {
  CollectionReference orderCollection = FirebaseFirestore.instance.collection('phone_order_updated');

  CollectionReference users = FirebaseFirestore.instance.collection('biker');

  var userid = FirebaseAuth.instance.currentUser!.uid.toString();

  String currentDeliveryDuration = '';

  late StreamController<String> _timeController;
  late Stream<String> _timeStream;

  late Timer _timer;
  late Timer _countdownTimer; // New Timer for countdown

  late StreamController<String> _countdownController; // New StreamController
  late Stream<String> _countdownStream; // New Stream

  // DateTime createdTime=;

  @override
  void initState() {
    super.initState();

    // Initialize the time controller and stream
    _timeController = StreamController<String>();
    _timeStream = _timeController.stream;
     // Initialize to an empty string

    // Initialize the countdown controller and stream
    _countdownController = StreamController<String>();
    _countdownStream = _countdownController.stream;

    // Get the order's created time
    //createdTime = widget.order.created.toDate();

    // Start a timer to update the elapsed time
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!mounted) {
        // Check if the widget is still mounted before updating the stream
        return;
      }
      final now = DateTime.now();
      final difference = now.difference(widget.order.created.toDate());
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
  }



  @override
  Widget build(BuildContext context) {


    DateTime createdTime = widget.order.created.toDate();
    //String formattedTime = DateFormat('E, hh:mm a').format(createdTime);
    String formattedTime = DateFormat('E, MMM d, hh:mm a').format(createdTime);

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
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Chip(
                      avatar: const CircleAvatar(
                          backgroundColor: Colors.white,
                          //backgroundColor: DesignCourseAppTheme.delivery,
                          child: Icon(
                            Icons.access_time,
                            color: Colors.amber,
                            size: 20.0,
                          )),
                      label: Text(formattedTime),
                    ),

                    Chip(
                      avatar: const CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.play_for_work_rounded,
                            color: Colors.amber,
                            size: 20.0,
                          )),
                      label: Text(widget.order.status.toString()),
                    )
                  ],
                ),
              ),
              Center(
                child: Column(
                  children: [
                    SelectableText(
                      widget.order.order_food.toString(),
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        letterSpacing: 0.27,
                        //color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    // Your Chip widget with StreamBuilder

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
                    SelectableText(
                      widget.order.rest_name.toString(),
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        letterSpacing: 0.27,
                        //color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 18.0, top: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Table(
                      defaultColumnWidth: const FixedColumnWidth(100.0),
                      children: [
                        TableRow(children: [
                          const Text(
                            "Food price",
                            textScaleFactor: 1,
                            textAlign: TextAlign.right,

                          ),
                          Text(
                            "ETB " + widget.order.price.toString(),
                            textScaleFactor: 1,
                            textAlign: TextAlign.right,

                          ),
                        ]),

                        TableRow(children: [
                          const Text("Service charge",
                              textScaleFactor: 1, textAlign: TextAlign.right),
                          Text("ETB " + widget.order.service_charge.toString(),
                              textScaleFactor: 1, textAlign: TextAlign.right),
                        ]),


                        TableRow(children: [
                          const Text("Delivery fee",
                              textScaleFactor: 1, textAlign: TextAlign.right),
                          Text("ETB " + widget.order.delivery_charge.toString(),
                              textScaleFactor: 1, textAlign: TextAlign.right),
                        ]),

                        TableRow(children: [
                          const Text(
                            "Total pay",
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
                            "ETB " + widget.order.total_price.toString(),
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
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (widget.order.status == "Processing") ...[
                      ElevatedButton.icon(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.black),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(35.0),
                            ))),

                        // Within the `FirstRoute` widget
                        onPressed: () {
                         outOfTheKitchenOrder(context);
                        },
                        icon: const Icon(Icons.directions_bike),
                        label: const Text("On the way"),
                      ),
                    ],
                    if (widget.order.status == "On the way") ...[
                      ElevatedButton.icon(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.black),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
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
                    ],
                  ],
                ),
              ),
              Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(
                        8.0), // Adjust the padding value as needed
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35.0),
                      color: Colors.amber,
                    ),
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.location_pin,
                              color: Colors
                                  .white), // Customize the icon color as needed
                          Text(widget.order.desti.toString(),
                              style: TextStyle(
                                  color: Colors
                                      .white)), // Customize the text color as needed
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  ElevatedButton.icon(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.green),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(35.0),
                          ))),

                      // Within the `FirstRoute` widget
                      onPressed: () =>
                          // Clipboard.setData(ClipboardData(text: OffersHere.client_loc))
                          //     .then((value) { //only if ->
                          //   //ScaffoldMessenger.of(context).showSnackBar(snackBar); // -> show a notification
                          // },
                          launch("tel://" + widget.order.phone.toString()),
                      icon: const Icon(Icons.phone),
                      label: const Text("Call client")),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }

  // updateCuisine() async {
  //   var collection = FirebaseFirestore.instance.collection('cuisine');
  //   var querySnapshots = await collection.get();
  //   for (var doc in querySnapshots.docs) {
  //     await doc.reference.update({
  //       'PFee': 0,
  //     });
  //   }
  // }



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
    return orderCollection.doc(widget.order.id).update({'status': 'On the way'}).then((value) =>
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
    return orderCollection.doc(widget.order.id).update({
      'status': 'Delivered',
      'deliveryDuration': currentDeliveryDuration,
    }).then((value) =>
          users.doc(userid).update({'totalDeliveries': FieldValue.increment(1)}).then((value) =>
         users.doc(userid).update({'totalIncome': FieldValue.increment(widget.order.delivery_charge as num)})

    )
    );
  }
  Future<void> updateOrderDeliveryDuration(String deliveryDuration) async {
    try {
      final orderRef = FirebaseFirestore.instance.collection('phone_order_updated').doc(widget.order.id);

      await orderRef.update({
        'deliveryDuration': deliveryDuration,
      });

      print('Order updated with delivery duration: $deliveryDuration');
    } catch (e) {
      print('Error updating order: $e');
    }
  }
}
