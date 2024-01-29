import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:number_to_words/number_to_words.dart';

//import '../model/restaurant.dart';
import '../app_theme.dart';
import '../model/order.dart';

class OrderCard extends StatelessWidget {
   const OrderCard({
    required this.order,
  });

  final Order order;



  @override
  Widget build(BuildContext context) {

    String? deliveryDuration = order.deliveryDuration;
    String formattedDeliveryDuration;

    if (deliveryDuration != null) {
      formattedDeliveryDuration = deliveryDuration;
    } else {
      formattedDeliveryDuration = "null";
    }

    return Padding(
      padding: const EdgeInsets.only(left: 13, right: 13, bottom: 8, top: 6),
      child: Row(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width / 1.1,
            decoration: BoxDecoration(
              color: DesignCourseAppTheme.nearlyWhite,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(25.0),
                bottomRight: Radius.circular(25.0),
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0),
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: DesignCourseAppTheme.grey.withOpacity(0.2),
                    offset: const Offset(1.1, 1.1),
                    blurRadius: 8.0),
              ],
            ),
            child: Column(
              children: [
            Padding(
            padding: const EdgeInsets.only(left: 10,right: 10),
              child: Row(
                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  // Chip(
                  //   backgroundColor: Colors.white,
                  //   avatar: CircleAvatar(
                  //       backgroundColor:Colors.grey,
                  //       child: Icon(
                  //         Icons.access_time,
                  //         color: Colors.white,
                  //         size: 16.0,
                  //       )),
                  //   label: Text( DateFormat('hh:mm a').format(order.created.toDate()).toString(),
                  //     style: TextStyle(color: Colors.grey),
                  //   ),
                  // ),
                  timeBuilder(),

                  if (order.confirm == 3) ...[
                    const Chip(
                      avatar: CircleAvatar(
                          backgroundColor: DesignCourseAppTheme.delivery,
                          child: Icon(
                            Icons.check,
                            color: Colors.amber,
                            size: 20.0,
                          )),
                      label: Text('Delivered'),
                    ),
                  ]
                ],
              ),
              ),



                 Center(
                  child: Column(
                    children: [
                      Chip(



                        avatar: const CircleAvatar(
                            backgroundColor: DesignCourseAppTheme.delivery,
                            child: Icon(
                              Icons.access_time,
                              color: Colors.amber,
                              size: 20.0,
                            )),
                        label:  Text(formattedDeliveryDuration),
                      ),
                      FutureBuilder<DocumentSnapshot>(
                        future:FirebaseFirestore.instance.collection('cuisine').doc(order.cuisine_id).get(),
                        builder:
                            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (snapshot.hasData) {
                            Map<String, dynamic> data =
                            snapshot.data!.data() as Map<String, dynamic>;
                            return Text(
                              '${data['cuisine_name']}',
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                letterSpacing: 0.27,
                                color: DesignCourseAppTheme.darkerText,
                              ),
                            );
                          }
                          return SizedBox.fromSize();
                        },
                      ),
                      FutureBuilder<DocumentSnapshot>(
                        future:FirebaseFirestore.instance.collection('restaurant').doc(order.rest_id).get(),
                        builder:
                            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (snapshot.hasData) {
                            Map<String, dynamic> data =
                            snapshot.data!.data() as Map<String, dynamic>;


                            return Row(children: [
                              SizedBox(
                                width: 8,
                              ),
                              Chip(
                                backgroundColor: Colors.white,
                                avatar: const CircleAvatar(
                                    backgroundColor:Colors.grey,
                                    child: Icon(
                                      Icons.food_bank_rounded,
                                      color: Colors.white,
                                      size: 14.0,
                                    )),
                                label: Text(data['rest_name'],
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                              Chip(
                                  backgroundColor: Colors.white,
                                  avatar: CircleAvatar(
                                      backgroundColor:Colors.grey,
                                      child: Icon(
                                        Icons.payments_outlined,
                                        color: Colors.white,
                                        size: 16.0,
                                      )),
                                  label: Text("ETB "+order.total_price.toString(),
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                            ],);



                          }
                          return SizedBox.fromSize();
                        },
                      ),
                    ],
                  ),
                ),

                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   children: <Widget>[
                //     // Padding(
                //     //   padding: const EdgeInsets.only(
                //     //     left: 6,
                //     //     right: 2,
                //     //     bottom: 13,
                //     //   ),
                //     //   child: ClipOval(
                //     //     child: SizedBox.fromSize(
                //     //       size: Size.fromRadius(48), // Image radius
                //     //       child: FutureBuilder(
                //     //         future: getStorageUrlStringProfilePic(data['photo_url']),
                //     //         builder: (context, snapshot) {
                //     //           if (snapshot.hasError) {
                //     //             return const Text(
                //     //               "Something went wrong",
                //     //             );
                //     //           }
                //     //           if (snapshot.connectionState ==
                //     //               ConnectionState.done) {
                //     //             return Image.network(
                //     //                 snapshot.data.toString(),
                //     //                 height: 150,
                //     //                 width: 150,
                //     //                 fit: BoxFit.cover);
                //     //           }
                //     //           return const Center(
                //     //               child: CircularProgressIndicator(color: Colors.amber,));
                //     //         },
                //     //       ),
                //     //     ),
                //     //   ),
                //     // ),
                //
                //     if (order.confirm == 0) ...[
                //       Column(
                //         children: <Widget>[
                //           Padding(
                //             padding: const EdgeInsets.only(
                //               top: 13,
                //               left: 6,
                //               right: 6,
                //               bottom: 13,
                //             ),
                //             child: Column(
                //               mainAxisAlignment: MainAxisAlignment.center,
                //               crossAxisAlignment: CrossAxisAlignment.center,
                //               children:  const [
                //
                //                 SizedBox(
                //                   width: 300,
                //                   child: Text(
                //                     'We are processing your order, we will let you know the status in a moment.',
                //                     textAlign: TextAlign.center,
                //                     style: TextStyle(
                //                       fontWeight: FontWeight.w300,
                //                       fontSize: 16,
                //                       letterSpacing: 0.27,
                //                       color: DesignCourseAppTheme.darkerText,
                //                     ),
                //                   ),
                //                 ),
                //               ],
                //             ),
                //           ),
                //         ],
                //       ),
                //     ] else if (order.confirm == 1) ...[
                //       Column(
                //         children: <Widget>[
                //           Padding(
                //             padding: EdgeInsets.only(
                //               top: 13,
                //               left: 6,
                //               right: 6,
                //               bottom: 13,
                //             ),
                //             child: Column(
                //               mainAxisAlignment: MainAxisAlignment.center,
                //               crossAxisAlignment: CrossAxisAlignment.center,
                //               children: const [
                //                 SizedBox(
                //                   height: 13,
                //                 ),
                //                 SizedBox(
                //                   width: 300,
                //                   child: Text(
                //                     'Your ordered food in now being prepared at the restaurant.',
                //                     textAlign: TextAlign.center,
                //                     style: TextStyle(
                //                       fontWeight: FontWeight.w300,
                //                       fontSize: 16,
                //                       letterSpacing: 0.27,
                //                       color: DesignCourseAppTheme.darkerText,
                //                     ),
                //                   ),
                //                 ),
                //               ],
                //             ),
                //           ),
                //         ],
                //       ),
                //     ] else if (order.confirm == 2) ...[
                //       Column(
                //         children: <Widget>[
                //           Padding(
                //             padding: EdgeInsets.only(
                //               top: 13,
                //               left: 6,
                //               right: 6,
                //               bottom: 13,
                //             ),
                //             child: Column(
                //               mainAxisAlignment: MainAxisAlignment.center,
                //               crossAxisAlignment: CrossAxisAlignment.center,
                //               children: const [
                //                 SizedBox(
                //                   height: 13,
                //                 ),
                //                 SizedBox(
                //                   width: 300,
                //                   child: Text(
                //                     'Your ordered food is now on the way to you, '
                //                         'the delivery person will contact you up on arrival, '
                //                         'don\'t forget to accept meal receipt from the delivery person.',
                //                     textAlign: TextAlign.center,
                //                     style: TextStyle(
                //                       fontWeight: FontWeight.w300,
                //                       fontSize: 16,
                //                       letterSpacing: 0.27,
                //                       color: DesignCourseAppTheme.darkerText,
                //                     ),
                //                   ),
                //                 ),
                //               ],
                //             ),
                //           ),
                //         ],
                //       ),
                //     ] else if (order.confirm == 3) ...[
                //       Column(
                //         children: <Widget>[
                //           Padding(
                //             padding: EdgeInsets.only(
                //               top: 13,
                //               left: 6,
                //               right: 6,
                //               bottom: 13,
                //             ),
                //             child: Column(
                //               mainAxisAlignment: MainAxisAlignment.center,
                //               crossAxisAlignment: CrossAxisAlignment.center,
                //               children: const [
                //                 SizedBox(
                //                   height: 13,
                //                 ),
                //                 SizedBox(
                //                   width: 300,
                //                   child: Text(
                //                     'Your ordered food has been delivered to you successfully, enjoy your meal! ',
                //                     textAlign: TextAlign.center,
                //                     style: TextStyle(
                //                       fontWeight: FontWeight.w300,
                //                       fontSize: 16,
                //                       letterSpacing: 0.27,
                //                       color: DesignCourseAppTheme.darkerText,
                //                     ),
                //                   ),
                //                 ),
                //               ],
                //             ),
                //           ),
                //         ],
                //       ),
                //     ]else if (order.confirm == 4) ...[
                //         Column(
                //           children: <Widget>[
                //             Padding(
                //               padding: EdgeInsets.only(
                //                 top: 13,
                //                 left: 6,
                //                 right: 6,
                //                 bottom: 13,
                //               ),
                //               child: Column(
                //                 mainAxisAlignment: MainAxisAlignment.center,
                //                 crossAxisAlignment: CrossAxisAlignment.center,
                //                 children: const [
                //                   SizedBox(
                //                     height: 13,
                //                   ),
                //                   SizedBox(
                //                     width: 300,
                //                     child: Text(
                //                       'We are sorry that we could not process your order at the moment,'
                //                           'this is mostly because the food is not available at the ordered time ',
                //                       textAlign: TextAlign.center,
                //                       style: TextStyle(
                //                         fontWeight: FontWeight.w300,
                //                         fontSize: 16,
                //                         letterSpacing: 0.27,
                //                         color: DesignCourseAppTheme.darkerText,
                //                       ),
                //                     ),
                //                   ),
                //                 ],
                //               ),
                //             ),
                //           ],
                //         ),
                //       ]
                //
                //   ],
                // ),
                // Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                //
                //
                //   Chip(
                //     backgroundColor: Colors.white,
                //     avatar: const CircleAvatar(
                //         backgroundColor:Colors.grey,
                //         child: Icon(
                //           Icons.amp_stories_outlined,
                //           color: Colors.white,
                //           size: 16.0,
                //         )),
                //     label: Text(NumberToWord().convert('en-in',order.amount),
                //       style: TextStyle(color: Colors.grey),
                //     ),
                //   ),
                //   Chip(
                //     backgroundColor: Colors.white,
                //     avatar: CircleAvatar(
                //         backgroundColor:Colors.grey,
                //         child: Icon(
                //           Icons.payments_outlined,
                //           color: Colors.white,
                //           size: 16.0,
                //         )),
                //     label: Text("ETB "+order.total_price.toString(),
                //       style: TextStyle(color: Colors.grey),
                //     ),
                //   ),
                //   Chip(
                //     backgroundColor: Colors.white,
                //     avatar: CircleAvatar(
                //         backgroundColor:Colors.grey,
                //         child: Icon(
                //           Icons.confirmation_num,
                //           color: Colors.white,
                //           size: 16.0,
                //         )),
                //     label: Text(order.order_num.toString(),
                //       style: TextStyle(color: Colors.grey),
                //     ),
                //   ),
                //   SizedBox(
                //     width: 4,
                //   ),
                // ])
              ],
            ),
          ),
        ],
      ),
    );
  }


   Widget timeBuilder() => Chip(
     avatar: const CircleAvatar(
         backgroundColor: DesignCourseAppTheme.delivery,
         child: Icon(
           Icons.access_time,
           color: Colors.amber,
           size: 20.0,
         )),
     label:  Text(DateFormat.MMMEd().format(DateTime.parse(order.created.toDate().toString()))),
   );



  // updateCuisine() async {
  //   var collection = FirebaseFirestore.instance.collection('cuisine');
  //   var querySnapshots = await collection.get();
  //   for (var doc in querySnapshots.docs) {
  //     await doc.reference.update({
  //       'PFee': 0,
  //     });
  //   }
  // }

}
