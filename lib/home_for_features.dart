import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pick_delivery_adama_biker/widget/feature_grid.dart';

import 'app_theme.dart';
import 'data/feature_provider.dart';
import 'model/feature.dart';

class DesignCourseHomeScreenFeature extends StatefulWidget {
  @override
  _DesignCourseHomeScreenFeatureState createState() => _DesignCourseHomeScreenFeatureState();
}

class _DesignCourseHomeScreenFeatureState extends State<DesignCourseHomeScreenFeature> {
  CategoryType categoryType = CategoryType.ui;
  var users = FirebaseFirestore.instance.collection('Users');
  //var userid = FirebaseAuth.instance.currentUser!.uid.toString();

  bool _isLoading = true;
  final FirestoreFeaturesProvider _firestoreFeatureProvider =
  FirestoreFeaturesProvider();

  String Name = "";

  @override
  void initState() {

    _firestoreFeatureProvider.loadAllFeatures();
    _isLoading = false;
    super.initState();
  }
  @override
  void dispose() {
    _firestoreFeatureProvider.dispose();
    super.dispose();
  }

  @override

  Widget build(BuildContext context) {
    return StreamBuilder<List<Features>>(
      stream: _firestoreFeatureProvider.allFeatures,
      initialData: [],
      builder:
          (BuildContext context, AsyncSnapshot<List<Features>> snapshot) {
        final _features = snapshot.data!;

        return Scaffold(

          body: Center(

            child: Container(
             decoration: BoxDecoration(
                //color: HexColor('#F8FAFB'),
                borderRadius: BorderRadius.circular(25),

                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: DesignCourseAppTheme.notWhite
                          .withOpacity(0.1),
                      offset: const Offset(1, 1),
                      blurRadius: 4.0),
                ],

              ),



              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.amber,)
                  : _features.isNotEmpty
                  ? FeatureGrid(
                features: _features,

              )
                  :CircularProgressIndicator(color: Colors.amber,),
              //     : EmptyListView(
              //   child: Text('FriendlyEats has no restaurants yet!'),
              //   //onPressed: _onAddRandomRestaurantsPressed,
              // ),
            ),
          ),
        );
      },
    );
  }





  // Widget getFeaturedCuisines() {
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: <Widget>[
  //       CategoryListView(
  //         callBack: () {
  //           // moveTo();
  //         },
  //       ),
  //     ],
  //   );
  // }
  //
  // Widget getRestaurants() {
  //   return Padding(
  //     padding: const EdgeInsets.only(top: 0, left: 18, right: 16, bottom: 8.0),
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: <Widget>[
  //         const Text(
  //           "Pick a restaurant",
  //           textAlign: TextAlign.left,
  //           style: TextStyle(
  //             fontWeight: FontWeight.w600,
  //             fontSize: 20,
  //             letterSpacing: 0.27,
  //             color: DesignCourseAppTheme.delivery,
  //           ),
  //         ),
  //         Flexible(
  //           child: RestaurantsListView(
  //             callBack: () {
  //               // moveTo();
  //             },
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }

// Future<String> getInitials() async {
//   String test = "";
//   await FirebaseFirestore.instance
//       .collection('users')
//       .doc(userid)
//       .get()
//       .then((DocumentSnapshot documentSnapshot) {
//     Map<String, dynamic> data =
//         documentSnapshot.data() as Map<String, dynamic>;
//     test = data['displayName'];
//
//     List<String> names = data['displayName'].split(" ");
//     String initials = "";
//     int numWords = 2;
//
//     if (numWords < names.length) {
//       numWords = names.length;
//     }
//     for (var i = 0; i < numWords; i++) {
//       initials += '${names[i][0]}';
//     }
//   });
//   return test;
// }
//
// Widget buildUserNameProfile() => FutureBuilder<DocumentSnapshot>(
//       future: users.doc(userid).get(),
//       builder:
//           (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(
//             child: Container(
//               alignment: Alignment.center,
//               child: CircularProgressIndicator(color: Colors.amber,),
//             ),
//           );
//         } else if (snapshot.hasData) {
//           Map<String, dynamic> data =
//               snapshot.data!.data() as Map<String, dynamic>;
//           return InkWell(
//             child: CircularProfileAvatar(
//               //url.toString(),
//               //data['ref'],
//                "",
//               //sets image path, it should be a URL string. default value is empty string, if path is empty it will display only initials
//               radius: 35,
//               // sets radius, default 50.0
//               backgroundColor: Colors.amberAccent,
//               borderColor: Colors.amber,
//               // sets background color, default Colors.white
//               borderWidth: 6,
//               // sets border, default 0.0
//               initialsText: Text(
//                 data['displayName'].substring(0, 1).toUpperCase(),
//                 style: TextStyle(fontSize: 25, color: Colors.white),
//               ),
//               // sets initials text, set your own style, default Text('')
//
//               // sets border color, default Colors.white
//               elevation: 4.0,
//               // sets elevation (shadow of the profile picture), default value is 0.0
//               // foregroundColor: Colors.brown.withOpacity(0.5), //sets foreground colour, it works if showInitialTextAbovePicture = true , default Colors.transparent
//               cacheImage: true,
//               // allow widget to cache image against provided url
//               imageFit: BoxFit.cover,
//               onTap: () {
//                 Navigator.push<dynamic>(
//                   context,
//                   MaterialPageRoute<dynamic>(
//                     builder: (BuildContext context) => ProfilePage(),
//                   ),
//                 );
//               },
//               // sets on tap
//               // showInitialTextAbovePicture: true, // setting it true will show initials text above profile picture, default false
//             ),
//           );
//         }
//         return const Text('');
//       },
//     );
//
// Future<String> getStorageUrlString() async {
//   String downloadURL = await firebase_storage.FirebaseStorage.instance
//       .ref('profile-pics/' + userid)
//       .getDownloadURL();
//   return downloadURL.toString();
// }
//
//


}

enum CategoryType {
  ui,
  coding,
  basic,
}
