import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:pick_delivery_adama_biker/restaurant_page.dart';
import 'package:pick_delivery_adama_biker/widget/restaurant_grid.dart';

import 'data/restaurant_provider.dart';
import 'model/restaurnat.dart';

class DesignCourseHomeScreen extends StatefulWidget {
    //DesignCourseHomeScreen({Key? key, required this.catID}) : super(key: key);

  final GeoFirePoint? userloc;
  final String catID;
    const DesignCourseHomeScreen ({
       Key? key,
      this.userloc,
      required this.catID,

    }) : super(key: key);

  @override
  _DesignCourseHomeScreenState createState() => _DesignCourseHomeScreenState();
}

class _DesignCourseHomeScreenState extends State<DesignCourseHomeScreen> {
  CategoryType categoryType = CategoryType.ui;
  var users = FirebaseFirestore.instance.collection('Users');
  //var userid = FirebaseAuth.instance.currentUser!.uid.toString();
  bool _isLoading = true;
  late final FirestoreRestaurantProvider _firestoreRestaurantProvider;
  late final FirestoreRestaurantProvider _firestoreRestaurantProviderFiltered;

  // late final FirestoreRestaurantProvider _firestoreRestaurantProvider=FirestoreRestaurantProvider(widget.catID);
  // late final FirestoreRestaurantProvider _firestoreRestaurantProviderFiltered=FirestoreRestaurantProvider(widget.catID);

  String Name = "";

  @override
  void initState() {
    super.initState();
     _firestoreRestaurantProvider = FirestoreRestaurantProvider(widget.catID);
     _firestoreRestaurantProviderFiltered = FirestoreRestaurantProvider(widget.catID);

    _firestoreRestaurantProvider.loadAllRestaurants();
    _firestoreRestaurantProviderFiltered.loadFilteredRestaurants();

    _isLoading = false;
    // print(widget.catID);
  }
  @override
  void dispose() {

    // _firestoreRestaurantProvider.dispose();
    // _firestoreRestaurantProviderFiltered.dispose();
    _firestoreRestaurantProvider.loadAllRestaurants();
    _firestoreRestaurantProviderFiltered.loadFilteredRestaurants();
    _firestoreRestaurantProvider.dispose();
    _firestoreRestaurantProviderFiltered.dispose();

    super.dispose();
  }

  @override
  // Widget build(BuildContext context) {
  //   return Container(
  //     color: DesignCourseAppTheme.nearlyWhite,
  //     child: Scaffold(
  //       backgroundColor: Colors.transparent,
  //       body: Column(
  //         children: <Widget>[
  //           SizedBox(
  //             height: MediaQuery.of(context).padding.top,
  //           ),
  //           // getAppBarUI(),
  //           Padding(
  //             padding: EdgeInsets.only(top: 10.0, left: 18, right: 18),
  //             child: Row(
  //               children: <Widget>[
  //                 Expanded(
  //                   child: Column(
  //                     mainAxisAlignment: MainAxisAlignment.end,
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: <Widget>[
  //                       Text(
  //                         "Welcome to",
  //                         textAlign: TextAlign.left,
  //                         style: TextStyle(
  //                           fontWeight: FontWeight.w400,
  //                           fontSize: 14,
  //                           letterSpacing: 0.2,
  //                           color: DesignCourseAppTheme.delivery,
  //                         ),
  //                       ),
  //                       Row(
  //                         children: [
  //                           Text(
  //                             'Pick',
  //                             textAlign: TextAlign.left,
  //                             style: TextStyle(
  //                               fontWeight: FontWeight.bold,
  //                               fontSize: 26,
  //                               letterSpacing: 0.27,
  //                               color: DesignCourseAppTheme.mainLogoColor,
  //                             ),
  //                           ),
  //                           Text(
  //                             "Delivery",
  //                             textAlign: TextAlign.left,
  //                             style: TextStyle(
  //                               fontWeight: FontWeight.bold,
  //                               fontSize: 26,
  //                               letterSpacing: 0.27,
  //                               color: DesignCourseAppTheme.delivery,
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //
  //                 // InkWell(
  //                 //   child: FutureBuilder<String>(
  //                 //     future: getStorageUrlString(),
  //                 //     builder: (BuildContext context,
  //                 //         AsyncSnapshot<String> snapshot) {
  //                 //       //Image image = Image.network(snapshot.data.toString());
  //                 //       //Image image =Image(image: CachedNetworkImageProvider(snapshot.data.toString()));
  //                 //       // Image imageLocal = Image.asset(
  //                 //       //     'assets/design_course/userImage.png');
  //                 //
  //                 //       return CircularProfileAvatar(
  //                 //         //snapshot.data.toString(),
  //                 //         "",
  //                 //         //sets image path, it should be a URL string. default value is empty string, if path is empty it will display only initials
  //                 //         radius: 40,
  //                 //         // sets radius, default 50.0
  //                 //         backgroundColor: Colors.transparent,
  //                 //         // sets background color, default Colors.white
  //                 //         borderWidth: 7,
  //                 //         // sets border, default 0.0
  //                 //         initialsText: Text(
  //                 //           Name,
  //                 //           style: TextStyle(fontSize: 24, color: Colors.white),
  //                 //         ),
  //                 //         // sets initials text, set your own style, default Text('')
  //                 //         borderColor: Colors.brown,
  //                 //         // sets border color, default Colors.white
  //                 //         elevation: 4.0,
  //                 //         // sets elevation (shadow of the profile picture), default value is 0.0
  //                 //         // foregroundColor: Colors.brown.withOpacity(0.5), //sets foreground colour, it works if showInitialTextAbovePicture = true , default Colors.transparent
  //                 //         cacheImage: true,
  //                 //         // allow widget to cache image against provided url
  //                 //         imageFit: BoxFit.cover,
  //                 //         onTap: () {
  //                 //           Navigator.push<dynamic>(
  //                 //             context,
  //                 //             MaterialPageRoute<dynamic>(
  //                 //               builder: (BuildContext context) =>
  //                 //                   ProfilePage(),
  //                 //             ),
  //                 //           );
  //                 //         },
  //                 //         // sets on tap
  //                 //         showInitialTextAbovePicture: true, // setting it true will show initials text above profile picture, default false
  //                 //       );
  //                 //       // if (snapshot.connectionState == ConnectionState.done) {
  //                 //       //   if (snapshot.hasData) {
  //                 //       //     return CachedNetworkImage(
  //                 //       //       imageUrl: snapshot.data.toString(),
  //                 //       //       imageBuilder: (context, imageProvider) => Container(
  //                 //       //         decoration: BoxDecoration(
  //                 //       //           image: DecorationImage(
  //                 //       //               image: imageProvider,
  //                 //       //               fit: BoxFit.cover,
  //                 //       //               colorFilter:
  //                 //       //               ColorFilter.mode(Colors.red, BlendMode.colorBurn)),
  //                 //       //         ),
  //                 //       //       ),
  //                 //       //       placeholder: (context, url) => CircularProgressIndicator(color: Colors.amber,),
  //                 //       //       errorWidget: (context, url, error) => Icon(Icons.error),
  //                 //       //     );
  //                 //       //   } else  {
  //                 //       //     return CircleAvatar(
  //                 //       //       radius: 45,
  //                 //       //       backgroundColor: Colors.deepOrangeAccent,
  //                 //       //       child: ClipOval(
  //                 //       //         child: Image(
  //                 //       //           image:imageLocal.image,
  //                 //       //           fit: BoxFit.cover,
  //                 //       //           width: 85,
  //                 //       //           height: 85,
  //                 //       //         ),
  //                 //       //       ),
  //                 //       //     );
  //                 //       //   }
  //                 //       // }
  //                 //       // return Text("");
  //                 //     },
  //                 //   ),
  //                 //   // child: Container(
  //                 //   //   width: 60,
  //                 //   //   height: 60,
  //                 //   //   child: Image.asset('assets/design_course/userImage.png'),
  //                 //   // ),
  //                 //
  //                 // ),
  //                 //
  //
  //                // buildUserNameProfile(),
  //
  //               ],
  //             ),
  //           ),
  //           Expanded(
  //             child: Container(
  //               height: MediaQuery.of(context).size.height,
  //               child: Column(
  //                 children: <Widget>[
  //                   // getSearchBarUI(),
  //
  //
  //                   //getFeaturedCuisines(),
  //
  //
  //                   Flexible(
  //                     child: getRestaurants(),
  //                   ),
  //
  //                   // CachedNetworkImage(
  //                   //   imageUrl: "https://firebasestorage.googleapis.com/v0/b/the-adama-project.appspot.com/o/cuisine-pics%2F7TT0qXpGnqyjZ4wjE4QW?alt=media&token=a0d5ac70-c749-4eb7-8e6e-9f125e65975e",
  //                   //   placeholder: (context, url) => CircularProgressIndicator(color: Colors.amber,),
  //                   //   errorWidget: (context, url, error) => Icon(Icons.error),
  //                   // ),
  //
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //
  //       // FLOATING ACTION BUTTON HERE
  //       //  floatingActionButton: FloatingActionButton(
  //       //    tooltip:"Order by",
  //       //    backgroundColor: Colors.amber,
  //       //    foregroundColor: Colors.white,
  //       //     onPressed: (){},
  //       //    child: Icon(Icons.call),
  //       //  ),
  //     ),
  //   );
  // }
  Widget build(BuildContext context) {

    if(widget.catID =="1"){
      return StreamBuilder<List<Restaurant>>(
        stream: _firestoreRestaurantProvider.allRestaurants,
        initialData: [],
        builder:
            (BuildContext context, AsyncSnapshot<List<Restaurant>> snapshot) {
          final _restaurants = snapshot.data!;

          return Scaffold(
            body: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 900),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.amber,)
                    : _restaurants.isNotEmpty
                    ? RestaurantGrid(
                  restaurants: _restaurants,
                  userloc:widget.userloc,
                  onRestaurantPressed: (restaurant) {
                    Navigator.pushNamed(
                      context,
                      RestaurantPage.route,
                      arguments: RestaurantPageArguments(restaurant),
                    );
                  },
                )
                    :const CircularProgressIndicator(color: Colors.amber,),
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
    else {
      return StreamBuilder<List<Restaurant>>(
        stream: _firestoreRestaurantProviderFiltered.filteredRestaurants,
        initialData:  [],
        builder:(BuildContext context, AsyncSnapshot<List<Restaurant>> snapshot) {
          final _restaurants = snapshot.data!;

          return Scaffold(
            body: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 900),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.amber,)
                    : _restaurants.isNotEmpty
                    ? RestaurantGrid(
                  restaurants: _restaurants,
                  userloc:widget.userloc,
                  onRestaurantPressed: (restaurant) {
                    Navigator.pushNamed(
                      context,
                      RestaurantPage.route,
                      arguments: RestaurantPageArguments(restaurant),
                    );
                  },
                )
                    :const CircularProgressIndicator(color: Colors.amber,),
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

  }

  Widget getFeaturedCuisines() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // CategoryListView(
        //   callBack: () {
        //     // moveTo();
        //   },
        // ),
      ],
    );
  }

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
