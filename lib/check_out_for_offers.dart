// import 'dart:async';
// import 'dart:math';
// import 'dart:ui';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:easy_localization/src/public_ext.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:geoflutterfire/geoflutterfire.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:number_to_words/number_to_words.dart';
// import 'package:pick_delivery_adama_biker/pages/profile_page.dart';
// import 'app_theme.dart';
// import 'check_out_confirm_online_payment.dart';
// import 'model/feature.dart';
// import 'model/menu.dart';
// import 'model/offers.dart';
//
// import 'package:chapasdk/chapasdk.dart';
//
// class CheckOutOffer extends StatefulWidget {
//   CheckOutOffer({
//     Key? key,
//     // required this.restID,
//     // required this.restDoc,
//     // required this.foodItemDoc,
//     required this.menu,
//      required this.menuID,
//      required this.restID,
//   }) : super(key: key);
//
//   // final String restID;
//   // final DocumentSnapshot restDoc;
//   // final DocumentSnapshot foodItemDoc;
//
//   final Offers menu;
//
//   String menuID;
//   String restID;
//
//   @override
//   _CheckOutOfferState createState() => _CheckOutOfferState();
// }
//
// class _CheckOutOfferState extends State<CheckOutOffer> {
//   final double infoHeight = 364.0;
//
//   AnimationController? animationController;
//   Animation<double>? animation;
//
//   // var users = FirebaseFirestore.instance.collection('Users');
//   //
//   // var rests = FirebaseFirestore.instance.collection('restaurant');
//   // var coupon = FirebaseFirestore.instance.collection('coupon');
//   //
//   // var cuisineStream = FirebaseFirestore.instance.collection('cuisine');
//   var orders = FirebaseFirestore.instance.collection('order');
//   //
//   // var collection = FirebaseFirestore.instance.collection('delivery_price');
//   //
//   // var clientId = FirebaseAuth.instance.currentUser!.uid.toString();
//
//   late Geoflutterfire geo;
//   late LatLng currentPostion;
//   ConnectivityResult _connectionStatus = ConnectivityResult.none;
//   final Connectivity _connectivity = Connectivity();
//   late StreamSubscription<ConnectivityResult> _connectivitySubscription;
//
//   final globalKey = GlobalKey<ScaffoldState>();
//
//   double totalDistance = 0.0;
//   double totalPriceHere = 0.0;
//
//   double deliveryDiscount = 0.0;
//
//   double restLl = 0.0;
//   double restLn = 0.0;
//
//   int amount = 1;
//
//   final myControllerCoupon = TextEditingController();
//
//   late Future<DocumentSnapshot> future;
//
//
//   late Future<DocumentSnapshot> restaurnatHere;
//   late Future<DocumentSnapshot> menuHere;
//
//
//   late Future<Position> futureCheckOut;
//
//   var userid = FirebaseAuth.instance.currentUser!.uid;
//
//   double price1 = 0;
//   double price2 = 0;
//   double price3 = 0;
//   double price4 = 0;
//   double price5 = 0;
//   double price6 = 0;
//   double price7 = 0;
//   double price8 = 0;
//   double price9 = 0;
//
//
//   var PFee = 0;
//   var args;
//
//   String restaurant_name="";
//
//   @override
//   void initState() {
//     // animationController = AnimationController(
//     //     duration: const Duration(milliseconds: 1000), vsync: this);
//     // animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
//     //     parent: animationController!,
//     //     curve: Interval(0, 1.0, curve: Curves.fastOutSlowIn)));
//     //
//
//     super.initState();
//     _determinePosition();
//     getPosition();
//     initConnectivity();
//     //getRestPosition();
//     getPrice();
//     getRestName();
//
//     // FirebaseFirestore.instance
//     //     .collection('delivery_price')
//     //     .doc('EpUm8aQhLTWs8jlhHrEh ')
//     //     .get()
//     //     .then((DocumentSnapshot ds) {
//     //   Map<String, dynamic>? data = ds.data() as Map<String, dynamic>?;
//     //   setState(() {
//     //     price1 = data?['price1'].toDouble();
//     //     price2 = data?['price2'].toDouble();
//     //     // price3 = data?['price3'].toDouble();
//     //     // price4 = data?['price4'].toDouble();
//     //     // price5 = data?['price5'].toDouble();
//     //   });
//     //
//     //   //YPwApLUvywada1QDRqbp
//     //
//     //
//     //
//     //   // use ds as a snapshot
//     // });
//
//     geo = Geoflutterfire();
//
//     _connectivitySubscription =
//         _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
//
//     future = FirebaseFirestore.instance
//         .collection('coupon')
//         .doc("AhTZxjEyfhzkrpO9NWac")
//         .get();
//
//     restaurnatHere = FirebaseFirestore.instance
//         .collection('restaurant')
//         .doc(widget.restID)
//         .get();
//
//
//     futureCheckOut = getPosition();
//
//
//
//     Future.delayed(Duration.zero,(){
//       setState(() {
//         if(ModalRoute.of(context)?.settings.arguments!= null)
//         {
//           args=ModalRoute.of(context)?.settings.arguments;
//           print('message after payment');
//           print(args['message']);
//
//         }
//
//
//
//       });
//
//     });
//
//   }
//
//   @override
//   void dispose() {
//     _connectivitySubscription.cancel();
//
//     super.dispose();
//   }
//
//   Future<void> initConnectivity() async {
//     late ConnectivityResult result;
//     // Platform messages may fail, so we use a try/catch PlatformException.
//     try {
//       result = await _connectivity.checkConnectivity();
//     } on PlatformException catch (e) {
//       print('Couldn\'t check connectivity status');
//       return;
//     }
//
//     // If the widget was removed from the tree while the asynchronous platform
//     // message was in flight, we want to discard the reply rather than calling
//     // setState to update our non-existent appearance.
//     if (!mounted) {
//       return Future.value(null);
//     }
//
//     return _updateConnectionStatus(result);
//   }
//
//   Future<void> _updateConnectionStatus(ConnectivityResult result) async {
//     setState(() {
//       _connectionStatus = result;
//     });
//   }
//
//   Future<void> getPrice() async {
//
//
//     var docSnapshot = await  FirebaseFirestore.instance
//         .collection('delivery_price').doc('YPwApLUvywada1QDRqbp').get();
//
//     Map<String, dynamic>? data = docSnapshot.data();
//
//     // price1=data?['price1'].toDouble();
//     // price2=data?['price2'].toDouble();
//     // price3=data?['price3'].toDouble();
//     // price4=data?['price4'].toDouble();
//
//
//     price1=data?['p1'].toDouble();
//     price2=data?['p2'].toDouble();
//     price3=data?['p3'].toDouble();
//     price4=data?['p4'].toDouble();
//     price5=data?['p5'].toDouble();
//     price6=data?['p6'].toDouble();
//     price7=data?['p7'].toDouble();
//     price8=data?['p8'].toDouble();
//     price9=data?['p9'].toDouble();
//
//
//
//
//     //return (docSnapshot);
//
//     // Call setState if needed.
//
//   }
//
//   Future<void> getRestName() async {
//
//
//     var docSnapshot = await  FirebaseFirestore.instance
//         .collection('restaurant').doc(widget.menu.rest_id).get();
//
//     Map<String, dynamic>? data = docSnapshot.data();
//
//     setState(() {
//       restaurant_name=data?['rest_name'];
//
//     });
//
//
//     // Call setState if needed.
//
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     final double tempHeight = MediaQuery.of(context).size.height -
//         (MediaQuery.of(context).size.width / 1.2) +
//         24.0;
//
//     return Container(
//       color: DesignCourseAppTheme.color2,
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor:Colors.amber,
//           title:  Text(restaurant_name),
//         ),
//         key: globalKey,
//         resizeToAvoidBottomInset: false,
//         body: Stack(
//           children: [
//
//             // Column(
//             //   children: <Widget>[
//             //     AspectRatio(
//             //       aspectRatio: 2.0,
//             //       child: Card(
//             //         elevation: 18.0,
//             //         shape: CircleBorder(),
//             //         child: Container(
//             //           decoration: BoxDecoration(
//             //             //color: DesignCourseAppTheme.nearlyWhite,
//             //             borderRadius: const BorderRadius.only(
//             //               bottomLeft: Radius.circular(55.0),
//             //               bottomRight: Radius.circular(55.0),
//             //             ),
//             //
//             //             image: DecorationImage(
//             //               image: CachedNetworkImageProvider(
//             //                 widget.restDoc['photo_url'],
//             //               ),
//             //               fit: BoxFit.cover,
//             //               colorFilter: ColorFilter.mode(
//             //                   Colors.black.withOpacity(0.4), BlendMode.srcOver),
//             //             ),
//             //
//             //             boxShadow: <BoxShadow>[
//             //               BoxShadow(
//             //                   color: DesignCourseAppTheme.grey.withOpacity(0.2),
//             //                   offset: const Offset(1.1, 1.1),
//             //                   blurRadius: 10.0),
//             //             ],
//             //           ),
//             //         ),
//             //       ),
//             //     ),
//             //   ],
//             // ),
//             // // Head Image
//             // Positioned(
//             //   top: (MediaQuery.of(context).size.width / 1.5) - 34.0 - 90,
//             //   right: 35,
//             //   child: Card(
//             //     color: DesignCourseAppTheme.mainLogoColor,
//             //     shape: RoundedRectangleBorder(
//             //         borderRadius: BorderRadius.circular(50.0)),
//             //     elevation: 10.0,
//             //     child: SizedBox(
//             //       width: 60,
//             //       height: 60,
//             //       child: Center(
//             //         child: Icon(
//             //           Icons.food_bank_outlined,
//             //           color: DesignCourseAppTheme.nearlyWhite,
//             //           size: 40,
//             //         ),
//             //       ),
//             //     ),
//             //   ),
//             // ),
//             // Padding(
//             //   padding: EdgeInsets.only(
//             //       top: MediaQuery.of(context).padding.top, bottom: 18),
//             //   child: SizedBox(
//             //     width: AppBar().preferredSize.height,
//             //     height: AppBar().preferredSize.height,
//             //     child: Material(
//             //       color: Colors.amber,
//             //       borderRadius: BorderRadius.circular(15),
//             //       child: InkWell(
//             //         borderRadius:
//             //             BorderRadius.circular(AppBar().preferredSize.height),
//             //         child: Icon(
//             //           Icons.arrow_back_ios,
//             //           color: DesignCourseAppTheme.nearlyWhite,
//             //         ),
//             //         onTap: () {
//             //           Navigator.pop(context);
//             //         },
//             //       ),
//             //     ),
//             //   ),
//             // ),
//
//             // Positioned(
//             //   top: (MediaQuery.of(context).size.width / 1.5) - 34.0 - 95,
//             //   left: 18,
//             //   child: Column(
//             //     mainAxisAlignment: MainAxisAlignment.start,
//             //     crossAxisAlignment: CrossAxisAlignment.start,
//             //     children: <Widget>[
//             //       Column(
//             //         children: [
//             //           SizedBox(
//             //             width: 210,
//             //             child: Text(
//             //               widget.restDoc['rest_name'],
//             //               textAlign: TextAlign.center,
//             //               style: const TextStyle(
//             //                 fontWeight: FontWeight.w600,
//             //                 fontSize: 18,
//             //                 letterSpacing: 0.27,
//             //                 color: DesignCourseAppTheme.nearlyWhite,
//             //               ),
//             //             ),
//             //           ),
//             //           RatingBar.builder(
//             //             initialRating: widget.restDoc['rate'],
//             //             minRating: 1,
//             //             direction: Axis.horizontal,
//             //             allowHalfRating: true,
//             //             itemCount: 5,
//             //             itemSize: 19,
//             //             ignoreGestures: true,
//             //             unratedColor: Colors.white,
//             //             itemPadding:
//             //                 const EdgeInsets.symmetric(horizontal: 0.5),
//             //             itemBuilder: (context, _) => const Icon(
//             //               Icons.star,
//             //               color: Colors.amber,
//             //             ),
//             //             onRatingUpdate: (rating) {
//             //               // print(rating);
//             //             },
//             //           ),
//             //         ],
//             //       ),
//             //     ],
//             //   ),
//             // ),
//
//             Padding(
//               padding: EdgeInsets.only(
//                 left: 13,
//                 right: 3,
//                 top: 20,
//               ),
//               child: Text(
//                 widget.menu.name.toString(),
//                 style: TextStyle(
//                   fontWeight: FontWeight.w800,
//                   fontSize: 16,
//                   letterSpacing: 0.27,
//                   color: DesignCourseAppTheme.delivery,
//                 ),
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.only(
//                 left: 16,
//                 right: 16,
//                 top: 24,
//               ),
//               child: buildCoupon(),
//             ),
//             Padding(
//               padding: EdgeInsets.only(
//                 left: 46,
//                 right: 46,
//                 top: 110,
//               ),
//               child: Container(
//                 padding: const EdgeInsets.all(5),
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(5),
//                     color: Colors.amber),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center ,//Center Row contents horizontally,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     SizedBox(
//                       width: 5,
//                     ),
//                     Row(
//                       children: [
//                         Text(
//                           "Amount",
//                           style: const TextStyle(
//                             fontWeight: FontWeight.w600,
//                             fontSize: 14,
//                             letterSpacing: 0.27,
//                             color: DesignCourseAppTheme.nearlyWhite,
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       width: 5,
//                     ),
//                     InkWell(
//                         onTap: () {
//                           if (amount == 1) {
//                             null;
//                           } else {
//                             setState(() {
//                               amount = amount - 1;
//                             });
//                           }
//                         },
//                         child: Icon(
//                           Icons.remove,
//                           color: Colors.white,
//                           size: 20,
//                         )),
//                     Container(
//                       margin: EdgeInsets.symmetric(horizontal: 3),
//                       padding: EdgeInsets.symmetric(horizontal: 3, vertical: 2),
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(3),
//                           color: Colors.white),
//                       child: Text(
//                         amount.toString(),
//                         style: TextStyle(color: Colors.black, fontSize: 16),
//                       ),
//                     ),
//                     InkWell(
//                         onTap: () {
//                           if (amount == 4) {
//                             null;
//                           } else {
//                             setState(() {
//                               amount = amount + 1;
//                             });
//                           }
//                         },
//                         child: Icon(
//                           Icons.add,
//                           color: Colors.white,
//                           size: 20,
//                         )),
//                   ],
//                 ),
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.only(
//                 left: 16,
//                 right: 26,
//                 top: 190,
//               ),
//               child: buildCheckOUt(),
//             ),
//
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget buildCoupon() => FutureBuilder<DocumentSnapshot>(
//       future: future,
//       builder:
//           (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(
//             child: Padding(
//               padding: EdgeInsets.all(40),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Container(
//                     alignment: Alignment.center,
//                     child: CircularProgressIndicator(color: Colors.amber,),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         } else if (snapshot.hasData) {
//           Map<String, dynamic> data =
//           snapshot.data!.data() as Map<String, dynamic>;
//
//           if (data['status'] == true) {
//             return Padding(
//               padding: EdgeInsets.only(left: 35,top: 10),
//               child: Row(
//                 children: <Widget>[
//                   SizedBox(
//                       width: 170.0,
//                       child: TextField(
//                         controller: myControllerCoupon,
//                         decoration: const InputDecoration(
//                           border: UnderlineInputBorder(),
//                           labelText: 'Discount coupon',
//                           hintStyle: TextStyle(
//                             fontWeight: FontWeight.w300,
//                             fontSize: 13,
//                             letterSpacing: 0.27,
//                             color: Colors.black,
//                           ),
//                           labelStyle: TextStyle(
//                             fontWeight: FontWeight.w300,
//                             fontSize: 13,
//                             letterSpacing: 0.27,
//                             color: Colors.black,
//                           ),
//                         ),
//                       )),
//                   SizedBox(
//                     width: 90,
//                     child: ElevatedButton(
//                       style: ButtonStyle(
//                         backgroundColor:
//                         MaterialStateProperty.all(Colors.white60),
//                         shape:
//                         MaterialStateProperty.all<RoundedRectangleBorder>(
//                             RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(24.0),
//                             )),
//                       ),
//                       child: const Text(
//                         'Apply',
//                         style: TextStyle(
//                           fontWeight: FontWeight.w600,
//                           fontSize: 13,
//                           letterSpacing: 0.27,
//                           color: Colors.black,
//                         ),
//                       ),
//                       onPressed: () {
//                         // setState(() {
//                         //   deliveryDiscount = 210;
//                         // });
//                         FocusScope.of(context).requestFocus(FocusNode());
//                         if (equalsIgnoreCase(
//                             myControllerCoupon.text, data['coupon_code']) ==
//                             true) {
//                           dialogForCoupon(
//                             this.context,
//                             data['coupon_code'],
//                             data['display_text'],
//                             data['name_of_coupon'],
//                             data['discount_by_percent'],
//                           );
//
//                           setState(() {
//                             deliveryDiscount = double.parse(data['discount_by_percent']);
//                           });
//                         } else {
//                           dialogForCouponWrong(this.context);
//                         }
//                       },
//                     ),
//                   )
//                 ],
//               ),
//             );
//           } else {
//             return SizedBox.fromSize();
//           }
//         }
//
//         return SizedBox.fromSize();
//       });
//
//   bool equalsIgnoreCase(String string1, String string2) {
//     return string1.toLowerCase() == string2.toLowerCase();
//   }
//
//   Widget buildCheckOUt() => FutureBuilder<Position>(
//       future: futureCheckOut, // async work
//       builder: (BuildContext context, AsyncSnapshot<Position> snapshotLocation) {
//
//         //   switch (snapshotLocation.connectionState) {
//         //     case ConnectionState.waiting:
//         //       return Center(
//         //         child: Padding(
//         //           padding: EdgeInsets.all(40),
//         //           child: Column(
//         //             mainAxisAlignment: MainAxisAlignment.center,
//         //             children: [
//         //               Container(
//         //                 alignment: Alignment.center,
//         //                 child: const CircularProgressIndicator(color: Colors.amber,),
//         //               ),
//         //             ],
//         //           ),
//         //         ),
//         //       );
//         //     case ConnectionState.done:
//         //       return FutureBuilder<DocumentSnapshot>(
//         //         future: restaurnatHere, // async work
//         //         builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshotRest) {
//         //
//         //
//         //           switch (snapshotRest.connectionState) {
//         //             case ConnectionState.waiting:
//         //               return Center(
//         //                 child: Padding(
//         //                   padding: EdgeInsets.all(40),
//         //                   child: Column(
//         //                     mainAxisAlignment: MainAxisAlignment.center,
//         //                     children: [
//         //                       Container(
//         //                         alignment: Alignment.center,
//         //                         child: CircularProgressIndicator(color: Colors.amber,),
//         //                       ),
//         //                     ],
//         //                   ),
//         //                 ),
//         //               );
//         //
//         //             default:
//         //               if (snapshotRest.hasError) {
//         //                 return Padding(
//         //                   padding: EdgeInsets.all(40),
//         //                   child: Column(
//         //                     mainAxisAlignment: MainAxisAlignment.center,
//         //                     children: [
//         //                       Container(
//         //                         alignment: Alignment.center,
//         //                         child: Column(
//         //                           children: [
//         //                             const Icon(Icons.location_off),
//         //                             Text(
//         //                               '${snapshotRest.error}',
//         //                               textAlign: TextAlign.center,
//         //                             ),
//         //                           ],
//         //                         ),
//         //                       ),
//         //                     ],
//         //                   ),
//         //                 );
//         //               } else {
//         //                 geo = Geoflutterfire();
//         //                 var hereUserLat = snapshotLocation.data!.latitude;
//         //                 var hereUserLong = snapshotLocation.data!.longitude;
//         //
//         //                 var myLocationPoint =
//         //                 geo.point(latitude: hereUserLat, longitude: hereUserLong);
//         //                 Map<String, dynamic> dataRest =
//         //                 snapshotRest.data?.data() as Map<String, dynamic>;
//         //
//         //
//         //
//         //                   restaurant_name=dataRest["rest_name"];
//         //
//         //
//         //
//         //                 Map<String, dynamic> locationdata =
//         //                 dataRest['location'] as Map<String, dynamic>;
//         //
//         //                 double Restlat = locationdata['geopoint'].latitude;
//         //                 double Restlong = locationdata['geopoint'].longitude;
//         //
//         //                 var distance =
//         //                 myLocationPoint.distance(lat: Restlat, lng: Restlong);
//         //
//         //                 double distanceFormated = double.parse((distance).toStringAsFixed(1)); // total distance
//         //
//         //                 var deliveryFee = 0.0;
//         //                 var deliveryFeeBeforeDis = 0.0;
//         //                 var totalPrice = 0.0;
//         //
//         //                 // if (widget.foodItemDoc.data()!.containsKey('PFee') )
//         //
//         //                 if (widget.menu.PFee == 0) {
//         //                   PFee = dataRest['package_fee'];
//         //                 }
//         //                 else {
//         //                   PFee = widget.menu.PFee!;
//         //                 }
//         //
//         //                 if (distance < 2) {
//         //                   deliveryFeeBeforeDis = price1.toDouble();
//         //                   deliveryFee = price1.toDouble() -
//         //                       (price1.toDouble() * (deliveryDiscount / 100));
//         //                   totalPrice = (widget.menu.price)! * amount +
//         //                       deliveryFee + (PFee) * amount;
//         //
//         //                   totalPriceHere = totalPrice;
//         //                 }
//         //                 else if (distance > 2 && distance < 4) {
//         //                   deliveryFeeBeforeDis = price2.toDouble();
//         //                   deliveryFee = price2.toDouble() -
//         //                       (price2.toDouble() * (deliveryDiscount / 100));
//         //                   totalPrice =  (widget.menu.price)! * amount +
//         //                       deliveryFee +  (PFee) * amount;
//         //
//         //                   totalPriceHere = totalPrice;
//         //                 }
//         //                 else if (distance > 4 && distance < 6) {
//         //                   deliveryFeeBeforeDis = price3.toDouble();
//         //                   deliveryFee = price3.toDouble() -
//         //                       (price3.toDouble() * (deliveryDiscount / 100));
//         //                   totalPrice =  (widget.menu.price)! * amount +
//         //                       deliveryFee + (PFee) * amount;
//         //
//         //                   totalPriceHere = totalPrice;
//         //                 }
//         //                 else if (distance > 6 && distance < 9) {
//         //                   deliveryFeeBeforeDis = price4.toDouble();
//         //                   deliveryFee = price4.toDouble() -
//         //                       (price4.toDouble() * (deliveryDiscount / 100));
//         //                   totalPrice =  (widget.menu.price)! * amount +
//         //                       deliveryFee + (PFee) * amount;
//         //
//         //                   totalPriceHere = totalPrice;
//         //                 } // Test For Longer Distances
//         //                 if (distance > 9) {
//         //                   return (const Padding(
//         //                     padding: EdgeInsets.all(8.0),
//         //                     child: Center(
//         //                       child: Text(
//         //                         "We currently provide deliveries from restaurants in the range of 9kms maximum."
//         //                             "Please choose another restaurant nearby, Thank you",
//         //                         textAlign: TextAlign.center,
//         //                         style: TextStyle(
//         //                           fontWeight: FontWeight.w400,
//         //                           fontSize: 12,
//         //                           letterSpacing: 0.27,
//         //                           color: Colors.grey,
//         //                         ),
//         //                       ),
//         //                     ),
//         //                   ));
//         //                 }
//         //
//         //                 if (distance < 20) {
//         //                   return ((Padding(
//         //                     padding: const EdgeInsets.all(8.0),
//         //                     child: Column(
//         //                       mainAxisSize: MainAxisSize.min,
//         //                       children: [
//         //                         Table(
//         //
//         //                           // textDirection: TextDirection.rtl,
//         //                           // defaultVerticalAlignment: TableCellVerticalAlignment.bottom,
//         //                           // border:TableBorder.all(width: 2.0,color: Colors.red),
//         //
//         //                           children: [
//         //                             TableRow(children: [
//         //                               Text("Subtotal",
//         //                                   textScaleFactor: 1,
//         //                                   textAlign: TextAlign.right),
//         //                               Text(
//         //                                   (widget.menu.price! * amount).toString(),
//         //                                   textScaleFactor: 1,
//         //                                   textAlign: TextAlign.right),
//         //                             ]),
//         //                             TableRow(children: [
//         //                               Text("Packaging fee",
//         //                                   textScaleFactor: 1,
//         //                                   textAlign: TextAlign.right),
//         //                               Text(
//         //                                   (PFee * amount).toString(),
//         //                                   textScaleFactor: 1,
//         //                                   textAlign: TextAlign.right),
//         //                             ]),
//         //                             TableRow(children: [
//         //                               Text("Delivery fee",
//         //                                   textScaleFactor: 1,
//         //                                   textAlign: TextAlign.right),
//         //                               Text(deliveryFeeBeforeDis.toString(),
//         //                                   textScaleFactor: 1,
//         //                                   textAlign: TextAlign.right),
//         //                             ]),
//         //                             TableRow(children: [
//         //                               Text("Delivery discount",
//         //                                   textScaleFactor: 1,
//         //                                   textAlign: TextAlign.right),
//         //                               Text(deliveryDiscount.toString() + "%",
//         //                                   textScaleFactor: 1,
//         //                                   textAlign: TextAlign.right),
//         //                             ]),
//         //                             TableRow(children: [
//         //                               Text("Amount",
//         //                                   textScaleFactor: 1,
//         //                                   textAlign: TextAlign.right),
//         //                               Text(NumberToWord().convert('en-in', amount),
//         //                                   textScaleFactor: 1,
//         //                                   textAlign: TextAlign.right),
//         //                             ]),
//         //                             TableRow(children: [
//         //                               Text("Total pay",
//         //                                   textScaleFactor: 1.5,
//         //                                   textAlign: TextAlign.right),
//         //                               Text("ETB " + totalPriceHere.toString(),
//         //                                   textScaleFactor: 1.5,
//         //                                   textAlign: TextAlign.right),
//         //                             ]),
//         //                           ],
//         //                         ),
//         //                         const SizedBox(
//         //                           height: 10,
//         //                         ),
//         //                         const Center(
//         //                           child: Text(
//         //                             "We currently accept only cash up on delivery, Thanks for your understanding",
//         //                             textAlign: TextAlign.right,
//         //                             style: TextStyle(
//         //                               fontWeight: FontWeight.w400,
//         //                               fontSize: 12,
//         //                               letterSpacing: 0.27,
//         //                               color: Colors.grey,
//         //                             ),
//         //                           ),
//         //                         ),
//         //                         const SizedBox(
//         //                           height: 6,
//         //                         ),
//         //                         Center(
//         //                           child: SizedBox(
//         //                             width: double.infinity, // <-- match-parent
//         //                             child: ElevatedButton(
//         //                               style: ButtonStyle(
//         //                                 backgroundColor:
//         //                                 MaterialStateProperty.all(Colors.amber),
//         //                                 shape: MaterialStateProperty.all<
//         //                                     RoundedRectangleBorder>(
//         //                                     RoundedRectangleBorder(
//         //                                       borderRadius: BorderRadius.circular(24.0),
//         //                                     )),
//         //                               ),
//         //                               child: const Text(
//         //                                 'Confirm order',
//         //                                 style: TextStyle(
//         //                                   fontWeight: FontWeight.w800,
//         //                                   fontSize: 13,
//         //                                   letterSpacing: 0.27,
//         //                                   color: Colors.white,
//         //                                 ),
//         //                               ),
//         //                               onPressed: () {
//         //
//         //
//         //                                 order(
//         //                                     deliveryDiscount,
//         //                                     deliveryFeeBeforeDis,
//         //                                     totalPriceHere,
//         //                                     amount,
//         //                                     hereUserLat,
//         //                                     hereUserLong,
//         //                                     Restlat,
//         //                                     Restlong);
//         //
//         //
//         //
//         //                                 // Navigator.of(context).pop();
//         //
//         //                                 Navigator.push<dynamic>(
//         //                                   context,
//         //                                   MaterialPageRoute<dynamic>(
//         //                                     builder: (BuildContext context) =>
//         //                                         ProfilePage(),
//         //                                   ),
//         //                                 );
//         //                               },
//         //                             ),
//         //                           ),
//         //                         )
//         //                       ],
//         //                     ),
//         //                   )));
//         //                 }
//         //
//         //                 return (SizedBox.fromSize());
//         //               }
//         //           }
//         //         },
//         //       );
//         //
//         // }
//
//         if (snapshotLocation.connectionState == ConnectionState.waiting) {
//           return Center(
//             child: Padding(
//               padding: EdgeInsets.all(40),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Container(
//                     alignment: Alignment.center,
//                     child: CircularProgressIndicator(color: Colors.amber,),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }
//
//         else if(snapshotLocation.hasError){
//
//           return Padding(
//             padding: EdgeInsets.all(40),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                   alignment: Alignment.center,
//                   child: Column(
//                     children: [
//                       const Icon(Icons.location_off),
//                       Text(
//                         '${snapshotLocation.error}',
//                         textAlign: TextAlign.center,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }
//         else if(snapshotLocation.hasData){
//           return FutureBuilder<DocumentSnapshot>(
//             future: restaurnatHere, // async work
//             builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshotRest) {
//               switch (snapshotRest.connectionState) {
//                 case ConnectionState.waiting:
//                   return Center(
//                     child: Padding(
//                       padding: EdgeInsets.all(40),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Container(
//                             alignment: Alignment.center,
//                             child: CircularProgressIndicator(color: Colors.amber,),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//
//                 default:
//                   if (snapshotRest.hasError) {
//                     return Padding(
//                       padding: EdgeInsets.all(40),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Container(
//                             alignment: Alignment.center,
//                             child: Column(
//                               children: [
//                                 const Icon(Icons.location_off),
//                                 Text(
//                                   '${snapshotRest.error}',
//                                   textAlign: TextAlign.center,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   } else {
//                     geo = Geoflutterfire();
//                     var hereUserLat = snapshotLocation.data!.latitude;
//                     var hereUserLong = snapshotLocation.data!.longitude;
//
//                     var myLocationPoint = geo.point(latitude: hereUserLat, longitude: hereUserLong);
//
//                     Map<String, dynamic> dataRest =
//                     snapshotRest.data?.data() as Map<String, dynamic>;
//
//
//
//                     restaurant_name=dataRest["rest_name"];
//
//
//
//                     Map<String, dynamic> locationdata = dataRest['location'] as Map<String, dynamic>;
//                     double Restlat = locationdata['geopoint'].latitude;
//                     double Restlong = locationdata['geopoint'].longitude;
//
//                     var distance = myLocationPoint.distance(lat: Restlat, lng: Restlong);
//
//
//
//                     double distanceFormated = double.parse((distance).toStringAsFixed(1)); // total distance
//
//                     var deliveryFee = 0.0;
//                     var deliveryFeeBeforeDis = 0.0;
//                     var totalPrice = 0.0;
//                     var serviceFee=0.0;
//
//                     var totalPriceWitoutDFee = 0;
//
//
//                     // if (widget.foodItemDoc.data()!.containsKey('PFee') )
//
//                     if (widget.menu.PFee == 0) {
//                       PFee = dataRest['package_fee'];
//                     }
//                     else {
//                       PFee = widget.menu.PFee!;
//                     }
//
//                     // if (distance < 3) {
//                     //   deliveryFeeBeforeDis = price1.toDouble();
//                     //   deliveryFee = price1.toDouble() -
//                     //       (price1.toDouble() * (deliveryDiscount / 100));
//                     //   totalPrice = (widget.menu.price)! * amount +
//                     //       deliveryFee + (PFee) * amount;
//                     //
//                     //   totalPriceHere = totalPrice;
//                     // }
//                     // else if (distance > 3 && distance < 6) {
//                     //   deliveryFeeBeforeDis = price2.toDouble();
//                     //   deliveryFee = price2.toDouble() -
//                     //       (price2.toDouble() * (deliveryDiscount / 100));
//                     //   totalPrice =  (widget.menu.price)! * amount +
//                     //       deliveryFee +  (PFee) * amount;
//                     //
//                     //   totalPriceHere = totalPrice;
//                     // }
//                     // else if (distance > 6 && distance < 8) {
//                     //   deliveryFeeBeforeDis = price3.toDouble();
//                     //   deliveryFee = price3.toDouble() -
//                     //       (price3.toDouble() * (deliveryDiscount / 100));
//                     //   totalPrice =  (widget.menu.price)! * amount +
//                     //       deliveryFee + (PFee) * amount;
//                     //
//                     //   totalPriceHere = totalPrice;
//                     // }
//                     // else if (distance > 8 && distance < 12) {
//                     //   deliveryFeeBeforeDis = price4.toDouble();
//                     //   deliveryFee = price4.toDouble() -
//                     //       (price4.toDouble() * (deliveryDiscount / 100));
//                     //   totalPrice =  (widget.menu.price)! * amount +
//                     //       deliveryFee + (PFee) * amount;
//                     //
//                     //   totalPriceHere = totalPrice;
//                     // }
//
//                     // Test For Longer Distances
//
//                     //DAY TIME
//                     if(checkRestaurentStatus("07:00PM","06:00AM")==false){
//
//
//                       if (distance < 0.5) {
//
//
//                         totalPriceWitoutDFee =((widget.menu.price)! * amount +  (PFee) * amount);
//                         serviceFee = ((((widget.menu.price)! * amount) + (PFee * amount)) * (dataRest["service_fee"]) / 100);
//
//
//                         if(totalPriceWitoutDFee <= 700.00) {
//                           deliveryFeeBeforeDis = price1.toDouble();
//                           deliveryFee = price1.toDouble() - (price1.toDouble() * (deliveryDiscount / 100));
//                           totalPrice = (widget.menu.price)! * amount + deliveryFee + (PFee) * amount;
//                           totalPriceHere = totalPrice+serviceFee;
//
//                         }
//                         else if(totalPriceWitoutDFee >= 701.00 && totalPriceWitoutDFee <= 999.00) {
//                           deliveryFeeBeforeDis = price2.toDouble();
//                           deliveryFee = price2.toDouble() - (price2.toDouble() * (deliveryDiscount / 100));
//                           totalPrice = (widget.menu.price)! * amount + deliveryFee + (PFee) * amount;
//                           totalPriceHere = totalPrice+serviceFee;
//
//                         }
//                         else if(totalPriceWitoutDFee >= 1000.00) {
//                           deliveryFeeBeforeDis = price3.toDouble();
//                           deliveryFee = price3.toDouble() - (price3.toDouble() * (deliveryDiscount / 100));
//                           totalPrice = (widget.menu.price)! * amount + deliveryFee + (PFee) * amount;
//                           totalPriceHere = totalPrice+serviceFee;
//
//                         }
//
//
//
//                       }
//
//                       else if (distance > 0.5 && distance < 1) {
//                         totalPriceWitoutDFee =((widget.menu.price)! * amount +  (PFee) * amount);
//                         serviceFee = ((((widget.menu.price)! * amount) + (PFee * amount)) * (dataRest["service_fee"]) / 100);
//
//
//                         if(totalPriceWitoutDFee <= 700.00) {
//                           deliveryFeeBeforeDis = price2.toDouble();
//                           deliveryFee = price2.toDouble() - (price2.toDouble() * (deliveryDiscount / 100));
//                           totalPrice = (widget.menu.price)! * amount + deliveryFee + (PFee) * amount;
//                           totalPriceHere = totalPrice+serviceFee;
//
//                         }
//                         else if(totalPriceWitoutDFee >= 701.00 && totalPriceWitoutDFee <= 999.00) {
//                           deliveryFeeBeforeDis = price3.toDouble();
//                           deliveryFee = price3.toDouble() - (price3.toDouble() * (deliveryDiscount / 100));
//                           totalPrice = (widget.menu.price)! * amount + deliveryFee + (PFee) * amount;
//                           totalPriceHere = totalPrice+serviceFee;
//
//                         }
//                         else if(totalPriceWitoutDFee >= 1000.00) {
//                           deliveryFeeBeforeDis = price4.toDouble();
//                           deliveryFee = price4.toDouble() - (price4.toDouble() * (deliveryDiscount / 100));
//                           totalPrice = (widget.menu.price)! * amount + deliveryFee + (PFee) * amount;
//                           totalPriceHere = totalPrice+serviceFee;
//
//                         }
//
//                       }
//
//                       else if (distance > 1 && distance < 1.5) {
//                         totalPriceWitoutDFee =((widget.menu.price)! * amount +  (PFee) * amount);
//                         serviceFee = ((((widget.menu.price)! * amount) + (PFee * amount)) * (dataRest["service_fee"]) / 100);
//
//
//                         if(totalPriceWitoutDFee <= 700.00) {
//                           deliveryFeeBeforeDis = price3.toDouble();
//                           deliveryFee = price3.toDouble() - (price3.toDouble() * (deliveryDiscount / 100));
//                           totalPrice = (widget.menu.price)! * amount + deliveryFee + (PFee) * amount;
//                           totalPriceHere = totalPrice+serviceFee;
//
//                         }
//                         else if(totalPriceWitoutDFee >= 701.00 && totalPriceWitoutDFee <= 999.00) {
//                           deliveryFeeBeforeDis = price4.toDouble();
//                           deliveryFee = price4.toDouble() - (price4.toDouble() * (deliveryDiscount / 100));
//                           totalPrice = (widget.menu.price)! * amount + deliveryFee + (PFee) * amount;
//                           totalPriceHere = totalPrice+serviceFee;
//
//                         }
//                         else if(totalPriceWitoutDFee >= 1000.00) {
//                           deliveryFeeBeforeDis = price5.toDouble();
//                           deliveryFee = price5.toDouble() - (price5.toDouble() * (deliveryDiscount / 100));
//                           totalPrice = (widget.menu.price)! * amount + deliveryFee + (PFee) * amount;
//                           totalPriceHere = totalPrice+serviceFee;
//
//                         }
//
//                       }
//
//                       else if (distance > 1.5 && distance < 2) {
//                         totalPriceWitoutDFee =((widget.menu.price)! * amount +  (PFee) * amount) ;
//                         serviceFee = ((((widget.menu.price)! * amount) + (PFee * amount)) * (dataRest["service_fee"]) / 100);
//
//
//                         if(totalPriceWitoutDFee <= 700.00) {
//                           deliveryFeeBeforeDis = price4.toDouble();
//                           deliveryFee = price4.toDouble() - (price4.toDouble() * (deliveryDiscount / 100));
//                           totalPrice = (widget.menu.price)! * amount + deliveryFee + (PFee) * amount;
//                           totalPriceHere = totalPrice;
//
//                         }
//                         else if(totalPriceWitoutDFee >= 701.00 && totalPriceWitoutDFee <= 999.00) {
//                           deliveryFeeBeforeDis = price5.toDouble();
//                           deliveryFee = price5.toDouble() - (price5.toDouble() * (deliveryDiscount / 100));
//                           totalPrice = (widget.menu.price)! * amount + deliveryFee + (PFee) * amount;
//                           totalPriceHere = totalPrice+serviceFee;
//
//
//
//                         }
//                         else if(totalPriceWitoutDFee >= 1000.00) {
//                           deliveryFeeBeforeDis = price6.toDouble();
//                           deliveryFee = price6.toDouble() - (price6.toDouble() * (deliveryDiscount / 100));
//                           totalPrice = (widget.menu.price)! * amount + deliveryFee + (PFee) * amount;
//                           totalPriceHere = totalPrice+serviceFee;
//
//
//                         }
//
//                       }
//
//                       else if (distance > 2 && distance < 3) {
//                         totalPriceWitoutDFee =((widget.menu.price)! * amount +  (PFee) * amount);
//                         serviceFee = ((((widget.menu.price)! * amount) + (PFee * amount)) * (dataRest["service_fee"]) / 100);
//
//
//                         if(totalPriceWitoutDFee <= 700.00) {
//                           deliveryFeeBeforeDis = price5.toDouble();
//                           deliveryFee = price5.toDouble() - (price5.toDouble() * (deliveryDiscount / 100));
//                           totalPrice = (widget.menu.price)! * amount + deliveryFee + (PFee) * amount;
//                           totalPriceHere = totalPrice+serviceFee;
//
//                         }
//                         else if(totalPriceWitoutDFee >= 701.00 && totalPriceWitoutDFee <= 999.00) {
//                           deliveryFeeBeforeDis = price6.toDouble();
//                           deliveryFee = price6.toDouble() - (price6.toDouble() * (deliveryDiscount / 100));
//                           totalPrice = (widget.menu.price)! * amount + deliveryFee + (PFee) * amount;
//                           totalPriceHere = totalPrice+serviceFee;
//
//                         }
//                         else if(totalPriceWitoutDFee >= 1000.00) {
//                           deliveryFeeBeforeDis = price7.toDouble();
//                           deliveryFee = price7.toDouble() - (price7.toDouble() * (deliveryDiscount / 100));
//                           totalPrice = (widget.menu.price)! * amount + deliveryFee + (PFee) * amount;
//                           totalPriceHere = totalPrice+serviceFee;
//
//                         }
//
//                       }
//
//                       else if (distance > 3 && distance < 4) {
//                         totalPriceWitoutDFee =((widget.menu.price)! * amount +  (PFee) * amount);
//                         serviceFee = ((((widget.menu.price)! * amount) + (PFee * amount)) * (dataRest["service_fee"]) / 100);
//
//
//                         if(totalPriceWitoutDFee <= 700.00) {
//                           deliveryFeeBeforeDis = price6.toDouble();
//                           deliveryFee = price6.toDouble() - (price6.toDouble() * (deliveryDiscount / 100));
//                           totalPrice = (widget.menu.price)! * amount + deliveryFee + (PFee) * amount;
//                           totalPriceHere = totalPrice+serviceFee;
//
//                         }
//                         else if(totalPriceWitoutDFee >= 701.00 && totalPriceWitoutDFee <= 999.00) {
//                           deliveryFeeBeforeDis = price7.toDouble();
//                           deliveryFee = price7.toDouble() - (price7.toDouble() * (deliveryDiscount / 100));
//                           totalPrice = (widget.menu.price)! * amount + deliveryFee + (PFee) * amount;
//                           totalPriceHere = totalPrice+serviceFee;
//
//                         }
//                         else if(totalPriceWitoutDFee >= 1000.00) {
//                           deliveryFeeBeforeDis = price8.toDouble();
//                           deliveryFee = price8.toDouble() - (price8.toDouble() * (deliveryDiscount / 100));
//                           totalPrice = (widget.menu.price)! * amount + deliveryFee + (PFee) * amount;
//                           totalPriceHere = totalPrice+serviceFee;
//
//                         }
//
//                       }
//
//                       else if (distance > 4 && distance < 5) {
//                         totalPriceWitoutDFee =((widget.menu.price)! * amount +  (PFee) * amount);
//                         serviceFee = ((((widget.menu.price)! * amount) + (PFee * amount)) * (dataRest["service_fee"]) / 100);
//
//
//                         if(totalPriceWitoutDFee <= 700.00) {
//                           deliveryFeeBeforeDis = price7.toDouble();
//                           deliveryFee = price7.toDouble() - (price7.toDouble() * (deliveryDiscount / 100));
//                           totalPrice = (widget.menu.price)! * amount + deliveryFee + (PFee) * amount;
//                           totalPriceHere = totalPrice+serviceFee;
//
//                         }
//                         else if(totalPriceWitoutDFee >= 701.00 && totalPriceWitoutDFee <= 999.00) {
//                           deliveryFeeBeforeDis = price8.toDouble();
//                           deliveryFee = price8.toDouble() - (price8.toDouble() * (deliveryDiscount / 100));
//                           totalPrice = (widget.menu.price)! * amount + deliveryFee + (PFee) * amount;
//                           totalPriceHere = totalPrice+serviceFee;
//
//                         }
//                         else if(totalPriceWitoutDFee >= 1000.00) {
//                           deliveryFeeBeforeDis = price9.toDouble();
//                           deliveryFee = price9.toDouble() - (price9.toDouble() * (deliveryDiscount / 100));
//                           totalPrice = (widget.menu.price)! * amount + deliveryFee + (PFee) * amount;
//                           totalPriceHere =totalPrice+serviceFee;
//
//                         }
//
//                       }
//
//                       else if (distance > 5 && distance < 5.5) {
//                         totalPriceWitoutDFee =((widget.menu.price)! * amount +  (PFee) * amount);
//                         serviceFee = ((((widget.menu.price)! * amount) + (PFee * amount)) * (dataRest["service_fee"]) / 100);
//
//
//                         if(totalPriceWitoutDFee <= 700.00) {
//                           deliveryFeeBeforeDis = price8.toDouble();
//                           deliveryFee = price8.toDouble() - (price8.toDouble() * (deliveryDiscount / 100));
//                           totalPrice = (widget.menu.price)! * amount + deliveryFee + (PFee) * amount;
//                           totalPriceHere = totalPrice+serviceFee;
//
//                         }
//                         else if(totalPriceWitoutDFee >= 701.00 && totalPriceWitoutDFee <= 999.00) {
//                           deliveryFeeBeforeDis = price9.toDouble();
//                           deliveryFee = price9.toDouble() - (price9.toDouble() * (deliveryDiscount / 100));
//                           totalPrice = (widget.menu.price)! * amount + deliveryFee + (PFee) * amount;
//                           totalPriceHere = totalPrice+serviceFee;
//
//                         }
//                         else if(totalPriceWitoutDFee >= 1000.00) {
//                           // deliveryFeeBeforeDis = price3.toDouble();
//                           // deliveryFee = price3.toDouble() - (price3.toDouble() * (deliveryDiscount / 100));
//                           // totalPrice = (widget.menu.price)! * amount + deliveryFee + (PFee) * amount;
//                           // totalPriceHere = totalPrice;
//
//                           return (const Padding(
//                             padding: EdgeInsets.all(8.0),
//                             child: Center(
//                               child: Text(
//                                 "You have exceeded our order limit for your current distance "
//                                     "Please update your order or contact us by calling 9857, Thank you",
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.w400,
//                                   fontSize: 12,
//                                   letterSpacing: 0.27,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                             ),
//                           ));
//
//                         }
//
//                       }
//
//                       else if (distance > 5.5 && distance < 6) {
//                         totalPriceWitoutDFee =((widget.menu.price)! * amount +  (PFee) * amount);
//                         serviceFee = ((((widget.menu.price)! * amount) + (PFee * amount)) * (dataRest["service_fee"]) / 100);
//
//
//                         if(totalPriceWitoutDFee <=700.00) {
//                           deliveryFeeBeforeDis = price9.toDouble();
//                           deliveryFee = price9.toDouble() - (price1.toDouble() * (deliveryDiscount / 100));
//                           totalPrice = (widget.menu.price)! * amount + deliveryFee + (PFee) * amount;
//                           totalPriceHere = totalPrice+serviceFee;
//
//                         }
//
//                         // else if(totalPriceWitoutDFee > 500.00 && totalPriceWitoutDFee < 100.00) {
//                         //   deliveryFeeBeforeDis = price2.toDouble();
//                         //   deliveryFee = price2.toDouble() - (price2.toDouble() * (deliveryDiscount / 100));
//                         //   totalPrice = (widget.menu.price)! * amount + deliveryFee + (PFee) * amount;
//                         //   totalPriceHere = totalPrice;
//                         //
//                         // }
//                         // else if(totalPriceWitoutDFee > 1000.00) {
//                         //   deliveryFeeBeforeDis = price3.toDouble();
//                         //   deliveryFee = price3.toDouble() - (price3.toDouble() * (deliveryDiscount / 100));
//                         //   totalPrice = (widget.menu.price)! * amount + deliveryFee + (PFee) * amount;
//                         //   totalPriceHere = totalPrice;
//                         //
//                         // }
//                         return const Padding(
//                           padding: EdgeInsets.all(8.0),
//                           child: Center(
//                             child: Text(
//                               "You have exceeded our order limit for your current distance "
//                                   "Please update your order or contact us by calling 9857, Thank you",
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                 fontWeight: FontWeight.w400,
//                                 fontSize: 12,
//                                 letterSpacing: 0.27,
//                                 color: Colors.grey,
//                               ),
//                             ),
//                           ),
//                         );
//
//                       }
//
//
//                     }
//
//                     //NIGHT TIME
//                     else if(checkRestaurentStatus("07:00PM","06:00AM")==true){
//
//
//                       if (distance < 0.5) {
//
//
//                         totalPriceWitoutDFee =((widget.menu.price)! * amount +  (PFee) * amount);
//                         serviceFee = ((((widget.menu.price)! * amount) + (PFee * amount)) * (dataRest["service_fee"]) / 100);
//
//
//                         if(totalPriceWitoutDFee <=700.00) {
//                           deliveryFeeBeforeDis = price2.toDouble();
//                           deliveryFee = price2.toDouble() - (price2.toDouble() * (deliveryDiscount / 100));
//                           totalPrice = (widget.menu.price)! * amount + deliveryFee + (PFee) * amount;
//                           totalPriceHere = totalPrice+serviceFee;
//
//                         }
//                         else if(totalPriceWitoutDFee >= 701.00 && totalPriceWitoutDFee <=999.00) {
//                           deliveryFeeBeforeDis = price3.toDouble();
//                           deliveryFee = price3.toDouble() - (price3.toDouble() * (deliveryDiscount / 100));
//                           totalPrice = (widget.menu.price)! * amount + deliveryFee + (PFee) * amount;
//                           totalPriceHere = totalPrice+serviceFee;
//
//                         }
//                         else if(totalPriceWitoutDFee > 1000.00) {
//                           deliveryFeeBeforeDis = price4.toDouble();
//                           deliveryFee = price4.toDouble() - (price4.toDouble() * (deliveryDiscount / 100));
//                           totalPrice = (widget.menu.price)! * amount + deliveryFee + (PFee) * amount;
//                           totalPriceHere = totalPrice+serviceFee;
//
//                         }
//
//
//
//                       }
//
//                       else if (distance > 0.5 && distance < 1) {
//                         totalPriceWitoutDFee =((widget.menu.price)! * amount +  (PFee) * amount);
//                         serviceFee = ((((widget.menu.price)! * amount) + (PFee * amount)) * (dataRest["service_fee"]) / 100);
//
//
//                         if(totalPriceWitoutDFee <=700.00) {
//                           deliveryFeeBeforeDis = price3.toDouble();
//                           deliveryFee = price3.toDouble() - (price3.toDouble() * (deliveryDiscount / 100));
//                           totalPrice = (widget.menu.price)! * amount + deliveryFee + (PFee) * amount;
//                           totalPriceHere = totalPrice+serviceFee;
//
//                         }
//                         else if(totalPriceWitoutDFee >= 701.00 && totalPriceWitoutDFee <=999.00) {
//                           deliveryFeeBeforeDis = price4.toDouble();
//                           deliveryFee = price4.toDouble() - (price4.toDouble() * (deliveryDiscount / 100));
//                           totalPrice = (widget.menu.price)! * amount + deliveryFee + (PFee) * amount;
//                           totalPriceHere = totalPrice+serviceFee;
//
//                         }
//                         else if(totalPriceWitoutDFee > 1000.00) {
//                           deliveryFeeBeforeDis = price5.toDouble();
//                           deliveryFee = price5.toDouble() - (price5.toDouble() * (deliveryDiscount / 100));
//                           totalPrice = (widget.menu.price)! * amount + deliveryFee + (PFee) * amount;
//                           totalPriceHere = totalPrice+serviceFee;
//
//                         }
//
//                       }
//
//                       else if (distance > 1 && distance < 1.5) {
//                         totalPriceWitoutDFee =((widget.menu.price)! * amount +  (PFee) * amount);
//                         serviceFee = ((((widget.menu.price)! * amount) + (PFee * amount)) * (dataRest["service_fee"]) / 100);
//
//
//                         if(totalPriceWitoutDFee <=700.00) {
//                           deliveryFeeBeforeDis = price4.toDouble();
//                           deliveryFee = price4.toDouble() - (price4.toDouble() * (deliveryDiscount / 100));
//                           totalPrice = (widget.menu.price)! * amount + deliveryFee + (PFee) * amount;
//                           totalPriceHere = totalPrice+serviceFee;
//
//                         }
//                         else if(totalPriceWitoutDFee >= 701.00 && totalPriceWitoutDFee <=999.00) {
//                           deliveryFeeBeforeDis = price5.toDouble();
//                           deliveryFee = price5.toDouble() - (price5.toDouble() * (deliveryDiscount / 100));
//                           totalPrice = (widget.menu.price)! * amount + deliveryFee + (PFee) * amount;
//                           totalPriceHere = totalPrice+serviceFee;
//
//                         }
//                         else if(totalPriceWitoutDFee > 1000.00) {
//                           deliveryFeeBeforeDis = price6.toDouble();
//                           deliveryFee = price6.toDouble() - (price6.toDouble() * (deliveryDiscount / 100));
//                           totalPrice = (widget.menu.price)! * amount + deliveryFee + (PFee) * amount;
//                           totalPriceHere = totalPrice+serviceFee;
//
//                         }
//
//                       }
//
//                       else if (distance > 1.5 && distance < 2) {
//                         totalPriceWitoutDFee =((widget.menu.price)! * amount +  (PFee) * amount) ;
//                         serviceFee = ((((widget.menu.price)! * amount) + (PFee * amount)) * (dataRest["service_fee"]) / 100);
//
//
//                         if(totalPriceWitoutDFee <= 700.00) {
//                           deliveryFeeBeforeDis = price5.toDouble();
//                           deliveryFee = price5.toDouble() - (price5.toDouble() * (deliveryDiscount / 100));
//                           totalPrice = (widget.menu.price)! * amount + deliveryFee + (PFee) * amount;
//                           totalPriceHere = totalPrice;
//
//                         }
//                         else if(totalPriceWitoutDFee >= 701.00 && totalPriceWitoutDFee <=999.00) {
//                           deliveryFeeBeforeDis = price6.toDouble();
//                           deliveryFee = price6.toDouble() - (price6.toDouble() * (deliveryDiscount / 100));
//                           totalPrice = (widget.menu.price)! * amount + deliveryFee + (PFee) * amount;
//                           totalPriceHere = totalPrice+serviceFee;
//
//
//
//                         }
//                         else if(totalPriceWitoutDFee > 1000.00) {
//                           deliveryFeeBeforeDis = price7.toDouble();
//                           deliveryFee = price7.toDouble() - (price7.toDouble() * (deliveryDiscount / 100));
//                           totalPrice = (widget.menu.price)! * amount + deliveryFee + (PFee) * amount;
//                           totalPriceHere = totalPrice+serviceFee;
//
//
//                         }
//
//                       }
//
//                       else if (distance > 2 && distance < 3) {
//                         totalPriceWitoutDFee =((widget.menu.price)! * amount +  (PFee) * amount);
//                         serviceFee = ((((widget.menu.price)! * amount) + (PFee * amount)) * (dataRest["service_fee"]) / 100);
//
//
//                         if(totalPriceWitoutDFee <=700.00) {
//                           deliveryFeeBeforeDis = price6.toDouble();
//                           deliveryFee = price6.toDouble() - (price6.toDouble() * (deliveryDiscount / 100));
//                           totalPrice = (widget.menu.price)! * amount + deliveryFee + (PFee) * amount;
//                           totalPriceHere = totalPrice+serviceFee;
//
//                         }
//                         else if(totalPriceWitoutDFee >= 701.00 && totalPriceWitoutDFee <=999.00) {
//                           deliveryFeeBeforeDis = price7.toDouble();
//                           deliveryFee = price7.toDouble() - (price7.toDouble() * (deliveryDiscount / 100));
//                           totalPrice = (widget.menu.price)! * amount + deliveryFee + (PFee) * amount;
//                           totalPriceHere = totalPrice+serviceFee;
//
//                         }
//                         else if(totalPriceWitoutDFee > 1000.00) {
//                           deliveryFeeBeforeDis = price8.toDouble();
//                           deliveryFee = price8.toDouble() - (price8.toDouble() * (deliveryDiscount / 100));
//                           totalPrice = (widget.menu.price)! * amount + deliveryFee + (PFee) * amount;
//                           totalPriceHere = totalPrice+serviceFee;
//
//                         }
//
//                       }
//
//                       else if (distance > 3 && distance < 4) {
//                         totalPriceWitoutDFee =((widget.menu.price)! * amount +  (PFee) * amount);
//                         serviceFee = ((((widget.menu.price)! * amount) + (PFee * amount)) * (dataRest["service_fee"]) / 100);
//
//
//                         if(totalPriceWitoutDFee <=700.00) {
//                           deliveryFeeBeforeDis = price7.toDouble();
//                           deliveryFee = price7.toDouble() - (price7.toDouble() * (deliveryDiscount / 100));
//                           totalPrice = (widget.menu.price)! * amount + deliveryFee + (PFee) * amount;
//                           totalPriceHere = totalPrice+serviceFee;
//
//                         }
//                         else if(totalPriceWitoutDFee >= 701.00 && totalPriceWitoutDFee <=999.00) {
//                           deliveryFeeBeforeDis = price8.toDouble();
//                           deliveryFee = price8.toDouble() - (price8.toDouble() * (deliveryDiscount / 100));
//                           totalPrice = (widget.menu.price)! * amount + deliveryFee + (PFee) * amount;
//                           totalPriceHere = totalPrice+serviceFee;
//
//                         }
//                         else if(totalPriceWitoutDFee > 1000.00) {
//                           deliveryFeeBeforeDis = price9.toDouble();
//                           deliveryFee = price9.toDouble() - (price9.toDouble() * (deliveryDiscount / 100));
//                           totalPrice = (widget.menu.price)! * amount + deliveryFee + (PFee) * amount;
//                           totalPriceHere = totalPrice+serviceFee;
//
//                         }
//
//                       }
//
//                       else if (distance > 4 && distance < 5) {
//                         totalPriceWitoutDFee =((widget.menu.price)! * amount +  (PFee) * amount);
//                         serviceFee = ((((widget.menu.price)! * amount) + (PFee * amount)) * (dataRest["service_fee"]) / 100);
//
//
//                         if(totalPriceWitoutDFee <=700.00) {
//                           deliveryFeeBeforeDis = price8.toDouble();
//                           deliveryFee = price8.toDouble() - (price8.toDouble() * (deliveryDiscount / 100));
//                           totalPrice = (widget.menu.price)! * amount + deliveryFee + (PFee) * amount;
//                           totalPriceHere = totalPrice+serviceFee;
//
//                         }
//                         else if(totalPriceWitoutDFee >= 701.00 && totalPriceWitoutDFee <=999.00) {
//                           deliveryFeeBeforeDis = price9.toDouble();
//                           deliveryFee = price9.toDouble() - (price9.toDouble() * (deliveryDiscount / 100));
//                           totalPrice = (widget.menu.price)! * amount + deliveryFee + (PFee) * amount;
//                           totalPriceHere = totalPrice+serviceFee;
//
//                         }
//                         else if(totalPriceWitoutDFee > 1000.00) {
//                           // deliveryFeeBeforeDis = price9.toDouble();
//                           // deliveryFee = price9.toDouble() - (price9.toDouble() * (deliveryDiscount / 100));
//                           // totalPrice = (widget.menu.price)! * amount + deliveryFee + (PFee) * amount;
//                           // totalPriceHere = totalPrice;
//
//                           return const Padding(
//                             padding: EdgeInsets.all(8.0),
//                             child: Center(
//                               child: Text(
//                                 "Dear customer! You have exceeded our order limit for your current location at this time  "
//                                     "Please update your order or contact us by calling 9857, Thank you",
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.w400,
//                                   fontSize: 12,
//                                   letterSpacing: 0.27,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                             ),
//                           );
//
//                         }
//
//                       }
//
//                       else if (distance > 5 && distance < 5.5) {
//                         totalPriceWitoutDFee =((widget.menu.price)! * amount +  (PFee) * amount);
//                         serviceFee = ((((widget.menu.price)! * amount) + (PFee * amount)) * (dataRest["service_fee"]) / 100);
//
//
//                         if(totalPriceWitoutDFee <=700.00) {
//                           deliveryFeeBeforeDis = price9.toDouble();
//                           deliveryFee = price9.toDouble() - (price9.toDouble() * (deliveryDiscount / 100));
//                           totalPrice = (widget.menu.price)! * amount + deliveryFee + (PFee) * amount;
//                           totalPriceHere =totalPrice+serviceFee;
//
//                         }
//                         else if(totalPriceWitoutDFee >= 701.00 && totalPriceWitoutDFee <=999.00) {
//                           // deliveryFeeBeforeDis = price9.toDouble();
//                           // deliveryFee = price9.toDouble() - (price9.toDouble() * (deliveryDiscount / 100));
//                           // totalPrice = (widget.menu.price)! * amount + deliveryFee + (PFee) * amount;
//                           // totalPriceHere = totalPrice;
//
//                           return const Padding(
//                             padding: EdgeInsets.all(8.0),
//                             child: Center(
//                               child: Text(
//                                 "Dear customer!You have exceeded our order limit for your current location at this time  "
//                                     "Please update your order or contact us by calling 9857, Thank you",
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.w400,
//                                   fontSize: 12,
//                                   letterSpacing: 0.27,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                             ),
//                           );
//
//                         }
//                         else if(totalPriceWitoutDFee > 1000.00) {
//                           // deliveryFeeBeforeDis = price3.toDouble();
//                           // deliveryFee = price3.toDouble() - (price3.toDouble() * (deliveryDiscount / 100));
//                           // totalPrice = (widget.menu.price)! * amount + deliveryFee + (PFee) * amount;
//                           // totalPriceHere = totalPrice;
//
//                           return (const Padding(
//                             padding: EdgeInsets.all(8.0),
//                             child: Center(
//                               child: Text(
//                                 "You have exceeded our order limit for your current distance "
//                                     "Please update your order or contact us by calling 9857, Thank you",
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.w400,
//                                   fontSize: 12,
//                                   letterSpacing: 0.27,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                             ),
//                           ));
//
//                         }
//
//                       }
//
//                       else if (distance > 5.5 && distance < 6) {
//                         // totalPriceWitoutDFee =((widget.menu.price)! * amount +  (PFee) * amount);
//
//                         // if(totalPriceWitoutDFee <500.00) {
//                         //   deliveryFeeBeforeDis = price9.toDouble();
//                         //   deliveryFee = price9.toDouble() - (price1.toDouble() * (deliveryDiscount / 100));
//                         //   totalPrice = (widget.menu.price)! * amount + deliveryFee + (PFee) * amount;
//                         //   totalPriceHere = totalPrice;
//                         //
//                         //
//                         //
//                         // }
//
//                         // else if(totalPriceWitoutDFee > 500.00 && totalPriceWitoutDFee < 100.00) {
//                         //   deliveryFeeBeforeDis = price2.toDouble();
//                         //   deliveryFee = price2.toDouble() - (price2.toDouble() * (deliveryDiscount / 100));
//                         //   totalPrice = (widget.menu.price)! * amount + deliveryFee + (PFee) * amount;
//                         //   totalPriceHere = totalPrice;
//                         //
//                         // }
//                         // else if(totalPriceWitoutDFee > 1000.00) {
//                         //   deliveryFeeBeforeDis = price3.toDouble();
//                         //   deliveryFee = price3.toDouble() - (price3.toDouble() * (deliveryDiscount / 100));
//                         //   totalPrice = (widget.menu.price)! * amount + deliveryFee + (PFee) * amount;
//                         //   totalPriceHere = totalPrice;
//                         //
//                         // }
//                         return const Padding(
//                           padding: EdgeInsets.all(8.0),
//                           child: Center(
//                             child: Text(
//                               "Dear customer, Your current location has exceeded our distance limit for this time "
//                                   "Please choose another restaurant nearby or contact us by calling 9857, Thank you",
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                 fontWeight: FontWeight.w400,
//                                 fontSize: 12,
//                                 letterSpacing: 0.27,
//                                 color: Colors.grey,
//                               ),
//                             ),
//                           ),
//                         );
//
//                       }
//
//                     }
//
//                     if (distance > 6) {
//                       return (const Padding(
//                         padding: EdgeInsets.all(8.0),
//                         child: Center(
//                           child: Text(
//                             "Dear customer, We currently provide deliveries from restaurants in the range of 9kms maximum from, your current location has exceeded that limit,"
//                                 "Please choose another restaurant nearby, Thank you",
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               fontWeight: FontWeight.w400,
//                               fontSize: 12,
//                               letterSpacing: 0.27,
//                               color: Colors.grey,
//                             ),
//                           ),
//                         ),
//                       ));
//                     }
//
//                     if (distance < 6) {
//                       return ((Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Table(
//
//                               // textDirection: TextDirection.rtl,
//                               // defaultVerticalAlignment: TableCellVerticalAlignment.bottom,
//                               // border:TableBorder.all(width: 2.0,color: Colors.red),
//
//                               children: [
//                                 TableRow(children: [
//                                   const Text("Subtotal",
//                                       textScaleFactor: 1,
//                                       textAlign: TextAlign.right),
//                                   Text(
//                                       totalPriceWitoutDFee.toString(),
//                                       textScaleFactor: 1,
//                                       textAlign: TextAlign.right),
//                                 ]),
//                                 // TableRow(children: [
//                                 //   const Text("Packaging fee",
//                                 //       textScaleFactor: 1,
//                                 //       textAlign: TextAlign.right),
//                                 //   Text(
//                                 //       (PFee * amount).toString(),
//                                 //       textScaleFactor: 1,
//                                 //       textAlign: TextAlign.right),
//                                 // ]),
//                                 TableRow(children: [
//                                   const Text("Service charge",
//                                       textScaleFactor: 1,
//                                       textAlign: TextAlign.right),
//                                   Text(
//                                       serviceFee.toString(),
//                                       textScaleFactor: 1,
//                                       textAlign: TextAlign.right),
//                                 ]),
//                                 TableRow(children: [
//                                   const Text("Delivery fee",
//                                       textScaleFactor: 1,
//                                       textAlign: TextAlign.right),
//                                   Text(deliveryFeeBeforeDis.toString(),
//                                       textScaleFactor: 1,
//                                       textAlign: TextAlign.right),
//                                 ]),
//
//                                 if (deliveryDiscount > 0.0) ...[
//                                   TableRow(children: [
//                                     const Text("Delivery discount",
//                                         textScaleFactor: 1,
//                                         textAlign: TextAlign.right),
//                                     Text(deliveryDiscount.toString() + "%",
//                                         textScaleFactor: 1,
//                                         textAlign: TextAlign.right),
//                                   ]),
//                                 ] ,
//                                 TableRow(children: [
//                                   const Text("Amount",
//                                       textScaleFactor: 1,
//                                       textAlign: TextAlign.right),
//                                   Text(NumberToWord().convert('en-in', amount),
//                                       textScaleFactor: 1,
//                                       textAlign: TextAlign.right),
//                                 ]),
//                                 TableRow(children: [
//                                   const Text("Total pay",
//                                       textScaleFactor: 1.5,
//                                       textAlign: TextAlign.right),
//                                   Text("ETB " + totalPriceHere.toString(),
//                                       textScaleFactor: 1.5,
//                                       textAlign: TextAlign.right),
//                                 ]),
//                               ],
//                             ),
//                             const SizedBox(
//                               height: 10,
//                             ),
//                             const Center(
//                               child: Text(
//                                 "We accept payment in cash or by mobile money, for more, Please call 9857. Thanks for choosing PickDelivery",
//                                 textAlign: TextAlign.right,
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.w400,
//                                   fontSize: 14,
//                                   letterSpacing: 0.27,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(
//                               height: 6,
//                             ),
//
//
//
//                             Center(
//                               child: SizedBox(
//                                 width: double.infinity, // <-- match-parent
//                                 child: ElevatedButton(
//                                   style: ButtonStyle(
//                                     backgroundColor:
//                                     MaterialStateProperty.all(Colors.amber),
//                                     shape: MaterialStateProperty.all<
//                                         RoundedRectangleBorder>(
//                                         RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.circular(24.0),
//                                         )),
//                                   ),
//                                   child: const Text(
//                                     'Order with cash on delivery',
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.w800,
//                                       fontSize: 13,
//                                       letterSpacing: 0.27,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                   onPressed: () {
//
//                                     var code = Random().nextInt(900000) + 100000;
//                                     var paymentMethod = 0;
//                                     var paymentStatus = false;
//
//                                     order(
//                                         deliveryDiscount,
//                                         deliveryFeeBeforeDis,
//                                         totalPriceHere,
//                                         amount,
//                                         hereUserLat,
//                                         hereUserLong,
//                                         Restlat,
//                                         Restlong,
//                                         code,
//                                         paymentMethod,
//                                         paymentStatus,
//                                         ).then((value) => Navigator.push<dynamic>(
//                                       context,
//                                       MaterialPageRoute<dynamic>(
//                                         builder: (BuildContext context) =>
//                                             ProfilePage(),
//                                       ),
//                                     ));
//
//                                   },
//                                 ),
//                               ),
//                             ),
//                             Center(
//                               child: SizedBox(
//                                 width: double.infinity, // <-- match-parent
//                                 child: ElevatedButton(
//                                   style: ButtonStyle(
//                                     backgroundColor:
//                                     MaterialStateProperty.all(Colors.green),
//                                     shape: MaterialStateProperty.all<
//                                         RoundedRectangleBorder>(
//                                         RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.circular(24.0),
//                                         )),
//                                   ),
//                                   child: const Text(
//                                     'Order with online payment',
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.w800,
//                                       fontSize: 13,
//                                       letterSpacing: 0.27,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                   onPressed: () {
//
//                                     var code = Random().nextInt(900000) + 100000;
//                                     var paymentMethod = 1;
//                                     var paymentStatus = false;
//
//                                     order(
//                                       deliveryDiscount,
//                                       deliveryFeeBeforeDis,
//                                       totalPriceHere,
//                                       amount,
//                                       hereUserLat,
//                                       hereUserLong,
//                                       Restlat,
//                                       Restlong,
//                                       code,
//                                       paymentMethod,
//                                       paymentStatus,
//                                     ).then((value) => Chapa.paymentParameters(
//                                           context: context, // context
//                                           publicKey: 'CHASECK_TEST-MA6WcNyDtNPAaxZNtm1ECMrFfzw5U316',
//                                           currency: 'etb',
//                                           amount: '300',
//                                           email: 'xyz@gmail.com',
//                                           firstName: 'testname',
//                                           lastName: 'lastName',
//                                           txRef: code.toString(),
//                                           title: 'title',
//                                           desc:'desc',
//                                           namedRouteFallBack: '/checkOutOnlinePayment', // fall back route name
//                                         ));
//
//                                   },
//                                 ),
//                               ),
//                             )
//                           ],
//                         ),
//                       )));
//                     }
//
//                     return (SizedBox.fromSize());
//                   }
//               }
//             },
//           );
//         }
//
//
//         return SizedBox.fromSize();
//       }
//
//   );
//
//   //
//   // Future<void> getRestPosition() async {
//   //   Map<String, dynamic> locationdata =
//   //       widget.restDoc['location'] as Map<String, dynamic>;
//   //
//   //   Position position = await _determinePosition();
//   //
//   //   double Restlat = locationdata['geopoint'].latitude;
//   //   double Restlong = locationdata['geopoint'].longitude;
//   //
//   //   geo = Geoflutterfire();
//   //   var hereUserLat = position.latitude;
//   //   var hereUserLong = position.longitude;
//   //
//   //   var myLocationPoint =
//   //       geo.point(latitude: hereUserLat, longitude: hereUserLong);
//   //
//   //   var distance = myLocationPoint.distance(lat: Restlat, lng: Restlong);
//   //
//   //   totalDistance = distance;
//   // }
//
//   Future<Position> _determinePosition() async {
//     bool serviceEnabled;
//     LocationPermission permission;
//
//     // Test if location services are enabled.
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       // Location services are not enabled don't continue
//       // accessing the position and request users of the
//       // App to enable the location services.
//       return Future.error('locaDis'.tr());
//     }
//
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         // Permissions are denied, next time you could try
//         // requesting permissions again (this is also where
//         // Android's shouldShowRequestPermissionRationale
//         // returned true. According to Android guidelines
//         // your App should show an explanatory UI now.
//         return Future.error('locaPermDen'.tr());
//       }
//     }
//
//     if (permission == LocationPermission.deniedForever) {
//       // Permissions are denied forever, handle appropriately.
//       return Future.error('locaPermntDen'.tr());
//     }
//
//     // When we reach here, permissions are granted and we can
//     // continue accessing the position of the device.
//     return await Geolocator.getCurrentPosition(
//       //forceAndroidLocationManager: true,
//         desiredAccuracy: LocationAccuracy.high
//     );
//   }
//
//   Future<Position> getPosition() async {
//     Position position = await _determinePosition();
//
//     return position;
//   }
//   //
//
//   dialogForCoupon(
//       BuildContext context,
//       String couponCode,
//       String displayText,
//       String nameOfCoupon,
//       var discountByPercent,
//       ) {
//     // set up the buttons
//     Widget thanksButton = ElevatedButton(
//       style: ButtonStyle(
//         backgroundColor: MaterialStateProperty.all(Colors.amber),
//         shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//             RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(35.0),
//             )),
//       ),
//       child: Text(
//         'Thanks',
//         style: TextStyle(
//           fontWeight: FontWeight.w800,
//           fontSize: 13,
//           letterSpacing: 0.27,
//           color: Colors.white,
//         ),
//       ),
//       onPressed: () {
//         Navigator.of(context, rootNavigator: true).pop();
//       },
//     );
//     // set up the AlertDialog
//     AlertDialog alert = AlertDialog(
//       title: Icon(
//         Icons.local_offer,
//         color: Colors.amber,
//         size: 34.0,
//       ),
//       content: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Text(
//           nameOfCoupon +
//               "\n \n We have offered you a" +
//               discountByPercent +
//               "% delivery discount. Enjoy! ",
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontWeight: FontWeight.w600,
//             fontSize: 16,
//             letterSpacing: 0.27,
//             color: DesignCourseAppTheme.darkerText,
//           ),
//         ),
//       ),
//       actions: [
//         thanksButton,
//       ],
//     );
//     // show the dialog
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return alert;
//       },
//     );
//   }
//
//   dialogForCouponWrong(
//       BuildContext context,
//       ) {
//     // set up the buttons
//     Widget thanksButton = ElevatedButton(
//       style: ButtonStyle(
//         backgroundColor: MaterialStateProperty.all(Colors.amber),
//         shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//             RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(35.0),
//             )),
//       ),
//       child: const Text(
//         'Okay',
//         style: TextStyle(
//           fontWeight: FontWeight.w800,
//           fontSize: 13,
//           letterSpacing: 0.27,
//           color: Colors.white,
//         ),
//       ),
//       onPressed: () {
//         Navigator.of(context, rootNavigator: true).pop();
//       },
//     );
//     // set up the AlertDialog
//     AlertDialog alert = AlertDialog(
//       title: const Text(
//         "Wrong coupon",
//         textAlign: TextAlign.center,
//         style: TextStyle(
//           fontWeight: FontWeight.w600,
//           fontSize: 16,
//           letterSpacing: 0.27,
//           color: DesignCourseAppTheme.darkerText,
//         ),
//       ),
//       content: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Text(
//           "Please enter the coupon correctly",
//           textAlign: TextAlign.center,
//         ),
//       ),
//       actions: [
//         thanksButton,
//       ],
//     );
//     // show the dialog
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return alert;
//       },
//     );
//   }
//
//   showAlertDialogForSuccess(BuildContext context) {
//     // set up the buttons
//     Widget trackButton = ElevatedButton.icon(
//       style: ButtonStyle(
//         backgroundColor: MaterialStateProperty.all(Colors.amber),
//         shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//             RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(35.0),
//             )),
//       ),
//       icon: const Icon(
//         Icons.check_box_outlined,
//         color: Colors.white,
//         size: 18.0,
//       ),
//       label: const Text(
//         'Ok,Thanks!',
//         style: TextStyle(
//           fontWeight: FontWeight.w800,
//           fontSize: 13,
//           letterSpacing: 0.27,
//           color: Colors.white,
//         ),
//       ),
//       onPressed: () {
//
//         Navigator.of(context, rootNavigator: true).pop();
//
//       },
//     );
//
//     // set up the AlertDialog
//     AlertDialog alert = AlertDialog(
//       title: const Text(
//         "Your order has been created successfully",
//         textAlign: TextAlign.center,
//         style: TextStyle(
//           fontWeight: FontWeight.w600,
//           fontSize: 16,
//           letterSpacing: 0.27,
//           color: DesignCourseAppTheme.darkerText,
//         ),
//       ),
//       content: const SizedBox(
//         width: 190,
//         child: Text(
//           "You can track order every step of the way.",
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontWeight: FontWeight.w200,
//             fontSize: 16,
//             letterSpacing: 0.27,
//             color: DesignCourseAppTheme.darkerText,
//           ),
//         ),
//       ),
//       actions: [
//         trackButton,
//       ],
//     );
//     // show the dialog
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return alert;
//       },
//     );
//   }
//   final DateTime _now = DateTime.now();
//
//
//   Future<void> order(
//       double deliveryDiscountFinal,
//       deliveryFeeBeforeDis,
//       double totalPriceFinal,
//       amount,
//       double hereUserLat,
//       double hereUserLong,
//       double Restlat,
//       double Restlong,
//       int code,
//       int paymentMethod,
//       bool paymentStatus,
//
//       ) {
//     // Call the user's CollectionReference to add a new user
//     return orders
//         .add({
//       'order_num': code,
//       'cuisine_id': widget.menuID, // John Doe
//       'user_id': userid , // Stokes and Sons
//       'rest_id': widget.menu.rest_id,
//       'confirm': 0,
//       'paymentMethod': paymentMethod,
//       'paymentStatus': paymentStatus,
//       'created': _now,
//       'delivery_discount': deliveryDiscountFinal,
//       'delivery_fee':deliveryFeeBeforeDis,
//       'total_price': totalPriceFinal,
//       'amount': amount,
//       'client_loc': "http://maps.google.com/maps?q=loc:" +
//           hereUserLat.toString() +
//           "," +
//           hereUserLong.toString(),
//       'rest_loc': "http://maps.google.com/maps?q=loc:" +
//           Restlat.toString() +
//           "," +
//           Restlong.toString(),
//
//       // 42
//     });
//   }
//
//   // Future<void> _updatePaymentStatus(int code) async {
//   //   QuerySnapshot snapshot = await orders
//   //       .where('order_num', isEqualTo: code).get();
//   //
//   //   if (snapshot.docs.isNotEmpty) {
//   //     for (var doc in snapshot.docs) {
//   //       doc.reference.update({"payment_status": true,}).then((value) =>
//   //           print(doc.id))
//   //           .catchError((error) => print('Failed: $error'));
//   //     }
//   //
//   //   }
//   // }
//
//
//   getStorageUrlStringProfilePic(String cuisineDoc) async {
//     String downloadURL = await firebase_storage.FirebaseStorage.instance
//         .ref()
//         .child(cuisineDoc)
//         .getDownloadURL();
//     return downloadURL;
//   }
//   //
//   // getStorageUrlStringRestCoverPic() async {
//   //   String downloadURL = await firebase_storage.FirebaseStorage.instance
//   //       .ref()
//   //       .child(widget.restDoc["photo_url"])
//   //       .getDownloadURL();
//   //   return downloadURL;
//   // }
//
//
// //checks if restaurant is open or closed
// // returns true if current time is in between given timestamps
// //openTime HH:MMAM or HH:MMPM same for closedTime
//   bool checkRestaurentStatus(String openTime, String closedTime) {
//     //NOTE: Time should be as given format only
//     //10:00PM
//     //10:00AM
//
//     // 01:60PM ->13:60
//     //Hrs:Min
//     //if AM then its ok but if PM then? 12+time (12+10=22)
//
//     TimeOfDay timeNow = TimeOfDay.now();
//     String openHr = openTime.substring(0, 2);
//     String openMin = openTime.substring(3, 5);
//     String openAmPm = openTime.substring(5);
//     TimeOfDay timeOpen;
//     if (openAmPm == "AM") {
//       //am case
//       if (openHr == "12") {
//         //if 12AM then time is 00
//         timeOpen = TimeOfDay(hour: 00, minute: int.parse(openMin));
//       } else {
//         timeOpen =
//             TimeOfDay(hour: int.parse(openHr), minute: int.parse(openMin));
//       }
//     } else {
//       //pm case
//       if (openHr == "12") {
// //if 12PM means as it is
//         timeOpen =
//             TimeOfDay(hour: int.parse(openHr), minute: int.parse(openMin));
//       } else {
// //add +12 to conv time to 24hr format
//         timeOpen =
//             TimeOfDay(hour: int.parse(openHr) + 12, minute: int.parse(openMin));
//       }
//     }
//
//     String closeHr = closedTime.substring(0, 2);
//     String closeMin = closedTime.substring(3, 5);
//     String closeAmPm = closedTime.substring(5);
//
//     TimeOfDay timeClose;
//
//     if (closeAmPm == "AM") {
//       //am case
//       if (closeHr == "12") {
//         timeClose = TimeOfDay(hour: 0, minute: int.parse(closeMin));
//       } else {
//         timeClose =
//             TimeOfDay(hour: int.parse(closeHr), minute: int.parse(closeMin));
//       }
//     } else {
//       //pm case
//       if (closeHr == "12") {
//         timeClose =
//             TimeOfDay(hour: int.parse(closeHr), minute: int.parse(closeMin));
//       } else {
//         timeClose = TimeOfDay(
//             hour: int.parse(closeHr) + 12, minute: int.parse(closeMin));
//       }
//     }
//
//     int nowInMinutes = timeNow.hour * 60 + timeNow.minute;
//     int openTimeInMinutes = timeOpen.hour * 60 + timeOpen.minute;
//     int closeTimeInMinutes = timeClose.hour * 60 + timeClose.minute;
//
// //handling day change ie pm to am
//     if ((closeTimeInMinutes - openTimeInMinutes) < 0) {
//       closeTimeInMinutes = closeTimeInMinutes + 1440;
//       if (nowInMinutes >= 0 && nowInMinutes < openTimeInMinutes) {
//         nowInMinutes = nowInMinutes + 1440;
//       }
//       if (openTimeInMinutes < nowInMinutes &&
//           nowInMinutes < closeTimeInMinutes) {
//         return true;
//       }
//     } else if (openTimeInMinutes < nowInMinutes &&
//         nowInMinutes < closeTimeInMinutes) {
//       return true;
//     }
//
//     return false;
//
//   }
// }
