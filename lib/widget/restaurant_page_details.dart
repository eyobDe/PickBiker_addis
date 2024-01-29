/*
 *  Copyright 2022 Google LLC
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *       http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:pick_delivery_adama_biker/widget/star_rating.dart';
import '../home_for_cats.dart';
import '../home_for_menu.dart';
import '../model/restaurnat.dart';
// import '../widgets/star_rating.dart';

class RestaurantDetails extends StatefulWidget {
   RestaurantDetails({Key? key, required this.restaurant})
      : super(key: key);

  final Restaurant restaurant;






  @override
  State<RestaurantDetails> createState() => RestaurantDetailsState();
}

class RestaurantDetailsState extends State<RestaurantDetails> {
  final globalKey = GlobalKey<ScaffoldState>();

   CollectionReference cats = FirebaseFirestore.instance.collection('category');
   String catID="1";
  List<MultiSelectCard> currencyItems = [];

  // List<String>? catIds = [];

  @override
  void initState() {
    super.initState();

    // setdata();
    // _getCatsData();
    _getMenusData();
     currencyItems.insert(0, MultiSelectCard(
         decorations: MultiSelectItemDecorations(
             decoration: BoxDecoration(
               // color:DesignCourseAppTheme.nearlyWhite,
                 borderRadius: BorderRadius.circular(20)),
             selectedDecoration: BoxDecoration(

                 // border: Border.all(
                 //   color: Colors.amber,
                 // ),
                 color:Colors.amber,
                 borderRadius: BorderRadius.circular(20)),
             disabledDecoration: BoxDecoration(
               //color: Colors.transparent,
                 border: Border.all(color: Colors.grey[500]!),
                 borderRadius: BorderRadius.circular(10))),

         value:'1', label: "All"));

    //applylist();
    //catIds=widget.restaurant.categories;
  }
  // void setdata(){
  //
  //   for (int i = 0; i < widget.restaurant.categories.length; i++) {
  //     FirebaseFirestore.instance
  //         .collection('category')
  //         .doc(widget.restaurant.categories[i])
  //         .get()
  //         .then((DocumentSnapshot documentSnapshot) {
  //       Map<String, dynamic> data =
  //       documentSnapshot.data() as Map<String, dynamic>;
  //
  //       if (documentSnapshot.exists) {
  //         //print('Document data: ${documentSnapshot.data()}');
  //
  //         currencyItems.add(MultiSelectCard(value:widget.restaurant.categories[i], label:data['cat_name']));
  //
  //         //Set the relevant data to variables as needed
  //       } else {
  //         print('Document does not exist on the database');
  //       }
  //     });
  //
  //   }
  // }

   @override
  Widget build(BuildContext context) {

    return Stack(
     // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Hero(
          tag: 'restaurant-image-${widget.restaurant.id}',
          child: SizedBox(
            height: 180.0,
            child: Container(

              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(75.0),
                  bottomRight: Radius.circular(75.0),
                ),

                image: DecorationImage(
                  alignment: Alignment.center,
                  image: NetworkImage(widget.restaurant.photo!),
                  fit: BoxFit.cover,
                ),
              ),

            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: (MediaQuery.of(context).size.height / 3.9),

          ),
          child: Text(
            widget.restaurant.rest_name,
            style: Theme.of(context).textTheme.headline6,
            textAlign: TextAlign.start,
          ),
        ),
        Padding(
          padding:  EdgeInsets.only(
            bottom: 2.0,
            left: 16.0,
            top: (MediaQuery.of(context).size.height / 3.5),

          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              StaticStarRating(
                rating: widget.restaurant.rate,
                color: Colors.amber,
                size: 14.5,
              ),
              Text('  ${widget.restaurant.rate} ' ),

            ],
          ),
        ),
        // HomeForCats(
        //   widget.restaurant.categories,
        // ),


        if (widget.restaurant.categories.isNotEmpty) ...[
          Padding(
              padding:  EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                top: (MediaQuery.of(context).size.height / 3.2),


              ),

              child: SingleChildScrollView(
                scrollDirection:Axis.horizontal,
                child: StreamBuilder<QuerySnapshot>(
                    stream: cats.where('catid', whereIn: widget.restaurant.categories).snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        const Text("Loading.....");
                      } else {
                        for (int i = 0; i < snapshot.data!.docs.length; i++) {
                          DocumentSnapshot snap = snapshot.data!.docs[i];
                          currencyItems.add(MultiSelectCard(

                              decorations: MultiSelectItemDecorations(
                                  decoration: BoxDecoration(
                                    // color:DesignCourseAppTheme.nearlyWhite,
                                      borderRadius: BorderRadius.circular(20)),
                                  selectedDecoration: BoxDecoration(

                                    // border: Border.all(
                                    //   color: Colors.amber,
                                    // ),
                                      color:Colors.amber,
                                      borderRadius: BorderRadius.circular(20)),
                                  disabledDecoration: BoxDecoration(
                                    //color: Colors.transparent,
                                      border: Border.all(color: Colors.grey[500]!),
                                      borderRadius: BorderRadius.circular(10))),


                              value:snap.id, label: snap["cat_name"]));
                        }
                        return MultiSelectContainer(

                            singleSelectedItem:true,
                            items:currencyItems.toList(),
                            onChange: (allSelectedItems, selectedItem) {
                              //categories=allSelectedItems;
                              setState(() {
                                catID=selectedItem.toString();
                              });
                            });
                      }
                      return const Text("Loading.....");
                    }
                ),

              )
            // child: FutureBuilder<MultiSelectContainer>(
            //   future: _getCatsData(),
            //   builder: (context, snapshot) {
            //     return snapshot.connectionState == ConnectionState.waiting
            //         ? const CircularProgressIndicator(color: Colors.amber,)
            //         : snapshot.data!;
            //     //
            //     // MultiSelectContainer(
            //     //     singleSelectedItem:true,
            //     //     items:currencyItems.toList(),
            //     //     onChange: (allSelectedItems, selectedItem) {
            //     //       //categories=allSelectedItems;
            //     //       setState(() {
            //     //         catID=selectedItem.toString();
            //     //       });
            //     //
            //     //     });
            //   },
            // ),


          ),
        ],

        Padding(
          padding:  EdgeInsets.only(
            top: (MediaQuery.of(              context).size.height / 2.7),

          ),
          child: SingleChildScrollView(
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 3,
                    right: 3,
                    bottom: 6
                ),
                child: buildMenus(),
              ),
            ],),

          ),
        ),


      ],
    );

  }

  // Future<MultiSelectContainer> _getCatsData()   {
  //   return Future.delayed(const Duration(seconds: 2), () {
  //     return MultiSelectContainer(
  //         singleSelectedItem:true,
  //         items:currencyItems.toList(),
  //         onChange: (allSelectedItems, selectedItem) {
  //           //categories=allSelectedItems;
  //
  //           setState(() {
  //             catID="tst";
  //           });
  //         //  updateProfile("tst");
  //
  //         });
  //     // throw Exception("Custom Error");
  //   });
  //
  // }

  Widget buildMenus() => FutureBuilder (
    builder: (ctx, snapshot) {
      // Checking if future is resolved or not
      if (snapshot.connectionState == ConnectionState.done) {
        // If we got an error
        if (snapshot.hasError) {
          return Center(
            child: Text(
              '${snapshot.error} occurred',
              style: TextStyle(fontSize: 18),
            ),
          );

          // if we got our data
        } else if (snapshot.hasData) {
          // Extracting data from snapshot object
          return DesignCourseHomeScreenMenu(
            rest:widget.restaurant.id!, catID: catID,
          );
        }
      }
      // Displaying LoadingSpinner to indicate waiting state
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.amber,
        ),
      );
    },
    future: _getMenusData(),
  );

  Future<String> _getMenusData()   {
    return Future.delayed(const Duration(seconds: 2), () {
      return catID;
      // throw Exception("Custom Error");
    });
  }


}
