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

//import '../widgets/star_rating.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';

//import '../model/restaurant.dart';
import '../app_theme.dart';
import '../check_out.dart';
import '../model/menu.dart';


class MenuCard extends StatelessWidget {
  MenuCard({
    required this.menu,
  }) ;

  final Menu menu;

  @override
  Widget build(BuildContext context) {
    // return Card(
    //
    //
    //   child: InkWell(
    //     splashColor: Colors.transparent,
    //     // onTap: callback,
    //     onTap: () {
    //
    //     },
    //     child:  Container(
    //       width: 370,
    //       height: (MediaQuery.of(context).size.height / 3),
    //       decoration: BoxDecoration(
    //         //color: HexColor('#F8FAFB'),
    //         borderRadius: BorderRadius.circular(35),
    //         image: DecorationImage(
    //           image: CachedNetworkImageProvider(
    //             menu.photo!,
    //           ),
    //
    //           fit: BoxFit.cover,
    //           colorFilter:
    //           ColorFilter.mode(Colors.black.withOpacity(0.25), BlendMode.srcOver),
    //         ),
    //
    //         boxShadow: <BoxShadow>[
    //           BoxShadow(
    //               color: DesignCourseAppTheme.notWhite
    //                   .withOpacity(0.1),
    //               offset: const Offset(1, 1),
    //               blurRadius: 4.0),
    //         ],
    //
    //       ),
    //
    //
    //     ),
    //
    //   ),
    //
    //
    // );

   int foodPrice= menu.price! + menu.PFee!;

   return Padding(
      padding: EdgeInsets.only(left: 13, right: 13, bottom: 8, top: 6),
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
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      left: 6, right: 6, bottom: 6, top: 6),
                  child: ClipOval(
                    child: SizedBox.fromSize(
                      size: Size.fromRadius(48), // Image radius
                      // child: Image.network(
                      //     "https://firebasestorage.googleapis.com/v0/b/the-adama-project.appspot.com/o/"+menu.photo.toString(),
                      //     height: 150,
                      //     width: 150,
                      //     fit: BoxFit.cover),

                        child:FutureBuilder(
                          future: getStorageUrlStringProfilePic(menu.photo.toString()),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              // return Text(
                              //   "Something went wrong" ,
                              // );
                              print("error is "+snapshot.error.toString());
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return Image.network(
                                  snapshot.data.toString(),
                                  height: 150,
                                  width: 150,
                                  fit: BoxFit.cover);
                            }
                            return const Center(
                                child: CircularProgressIndicator(color: Colors.amber,));
                          },
                        )

                    ),
                  ),
                ),
                Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          left: 4, right: 4, bottom: 20, top: 2),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 24,
                          ),
                          SizedBox(
                            width: 190,
                            child: Text(
                              menu.name.toString(),
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                letterSpacing: 0.27,
                                color: DesignCourseAppTheme.darkerText,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          SizedBox(
                            width: 190,
                            child: Text(
                              menu.menu_desc.toString(),
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                fontWeight: FontWeight.w200,
                                fontSize: 16,
                                letterSpacing: 0.27,
                                color: DesignCourseAppTheme.darkerText,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                foodPrice.toString()+ "ETB",
                              ),
                              const SizedBox(
                                width: 10,
                              ),

                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                  MaterialStateProperty.all(Colors.amber),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(35.0),
                                      )),
                                ),
                                child: const Text(
                                  'Order Now',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 13,
                                    letterSpacing: 0.27,
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () {

                                  Navigator.push<dynamic>(
                                    context,
                                    MaterialPageRoute<dynamic>(
                                        builder: (BuildContext context) => CheckOut(
                                          menu: menu,
                                        )
                                    ),
                                  );

                                },
                              ),
                              const SizedBox(
                                width: 1,
                              ),
                            ],
                          ),

                        ],
                      ),
                    ),

                  ],
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }

  getStorageUrlStringProfilePic(String cuisineDoc) async {
    String downloadURL = await firebase_storage.FirebaseStorage.instance
        .ref()
        .child(cuisineDoc)
        .getDownloadURL();
    return downloadURL;
  }

  //
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
