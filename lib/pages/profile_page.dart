import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pick_delivery_adama_biker/app_extended.dart';
import '/widget/profile_widget.dart';
import '../app_theme.dart';
import '../home_for_orders.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}
class _ProfilePageState extends State<ProfilePage> {
  var users = FirebaseFirestore.instance.collection('biker');
  var orders = FirebaseFirestore.instance.collection('restaurant');

  var userid = FirebaseAuth.instance.currentUser!.uid;

  Geolocator geolocator = Geolocator();

  final geo = Geoflutterfire();

  Position? _currentPosition;
  String img = "";
  int isSwitched = 0;
  var args;

  @override
  void initState() {

    // Future.delayed(Duration.zero,(){
    //
    //   if(ModalRoute.of(context)?.settings.arguments!= null)
    //   {
    //     args=ModalRoute.of(context)?.settings.arguments;
    //
    //     QuerySnapshot snapshot = await orders
    //         .where('order_num', isEqualTo: code).get();
    //
    //     if (snapshot.docs.isNotEmpty) {
    //       for (var doc in snapshot.docs) {
    //         doc.reference.update({"payment_status": true,}).then((value) =>
    //             print(doc.id))
    //             .catchError((error) => print('Failed: $error'));
    //       }
    //
    //     }
    //
    //
    //     if (kDebugMode) {
    //       if (kDebugMode) {
    //         print('message after payment');
    //       }
    //     }
    //     if (kDebugMode) {
    //       print(args['message']);
    //       print(args['txRef']);
    //
    //     }
    //
    //   }
    //
    //   // setState(() {
    //   //   if(ModalRoute.of(context)?.settings.arguments!= null)
    //   //   {
    //   //     args=ModalRoute.of(context)?.settings.arguments;
    //   //
    //   //     Future<void> _updatePaymentStatus(int code) async {
    //   //       QuerySnapshot snapshot = await orders
    //   //           .where('order_num', isEqualTo: code).get();
    //   //
    //   //       if (snapshot.docs.isNotEmpty) {
    //   //         for (var doc in snapshot.docs) {
    //   //           doc.reference.update({"payment_status": true,}).then((value) =>
    //   //               print(doc.id))
    //   //               .catchError((error) => print('Failed: $error'));
    //   //         }
    //   //
    //   //
    //   //         // orders
    //   //         //     .where('order_num', isEqualTo: 470590)
    //   //         //     .get()
    //   //         //     .then(
    //   //         //       (value) => value.docs.map(
    //   //         //         (element) {
    //   //         //        var docRef = orders.doc(element.id);
    //   //         //       docRef.update({'paymentStatus': true})
    //   //         //           .then((value) => print("UPDATED "))
    //   //         //           .catchError((error) => print('Failed: $error'));
    //   //         //     },
    //   //         //   ),
    //   //         // );
    //   //         // var collection = FirebaseFirestore.instance.collection('collection');
    //   //         // orders
    //   //         //     .doc('04WGjkbSzBx07BqUrLPc')
    //   //         //     .update({'delivery_fee' : 60}) // <-- Updated data
    //   //         //     .then((_) => print('Success'))
    //   //         //     .catchError((error) => print('Failed: $error'));
    //   //
    //   //       }
    //   //     }
    //   //
    //   //
    //   //     if (kDebugMode) {
    //   //       if (kDebugMode) {
    //   //         print('message after payment');
    //   //       }
    //   //     }
    //   //     if (kDebugMode) {
    //   //       print(args['message']);
    //   //       print(args['txRef']);
    //   //
    //   //
    //   //
    //   //
    //   //
    //   //
    //   //     }
    //   //
    //   //   }
    //   // });
    //
    // });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          ProfileWidget(
            //  imagePath:getStorageUrlString().toString(),
            userid: userid,
            isEdit: false,
            onClicked: () {
              // Navigator.of(context).push(
              //   MaterialPageRoute(builder: (context) => EditProfilePage()),
              // );
            },
          ),
          Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 18, bottom: 18),
            child: SizedBox(
              width: AppBar().preferredSize.height,
              height: AppBar().preferredSize.height,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius:
                      BorderRadius.circular(AppBar().preferredSize.height),
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: DesignCourseAppTheme.nearlyBlack,
                  ),
                  onTap: () {
                    Navigator.of(this.context).push(MaterialPageRoute(
                        builder: (context) => const AppExtended()));
                  },
                ),
              ),
            ),
          ),

          // Padding(
          //   padding: EdgeInsets.only(
          //     left: 55,right: 5,
          //     top: (MediaQuery.of(context).size.height / 3.1) ,
          //   ),
          //
          //   child:SingleChildScrollView(
          //     scrollDirection:Axis.horizontal,
          //     child:Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //       crossAxisAlignment: CrossAxisAlignment.stretch,
          //       children:  [
          //
          //         Column(
          //           children: [
          //             Text(
          //               "This month",
          //               style: TextStyle(
          //                 fontWeight: FontWeight.w500,
          //                 fontSize: 13,
          //                 letterSpacing: 0.27,
          //                 color: DesignCourseAppTheme.nearlyBlack,
          //               ),
          //             ),
          //             Text(
          //               "30ETB",
          //               style: TextStyle(
          //                 fontWeight: FontWeight.w500,
          //                 fontSize: 13,
          //                 letterSpacing: 0.27,
          //                 color: DesignCourseAppTheme.mainLogoColor,
          //               ),
          //             )
          //           ],
          //         ),
          //     SizedBox(
          //       width: 7,
          //     ),
          //     Column(
          //       children: [
          //         Text(
          //           "This month",
          //           style: TextStyle(
          //             fontWeight: FontWeight.w500,
          //             fontSize: 13,
          //             letterSpacing: 0.27,
          //             color: DesignCourseAppTheme.nearlyBlack,
          //           ),
          //         ),
          //         Text(
          //           "30ETB",
          //           style: TextStyle(
          //             fontWeight: FontWeight.w500,
          //             fontSize: 13,
          //             letterSpacing: 0.27,
          //             color: DesignCourseAppTheme.mainLogoColor,
          //           ),
          //         )
          //       ],
          //     ),
          //         SizedBox(
          //           width: 7,
          //         ),
          //     Column(
          //       children: [
          //         Text(
          //           "This month",
          //           style: TextStyle(
          //             fontWeight: FontWeight.w500,
          //             fontSize: 13,
          //             letterSpacing: 0.27,
          //             color: DesignCourseAppTheme.nearlyBlack,
          //           ),
          //         ),
          //         Text(
          //           "30ETB",
          //           style: TextStyle(
          //             fontWeight: FontWeight.w500,
          //             fontSize: 13,
          //             letterSpacing: 0.27,
          //             color: DesignCourseAppTheme.mainLogoColor,
          //           ),
          //         )
          //       ],
          //     ),
          //
          //
          //
          //
          //
          //       ],
          //     ),
          //   ),
          //
          //
          // ),

          Padding(
            padding: EdgeInsets.only(
              left: 13,right: 3,
              top: (MediaQuery.of(context).size.height / 3.1) ,
            ),
            child: const Text(
              "Orders that you have delivered",
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 16,
                letterSpacing: 0.27,
                color: DesignCourseAppTheme.delivery,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: 3,right: 3,
                top: (MediaQuery.of(context).size.height / 2.65)),
            //child: ActiveOrdersStream(),
            child: const HomeForOrders(),
          ),

         ],
      ),
    );
  }

  // Widget ActiveOrdersStream() => StreamBuilder<QuerySnapshot>(
  //     stream: FirebaseFirestore.instance
  //         .collection('order')
  //         // .where('user_id', isEqualTo: userid)
  //         // .where('confirm', isNotEqualTo: 4)
  //         .snapshots(),
  //     builder: (BuildContext context, snapshot) {
  //       if (snapshot.hasError) {
  //         print(snapshot.error.toString());
  //       } else if (snapshot.connectionState == ConnectionState.waiting) {
  //         return Center(
  //           child: Padding(
  //             padding: EdgeInsets.all(40),
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Container(
  //                   alignment: Alignment.center,
  //                   child: CircularProgressIndicator(color: Colors.amber,),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       } else if (snapshot.connectionState == ConnectionState.done && !snapshot.hasData) {
  //
  //         return Center(
  //           child: Padding(
  //             padding: EdgeInsets.all(40),
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Container(
  //                   alignment: Alignment.center,
  //                   child:  const Text("You have not made any orders yet"),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       }
  //       else if (snapshot.connectionState == ConnectionState.done && snapshot.hasData){
  //         ListView(
  //           children: snapshot.data!.docs.map((DocumentSnapshot document) {
  //             Map<String, dynamic> data =
  //             document.data()! as Map<String, dynamic>;
  //             return Padding(
  //               padding: EdgeInsets.only(left: 13, right: 13, bottom: 13, top: 2),
  //               child: Row(
  //                 children: <Widget>[
  //                   buildOrdersCuisine(data["cuisine_id"],document.id),
  //                 ],
  //               ),
  //             );
  //           }).toList(),
  //         );
  //       }
  //
  //         return ListView(
  //           children: snapshot.data!.docs.map((DocumentSnapshot document) {
  //             Map<String, dynamic> data =
  //             document.data()! as Map<String, dynamic>;
  //             return Padding(
  //               padding: EdgeInsets.only(left: 13, right: 13, bottom: 13, top: 2),
  //               child: Row(
  //                 children: <Widget>[
  //                   buildOrdersCuisine(data["cuisine_id"],document.id),
  //                 ],
  //               ),
  //             );
  //           }).toList(),
  //         );
  //
  //     });
  //
  // Widget buildOrdersCuisine(String cuisineID, String OrderId) => FutureBuilder<DocumentSnapshot>(
  //       future:
  //           FirebaseFirestore.instance.collection('cuisine').doc(cuisineID).get(),
  //       builder:
  //           (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
  //         if (snapshot.hasData) {
  //           Map<String, dynamic> data =
  //               snapshot.data!.data() as Map<String, dynamic>;
  //
  //           return Row(
  //             children: <Widget>[
  //               Container(
  //                 width: MediaQuery.of(context).size.width/1.1,
  //                 decoration: BoxDecoration(
  //                   color: DesignCourseAppTheme.nearlyWhite,
  //                   borderRadius: const BorderRadius.only(
  //                     bottomLeft: Radius.circular(25.0),
  //                     bottomRight: Radius.circular(25.0),
  //                     topLeft: Radius.circular(25.0),
  //                     topRight: Radius.circular(25.0),
  //                   ),
  //                   boxShadow: <BoxShadow>[
  //                     BoxShadow(
  //                         color: DesignCourseAppTheme.grey.withOpacity(0.2),
  //                         offset: const Offset(1.1, 1.1),
  //                         blurRadius: 8.0),
  //                   ],
  //                 ),
  //                 child: Column(
  //                   children: [
  //                     SizedBox(
  //                       height: 4,
  //                     ),
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                       children: [
  //                         SizedBox(
  //                           width: 3,
  //                         ),
  //                         SizedBox(
  //                           width: 140,
  //                           child: Text(
  //                             '${data['cuisine_name']}',
  //                             textAlign: TextAlign.left,
  //                             style: const TextStyle(
  //                               fontWeight: FontWeight.w600,
  //                               fontSize: 16,
  //                               letterSpacing: 0.27,
  //                               color: DesignCourseAppTheme.darkerText,
  //                             ),
  //                           ),
  //                         ),
  //
  //
  //
  //                         buildOrderStatus(OrderId),
  //
  //                         const SizedBox(
  //                           width: 3,
  //                         ),
  //                       ],
  //                     ),
  //
  //                     Row(
  //                       children: <Widget>[
  //                         Padding(
  //                           padding: const EdgeInsets.only(
  //                             left: 6,
  //                             right: 2,
  //                             bottom: 13,
  //                           ),
  //                           child: ClipOval(
  //                             child: SizedBox.fromSize(
  //                               size: Size.fromRadius(48), // Image radius
  //                               child: FutureBuilder(
  //                                 future: getStorageUrlStringProfilePic(data['photo_url']),
  //                                 builder: (context, snapshot) {
  //                                   if (snapshot.hasError) {
  //                                     return const Text(
  //                                       "Something went wrong",
  //                                     );
  //                                   }
  //                                   if (snapshot.connectionState ==
  //                                       ConnectionState.done) {
  //                                     return Image.network(
  //                                         snapshot.data.toString(),
  //                                         height: 150,
  //                                         width: 150,
  //                                         fit: BoxFit.cover);
  //                                   }
  //                                   return const Center(
  //                                       child: CircularProgressIndicator(color: Colors.amber,));
  //                                 },
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //
  //                         buildOrderStatusDescri(OrderId)
  //
  //                       ],
  //                     ),
  //                     Row(
  //                      // crossAxisAlignment: CrossAxisAlignment.end,
  //                         mainAxisAlignment:MainAxisAlignment.end,
  //                       children:[
  //                         buildAmount(OrderId),
  //                         buildTotalPay(OrderId),
  //                         buildOrderNumber(OrderId),
  //                         SizedBox(
  //                           width: 4,
  //                         ),
  //                       ]
  //                     )
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           );
  //         }
  //         return SizedBox.fromSize();
  //       },
  //     );

  // Widget buildOrderStatus(String orderId) => FutureBuilder<DocumentSnapshot>(
  //       future:FirebaseFirestore.instance.collection('order').doc(orderId).get(),
  //       builder:
  //           (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
  //         if (snapshot.hasData) {
  //           Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
  //
  //
  //           if ((data['confirm']).toString() == '0') {
  //             return Chip(
  //               avatar: CircleAvatar(
  //                   backgroundColor: DesignCourseAppTheme.delivery,
  //                   child: const Icon(
  //                     Icons.play_for_work_rounded,
  //                     color: Colors.amber,
  //                     size: 20.0,
  //                   )),
  //               label:  Text('In process'),
  //
  //             );
  //           }
  //           else if ((data['confirm']).toString() == '1') {
  //             return Chip(
  //             avatar: CircleAvatar(
  //                   backgroundColor: DesignCourseAppTheme.delivery,
  //                   child: const Icon(
  //                     Icons.food_bank_outlined,
  //                     color: Colors.amber,
  //                     size: 20.0,
  //                   )),
  //               label: const Text('Preparing'),
  //             );
  //           }
  //           else if ((data['confirm']).toString() == '2') {
  //
  //           return Chip(
  //             avatar: CircleAvatar(
  //                 backgroundColor: DesignCourseAppTheme.delivery,
  //                 child: const Icon(
  //                   Icons.directions_bike,
  //                   color: Colors.amber,
  //                   size: 20.0,
  //                 )),
  //             label: const Text(
  //               'On the way',
  //               style:  TextStyle(
  //               fontWeight: FontWeight.w600,
  //               fontSize: 16,
  //               letterSpacing: 0.27,
  //               color: DesignCourseAppTheme.darkerText,
  //             ),),
  //           );
  //         }
  //           else if ((data['confirm']).toString() == '3') {
  //           return Chip(
  //             avatar: CircleAvatar(
  //                 backgroundColor: DesignCourseAppTheme.delivery,
  //                 child: Icon(
  //                   Icons.check,
  //                   color: Colors.amber,
  //                   size: 20.0,
  //                 )),
  //             label: const Text('Delivered'),
  //           );
  //         }
  //
  //
  //           // else if ((data['confirm']).toString() == '4') {
  //           //   return Chip(
  //           //     avatar: CircleAvatar(
  //           //         backgroundColor: DesignCourseAppTheme.delivery,
  //           //         child: Icon(
  //           //           Icons.block,
  //           //           color: Colors.amber,
  //           //           size: 20.0,
  //           //         )),
  //           //     label: const Text('Not available'),
  //           //   );
  //           // }
  //         }
  //
  //         return SizedBox.fromSize();
  //       },
  //     );
  //
  // Widget buildOrderNumber(String orderId) => FutureBuilder<DocumentSnapshot>(
  //   future:FirebaseFirestore.instance.collection('order').doc(orderId).get(),
  //   builder:
  //       (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
  //     if (snapshot.hasData) {
  //       Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
  //
  //
  //       return Chip(
  //         backgroundColor: Colors.white,
  //         avatar: CircleAvatar(
  //             backgroundColor:Colors.grey,
  //             child: Icon(
  //               Icons.confirmation_num,
  //               color: Colors.white,
  //               size: 16.0,
  //             )),
  //         label: Text(data['order_num'].toString(),
  //           style: TextStyle(color: Colors.grey),
  //         ),
  //       );
  //
  //       // else if ((data['confirm']).toString() == '4') {
  //       //   return Chip(
  //       //     avatar: CircleAvatar(
  //       //         backgroundColor: DesignCourseAppTheme.delivery,
  //       //         child: Icon(
  //       //           Icons.block,
  //       //           color: Colors.amber,
  //       //           size: 20.0,
  //       //         )),
  //       //     label: const Text('Not available'),
  //       //   );
  //       // }
  //     }
  //
  //     return SizedBox.fromSize();
  //   },
  // );
  //
  // Widget buildTotalPay(String orderId) => FutureBuilder<DocumentSnapshot>(
  //   future:FirebaseFirestore.instance.collection('order').doc(orderId).get(),
  //   builder:
  //       (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
  //     if (snapshot.hasData) {
  //       Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
  //
  //
  //       return Chip(
  //         backgroundColor: Colors.white,
  //         avatar: CircleAvatar(
  //             backgroundColor:Colors.grey,
  //             child: Icon(
  //               Icons.payments_outlined,
  //               color: Colors.white,
  //               size: 16.0,
  //             )),
  //         label: Text("ETB "+data['total_price'].toString(),
  //           style: TextStyle(color: Colors.grey),
  //         ),
  //       );
  //
  //       // else if ((data['confirm']).toString() == '4') {
  //       //   return Chip(
  //       //     avatar: CircleAvatar(
  //       //         backgroundColor: DesignCourseAppTheme.delivery,
  //       //         child: Icon(
  //       //           Icons.block,
  //       //           color: Colors.amber,
  //       //           size: 20.0,
  //       //         )),
  //       //     label: const Text('Not available'),
  //       //   );
  //       // }
  //     }
  //
  //     return SizedBox.fromSize();
  //   },
  // );
  //
  // Widget buildAmount(String orderId) => FutureBuilder<DocumentSnapshot>(
  //   future:FirebaseFirestore.instance.collection('order').doc(orderId).get(),
  //   builder:
  //       (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
  //     if (snapshot.hasData) {
  //       Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
  //
  //
  //       return Chip(
  //         backgroundColor: Colors.white,
  //         avatar: CircleAvatar(
  //             backgroundColor:Colors.grey,
  //             child: Icon(
  //               Icons.food_bank,
  //               color: Colors.white,
  //               size: 16.0,
  //             )),
  //         label: Text(NumberToWord().convert('en-in',data['amount']),
  //           style: TextStyle(color: Colors.grey),
  //         ),
  //       );
  //
  //
  //     }
  //
  //     return SizedBox.fromSize();
  //   },
  // );
  //
  // Widget buildOrderStatusDescri(String orderId) => FutureBuilder<DocumentSnapshot>(
  //   future:FirebaseFirestore.instance.collection('order').doc(orderId).get(),
  //   builder:
  //       (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
  //     if (snapshot.hasData) {
  //       Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
  //
  //       if ((data['confirm']).toString() == '0') {
  //         return  Column(
  //           children: <Widget>[
  //             Padding(
  //               padding: EdgeInsets.only(
  //                 left: 4,
  //                 right: 13,
  //                 bottom: 20,
  //               ),
  //               child: Column(
  //                 children: const [
  //                   SizedBox(
  //                     height: 13,
  //                   ),
  //                   SizedBox(
  //                     width: 190,
  //                     child: Text(
  //                       'We are processing your order, we will let you know the status momentarily',
  //                       textAlign: TextAlign.center,
  //                       style: TextStyle(
  //                         fontWeight: FontWeight.w200,
  //                         fontSize: 16,
  //                         letterSpacing: 0.27,
  //                         color:
  //                         DesignCourseAppTheme.darkerText,
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         );
  //       }
  //       else if ((data['confirm']).toString() == '1') {
  //         return  Column(
  //           children: <Widget>[
  //             Padding(
  //               padding: EdgeInsets.only(
  //                 left: 4,
  //                 right: 13,
  //                 bottom: 20,
  //               ),
  //               child: Column(
  //                 children: const [
  //                   SizedBox(
  //                     height: 13,
  //                   ),
  //                   SizedBox(
  //                     width: 190,
  //                     child: Text(
  //                       'Your ordered food in now being prepared.',
  //                       textAlign: TextAlign.center,
  //                       style: TextStyle(
  //                         fontWeight: FontWeight.w200,
  //                         fontSize: 16,
  //                         letterSpacing: 0.27,
  //                         color:
  //                         DesignCourseAppTheme.darkerText,
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         );
  //       }
  //       else if ((data['confirm']).toString() == '2') {
  //         return  Column(
  //           children: <Widget>[
  //             Padding(
  //               padding: EdgeInsets.only(
  //                 left: 4,
  //                 right: 13,
  //                 bottom: 20,
  //               ),
  //               child: Column(
  //                 children: const [
  //                   SizedBox(
  //                     height: 13,
  //                   ),
  //                   SizedBox(
  //                     width: 190,
  //                     child: Text(
  //                       'Your ordered food is now on the way.',
  //                       textAlign: TextAlign.center,
  //                       style: TextStyle(
  //                         fontWeight: FontWeight.w200,
  //                         fontSize: 16,
  //                         letterSpacing: 0.27,
  //                         color:
  //                         DesignCourseAppTheme.darkerText,
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         );
  //       }
  //       else if ((data['confirm']).toString() == '3') {
  //         return  Column(
  //           children: <Widget>[
  //             Padding(
  //               padding: EdgeInsets.only(
  //                 left: 4,
  //                 right: 13,
  //                 bottom: 20,
  //               ),
  //               child: Column(
  //                 children: const [
  //                   SizedBox(
  //                     height: 13,
  //                   ),
  //                   SizedBox(
  //                     width: 190,
  //                     child: Text(
  //                       'Your ordered food has been delivered to you successfully, enjoy! ',
  //                       textAlign: TextAlign.center,
  //                       style: TextStyle(
  //                         fontWeight: FontWeight.w200,
  //                         fontSize: 16,
  //                         letterSpacing: 0.27,
  //                         color:
  //                         DesignCourseAppTheme.darkerText,
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         );
  //       }
  //       // else if ((data['confirm']).toString() == '4') {
  //       //   return  Column(
  //       //     children: <Widget>[
  //       //       Padding(
  //       //         padding: EdgeInsets.only(
  //       //           left: 4,
  //       //           right: 13,
  //       //           bottom: 20,
  //       //         ),
  //       //         child: Column(
  //       //           children: const [
  //       //             SizedBox(
  //       //               height: 13,
  //       //             ),
  //       //             SizedBox(
  //       //               width: 190,
  //       //               child: Text(
  //       //                 'This ordered food is currently not available.',
  //       //                 textAlign: TextAlign.center,
  //       //                 style: TextStyle(
  //       //                   fontWeight: FontWeight.w200,
  //       //                   fontSize: 16,
  //       //                   letterSpacing: 0.27,
  //       //                   color:
  //       //                   DesignCourseAppTheme.darkerText,
  //       //                 ),
  //       //               ),
  //       //             ),
  //       //           ],
  //       //         ),
  //       //       ),
  //       //     ],
  //       //   );
  //       // }
  //     }
  //
  //     return SizedBox.fromSize();
  //   },
  // );
  //
  //
  //
  //
  // getStorageUrlStringProfilePic(String photoURL) async {
  //   String downloadURL = await firebase_storage.FirebaseStorage.instance
  //       .ref()
  //       .child(photoURL)
  //       .getDownloadURL();
  //   return downloadURL;
  // }
  //

  Future<void> getStorageUrl() async {
    String downloadURL = await firebase_storage.FirebaseStorage.instance
        .ref('profile-pics/' + userid)
        .getDownloadURL();

    setState(() {
      img = downloadURL;
    });
  }

  Future<String> getStorageUrlString(String Url) async {
    String downloadURL = await firebase_storage.FirebaseStorage.instance
        .ref('profile-pics/' + userid)
        .getDownloadURL();
    return downloadURL;
  }

}
