import 'package:cached_network_image/cached_network_image.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pick_delivery_adama_biker/pages/profile_page.dart';
import 'package:url_launcher/url_launcher.dart';

//import 'home_page.dart';
import 'app_theme.dart';
import 'home_for_clients.dart';
import 'home_for_features.dart';
import 'home_for_offers.dart';
import 'home_for_phone_orders.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';


class AppExtended extends StatefulWidget {
  const AppExtended({Key? key}) : super(key: key);
  @override
  State<AppExtended> createState() => _AppExtendedState();
}

class _AppExtendedState extends State<AppExtended> {
  var users = FirebaseFirestore.instance.collection('biker');
  CollectionReference cats = FirebaseFirestore.instance.collection('category');
  var userid = FirebaseAuth.instance.currentUser!.uid.toString();

  String Name = "";
  String catID="1";
  List<MultiSelectCard> currencyItems = [];

  late Future<String> getData;
 // late Future<String> getName;


  late Geoflutterfire geo;
  late LatLng currentPostion;

  double totalDistance = 0.0;
  double restLl = 0.0;
  double restLn = 0.0;


  late Future<Position> futureCheckOut;



  @override
  void initState() {

    //getData();
    //getData = _getRestsData();
    //getName= _getInitials();
    currencyItems.insert(0, MultiSelectCard(
      contentPadding:const EdgeInsets.only( left: 2, right: 2,top:5,bottom: 5),

      decorations: MultiSelectItemDecorations(
          decoration: BoxDecoration(
            // color:DesignCourseAppTheme.nearlyWhite,
              borderRadius: BorderRadius.circular(20)),
          selectedDecoration: BoxDecoration(

              border: Border.all(
                color: Colors.amber,
              ),
              borderRadius: BorderRadius.circular(20)),
          disabledDecoration: BoxDecoration(
            //color: Colors.transparent,
              border: Border.all(color: Colors.grey[500]!),
              borderRadius: BorderRadius.circular(10))),


      value:'1', child: Column(
      children: [

        CachedNetworkImage(
          width: 35,
          height: 35,
          imageUrl:  "https://firebasestorage.googleapis.com/v0/b/the-adama-project.appspot.com/o/all.png?alt=media&token=c5d66669-fe3f-48fd-918a-f25b3ae7cef0",

          //placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),

        const Text(
          "All",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            //letterSpacing: 0.27,
            color: Colors.black,
          ),
        ),
      ],
    ),));
    super.initState();

    // _determinePosition();
    // getPosition();
    //
    // futureCheckOut = getPosition();

  }

  @override
  void dispose() {

    super.dispose();
  }

  bool isSection1Active = true;// To track which section is active

  @override
  Widget build(BuildContext context) {

    return Container(
      color: DesignCourseAppTheme.nearlyWhite,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).padding.top,
            ),
            // getAppBarUI(),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 18, right: 18),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          "Welcome to",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            letterSpacing: 0.2,
                            color: DesignCourseAppTheme.delivery,
                          ),
                        ),
                        Row(
                          children: [
                            const Text(
                              'Pick',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 26,
                                letterSpacing: 0.27,
                                color: DesignCourseAppTheme.mainLogoColor,
                              ),
                            ),
                            const Text(
                              "Delivery",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 26,
                                letterSpacing: 0.27,
                                color: DesignCourseAppTheme.delivery,
                              ),
                            ),
                            Column(
                              children: const [
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Biker\'s app',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16,
                                    //letterSpacing: 0.27,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  //buildUserNameProfile(),
                  InkWell(
                    child: CircularProfileAvatar(
                      //url.toString(),
                      //data['ref'],
                      "https://firebasestorage.googleapis.com/v0/b/the-adama-project.appspot.com/o/avater.png?alt=media&token=1d4c4ba1-0518-475a-9f47-12ef711a6d27",
                      //sets image path, it should be a URL string. default value is empty string, if path is empty it will display only initials
                      radius: 30,
                      // sets radius, default 50.0
                      backgroundColor: Colors.amberAccent,
                      borderColor: Colors.amber,
                      // sets background color, default Colors.white
                      borderWidth: 6,
                      // sets border, default 0.0
                      // initialsText: "",
                      // sets initials text, set your own style, default Text('')

                      // sets border color, default Colors.white
                      elevation: 4.0,
                      // sets elevation (shadow of the profile picture), default value is 0.0
                      foregroundColor: Colors.brown.withOpacity(0.5), //sets foreground colour, it works if showInitialTextAbovePicture = true , default Colors.transparent
                      cacheImage: true,
                      // allow widget to cache image against provided url
                      imageFit: BoxFit.cover,
                      onTap: () {
                        Navigator.push<dynamic>(
                          context,
                          MaterialPageRoute<dynamic>(
                            builder: (BuildContext context) => ProfilePage(),
                          ),
                        );
                      },
                      // sets on tap
                      // showInitialTextAbovePicture: true, // setting it true will show initials text above profile picture, default false
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              //height: MediaQuery.of(context).size.height,
              child: Column(
                children: <Widget>[
                  // getSearchBarUI(),
                  ///getFeaturedCuisines(),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(
                        height: 8,
                      ),

                      // Container(
                      //   width: MediaQuery.of(context).size.width,
                      //   height: 150,
                      //   decoration: BoxDecoration(
                      //     //color: HexColor('#F8FAFB'),
                      //    // borderRadius: BorderRadius.circular(15),
                      //     image: DecorationImage(
                      //       image: const CachedNetworkImageProvider(
                      //         "https://firebasestorage.googleapis.com/v0/b/the-adama-project.appspot.com/o/20220803_163725.jpg?alt=media&token=abebdbb1-00ff-4d00-9089-a9e71200e453",
                      //       ),
                      //
                      //       fit: BoxFit.cover,
                      //       colorFilter:
                      //       ColorFilter.mode(Colors.black.withOpacity(0.25), BlendMode.srcOver),
                      //     ),
                      //
                      //     boxShadow: <BoxShadow>[
                      //       BoxShadow(
                      //           color: DesignCourseAppTheme.notWhite
                      //               .withOpacity(0.1),
                      //           offset: const Offset(1, 1),
                      //           blurRadius: 4.0),
                      //     ],
                      //
                      //   ),
                      //
                      // ),
              Center(
                child:SizedBox(
                  height: 150,
                  width: MediaQuery.of(context).size.width / 1.05,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: ImageSlideshow(
                      indicatorColor: Colors.blue,
                      onPageChanged: (value) {
                        debugPrint('Page changed: $value');
                      },
                      autoPlayInterval: 3000,
                      isLoop: true,
                      children: [
                        Image.asset(
                          'assets/images/coverPic1.png',
                          fit: BoxFit.cover,
                        ),
                        Image.asset(
                          'assets/images/coverPic2.jpg',
                          fit: BoxFit.cover,
                        ),
                        Image.asset(
                          'assets/images/coverPic3.png',
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                  ),
                ),
              ),


              SizedBox(
                        height: 8,
                      ),

                      FutureBuilder<DocumentSnapshot>(
                        future: users.doc(userid).get(),
                        builder:
                            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(
                              child: Container(
                                alignment: Alignment.center,
                                child: const CircularProgressIndicator(color: Colors.amber,),
                              ),
                            );
                          }
                          else if (snapshot.hasData) {
                            Map<String, dynamic> data =
                            snapshot.data!.data() as Map<String, dynamic>;
                            if (data['status']==0){


                                      return const SizedBox();


                            }
                            else {
                              return Padding(
                                padding: const EdgeInsets.only(left: 4, ),
                                child:  Row(
                                  children: const [
                                    Text(
                                      'Active orders',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 16,
                                        letterSpacing: 0.27,
                                        color: Colors.black,
                                      ),
                                    ),

                                  ],
                                ),
                              );

                              }

                          }
                          return const SizedBox();
                        },
                      ),
                      SizedBox(
                        height: 8,
                      ),

                    ],
                  ),


                ],
              ),
            ),

            FutureBuilder<DocumentSnapshot>(
              future: users.doc(userid).get(),
              builder:
                  (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Container(
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(color: Colors.amber,),
                    ),
                  );
                }
                else if (snapshot.hasData) {
                  Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;
                  if (data['status']==0){


                    return Center(
                      child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:  [
                              Text(
                                'Dear '+ data['displayName']+" "
                                    "\n You have successfully joined PickDelivery, "
                                    "\n To complete your registration, please"
                                    "\n visit our office  or call 9857 ",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16,
                                  letterSpacing: 0.27,
                                  color: Colors.black,
                                ),
                              ),

                            ],
                          )
                      ),
                    );


                  }
                  else {

                    return Column(
                      children: <Widget>[
                        // Add a button to switch between sections
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                color: isSection1Active ? Colors.amber : Colors.grey,
                                borderRadius: BorderRadius.circular(18), // Adjust the radius as needed
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    isSection1Active = true;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.transparent,
                                  elevation: 0, // Set elevation to zero
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                ),
                                child: Row(
                                  children: const [
                                    Icon(Icons.apps), // Add an icon to the button
                                    SizedBox(width: 10), // Adjust the spacing between the icon and text
                                    Text("App Orders"),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 10), // Adjust the spacing between the buttons
                            Container(
                              decoration: BoxDecoration(
                                color: !isSection1Active ? Colors.amber : Colors.grey,
                                borderRadius: BorderRadius.circular(18), // Adjust the radius as needed
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    isSection1Active = false;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.transparent,
                                  elevation: 0, // Set elevation to zero
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                ),
                                child: Row(
                                  children: const [
                                    Icon(Icons.phone), // Add an icon to the button
                                    SizedBox(width: 10), // Adjust the spacing between the icon and text
                                    Text("Phone Orders"),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        // SizedBox(
                        //   height: 255,
                        //   child: PageView(
                        //     scrollDirection: Axis.vertical,
                        //     controller: PageController(initialPage: isSection1Active ? 0 : 1),
                        //     children: [
                        //       DesignCourseHomeScreenOffers(), // Section 1
                        //       DesignCourseHomeScreenOffers(), // Section 2
                        //     ],
                        //   ),
                        // ),

                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: Scrollbar(
                            isAlwaysShown: true, // This ensures that the scrollbar is always visible
                            child: PageView(
                              scrollDirection: Axis.vertical,
                              controller: PageController(initialPage: isSection1Active ? 0 : 1),
                              children: const [
                                DesignCourseHomeScreenOffers(), // App Order's
                                DesignCourseHomeScreenPhoneOrders(), // Phone Orders
                              ],
                            ),
                          ),
                        ),

                      ],
                    );



                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 4, left: 4,),
                        child: Container(
                          decoration: BoxDecoration(
                            //color: HexColor('#F8FAFB'),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          //height: 120,
                          //width: double.infinity,
                          child: DesignCourseHomeScreenOffers(),
                        ),
                      ),

                    );

                  }

                }
                return const SizedBox();
              },
            ),

          ],
        ),

      ),
    );
  }

  Future<String> _getInitials() async {
    String test = "";
    await FirebaseFirestore.instance
        .collection('biker')
        .doc(userid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      Map<String, dynamic> data =
      documentSnapshot.data() as Map<String, dynamic>;
      test = data['displayName'];

      List<String> names = data['displayName'].split(" ");
      String initials = "";
      int numWords = 2;

      if (numWords < names.length) {
        numWords = names.length;
      }
      for (var i = 0; i < numWords; i++) {
        initials += '${names[i][0]}';
      }
    });
    return test;
  }
  Widget buildUserNameProfile() => FutureBuilder<DocumentSnapshot>(
    future: users.doc(userid).get(),
    builder:
        (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(
          child: Container(
            alignment: Alignment.center,
            child: CircularProgressIndicator(color: Colors.amber,),
          ),
        );
      } else if (snapshot.hasData) {
        Map<String, dynamic> data =
        snapshot.data!.data() as Map<String, dynamic>;
        return InkWell(
          child: CircularProfileAvatar(
            //url.toString(),
            //data['ref'],
            "https://firebasestorage.googleapis.com/v0/b/the-adama-project.appspot.com/o/6522516.png?alt=media&token=f8aae7f8-c818-4b75-a689-5f74fa69442f",
            //sets image path, it should be a URL string. default value is empty string, if path is empty it will display only initials
            radius: 35,
            // sets radius, default 50.0
            backgroundColor: Colors.amberAccent,
            borderColor: Colors.amber,
            // sets background color, default Colors.white
            borderWidth: 6,
            // sets border, default 0.0
            initialsText: Text(
              data['displayName'].substring(0, 1).toUpperCase(),
              style: TextStyle(fontSize: 25, color: Colors.white),
            ),
            // sets initials text, set your own style, default Text('')

            // sets border color, default Colors.white
            elevation: 4.0,
            // sets elevation (shadow of the profile picture), default value is 0.0
            // foregroundColor: Colors.brown.withOpacity(0.5), //sets foreground colour, it works if showInitialTextAbovePicture = true , default Colors.transparent
            cacheImage: true,
            // allow widget to cache image against provided url
            imageFit: BoxFit.cover,
            onTap: () {
              Navigator.push<dynamic>(
                context,
                MaterialPageRoute<dynamic>(
                  builder: (BuildContext context) => const ProfilePage(),
                ),
              );
            },
            // sets on tap
            // showInitialTextAbovePicture: true, // setting it true will show initials text above profile picture, default false
          ),
        );
      }
      return const Text('');
    },
  );

  Widget buildRests() => FutureBuilder (
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
          // return Flexible(
          //   flex:1,
          //   //child: DesignCourseHomeScreen(catID: catID),
          //     child:buildCheckOUt(catID),
          // );
        }
      }
      // Displaying LoadingSpinner to indicate waiting state
      return const Center(
        child: CircularProgressIndicator(color: Colors.amber,),
      );
    },
    future: _getRestsData(),
  );
  // Future<String> getStorageUrlString() async {
  //   String downloadURL = await firebase_storage.FirebaseStorage.instance
  //       .ref('profile-pics/' + userid)
  //       .getDownloadURL();
  //   return downloadURL.toString();
  // }
  //
  Future<String> _getRestsData()   {
    return Future.delayed(const Duration(seconds: 2), () {
      return catID;
      // throw Exception("Custom Error");
    });
  }

}