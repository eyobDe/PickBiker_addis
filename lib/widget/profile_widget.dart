import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pick_delivery_adama_biker/widget/star_rating.dart';
import '../app_theme.dart';

class ProfileWidget extends StatefulWidget {
  final bool isEdit;
  final String userid;
  final VoidCallback onClicked;

   const ProfileWidget({
    Key? key,
    required this.userid,
    this.isEdit = false,
    required this.onClicked,
  }) : super(key: key);

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {

  final DateTime _now = DateTime.now();
  DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);
   @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Center(
      child: Stack(
        children: [
          Column(
            children: <Widget>[
              AspectRatio(
                aspectRatio: 1.6,
                child: Container(
                  decoration: BoxDecoration(
                    //color: DesignCourseAppTheme.nearlyWhite,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(40.0),
                      bottomRight: Radius.circular(40.0),
                    ),

                    gradient: const LinearGradient(
                      colors: [
                        Colors.amber,
                        Colors.white,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomLeft,
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: DesignCourseAppTheme.grey.withOpacity(0.2),
                          offset: const Offset(1.1, 1.1),
                          blurRadius: 10.0),
                    ],
                  ),
                  child: Column(
                    children: [
                      buildProfilePicAndName(),
                    ],
                  ),
                  //child:buildProfilePicAndName(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


   Widget buildProfilePicAndName() => FutureBuilder<DocumentSnapshot>(
     future: FirebaseFirestore.instance.collection('biker').doc(widget.userid).get(),
     builder:
         (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

           var prevDay= getDate(_now.subtract(Duration(hours: _now.day)));
           var prevWeek= getDate(_now.subtract(Duration(days: _now.weekday)));
           var prevMonth = DateTime(_now.year, _now.month , 1);
           //var prevYear = DateTime(_now.year-1, 1, 1);
           if (snapshot.hasData) {
         Map<String, dynamic> data =
         snapshot.data!.data() as Map<String, dynamic>;
         return SafeArea(
           child: Column(
             children: [
               InkWell(
                 child: FutureBuilder<String>(
                   future: getStorageUrlString(),
                   builder: (BuildContext context, AsyncSnapshot<String> snapshotHere) {
                     return CircularProfileAvatar(
                       //url.toString(),
                       // url,
                       //data['ref'],
                       data['photo_url'],
                       cacheImage:true,
                       //sets image path, it should be a URL string. default value is empty string, if path is empty it will display only initials
                       radius: 40,
                       // sets radius, default 50.0
                       backgroundColor: Colors.amberAccent,
                       borderColor: Colors.amber,
                       // sets background color, default Colors.white
                       borderWidth: 7,
                       // sets border, default 0.0
                       initialsText: Text(
                         data['displayName'].substring(0,1).toUpperCase(),
                         style: TextStyle(fontSize: 27, color: Colors.white),
                       ),
                       // sets initials text, set your own style, default Text('')

                       // sets border color, default Colors.white
                       elevation: 4.0,
                       // sets elevation (shadow of the profile picture), default value is 0.0
                       // foregroundColor: Colors.brown.withOpacity(0.5), //sets foreground colour, it works if showInitialTextAbovePicture = true , default Colors.transparent
                       //cacheImage: true,
                       // allow widget to cache image against provided url
                       imageFit: BoxFit.cover,
                       onTap: widget.onClicked,
                       // showInitialTextAbovePicture: true, // setting it true will show initials text above profile picture, default false
                     );

                   },
                 ),
               ),
               const SizedBox(
                 height: 6,
               ),
               Center(
                 child: Container(
                   padding: const EdgeInsets.symmetric(horizontal: 1),
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.center,
                     children: [
                       Text(
                         "${data['displayName']}",
                         textAlign: TextAlign.center,
                         style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                       ),

                     ],
                   ),
                 ),
               ),
               StaticStarRating(
                 rating: data['rate'],
                 color: Colors.amber,
                 size: 15,
               ),
               Center(
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                   // crossAxisAlignment: CrossAxisAlignment.stretch,
                   children:  [
                     StreamBuilder<QuerySnapshot>(
                         stream: FirebaseFirestore.instance
                             .collection('order')
                             .where('confirm', isEqualTo: 3)
                             .where('created', isGreaterThanOrEqualTo: prevDay)
                             .where('biker', isEqualTo: widget.userid)
                             .snapshots(),

                         builder: (BuildContext context, snapshot) {
                           if (snapshot.hasError) {
                             //return Text(snapshot.error.toString());
                             if (kDebugMode) {
                               print(snapshot.error.toString());
                             }
                           } else if (snapshot.connectionState ==
                               ConnectionState.waiting) {
                             return Center(
                               child: Padding(
                                 padding: EdgeInsets.all(40),
                                 child: Column(
                                   mainAxisAlignment: MainAxisAlignment.center,
                                   children: [
                                     Container(
                                       alignment: Alignment.center,
                                       child: CircularProgressIndicator(),
                                     ),
                                   ],
                                 ),
                               ),
                             );
                           } else if (!snapshot.hasData) {
                             return const Text("No data ");
                           }
                           var ds = snapshot.data!.docs;
                           double sum = 0.0;

                           for(int i=0; i<ds.length;i++) {
                             sum+=(ds[i]['delivery_fee']).toDouble();
                           }


                           return Column(children: [
                             const Text(
                               "Today",
                               style: TextStyle(
                                 fontWeight: FontWeight.w600,
                                 fontSize: 14,
                                 letterSpacing: 0.27,
                                 color: DesignCourseAppTheme.nearlyBlack,
                               ),
                             ),
                             Text(((data['commissionInPercent'] / 100) * sum).toString()+ "ETB",
                               style: const TextStyle(
                                 fontWeight: FontWeight.w600,
                                 fontSize: 14,
                                 letterSpacing: 0.27,
                                 color: DesignCourseAppTheme.mainLogoColor,
                               ),
                             )
                           ],);

                         }),

                     StreamBuilder<QuerySnapshot>(
                         stream: FirebaseFirestore.instance
                             .collection('order')
                             .where('confirm', isEqualTo: 3)
                             .where('created', isGreaterThanOrEqualTo: prevWeek)
                             .where('biker', isEqualTo: widget.userid)
                             .snapshots(),



                         builder: (BuildContext context, snapshot) {
                           if (snapshot.hasError) {
                             //return Text(snapshot.error.toString());
                             if (kDebugMode) {
                               print(snapshot.error.toString());
                             }
                           } else if (snapshot.connectionState ==
                               ConnectionState.waiting) {
                             return Center(
                               child: Padding(
                                 padding: EdgeInsets.all(40),
                                 child: Column(
                                   mainAxisAlignment: MainAxisAlignment.center,
                                   children: [
                                     Container(
                                       alignment: Alignment.center,
                                       child: CircularProgressIndicator(),
                                     ),
                                   ],
                                 ),
                               ),
                             );
                           } else if (!snapshot.hasData) {
                             return const Text("No data ");
                           }
                           var ds = snapshot.data!.docs;
                           double sum = 0.0;

                           for(int i=0; i<ds.length;i++) {
                             sum+=(ds[i]['delivery_fee']).toDouble();
                           }

                           return Column(children: [
                             const Text(
                               "This week",
                               style: TextStyle(
                                 fontWeight: FontWeight.w600,
                                 fontSize: 14,
                                 letterSpacing: 0.27,
                                 color: DesignCourseAppTheme.nearlyBlack,
                               ),
                             ),
                             Text(((data['commissionInPercent'] / 100)*sum).toString()+"ETB",
                               style: TextStyle(
                                 fontWeight: FontWeight.w600,
                                 fontSize: 14,
                                 letterSpacing: 0.27,
                                 color: DesignCourseAppTheme.mainLogoColor,
                               ),
                             )
                           ],);

                         }),

                     StreamBuilder<QuerySnapshot>(
                         stream: FirebaseFirestore.instance
                             .collection('order')
                             .where('confirm', isEqualTo: 3)
                             .where('created', isGreaterThanOrEqualTo: prevMonth)
                             .where('biker', isEqualTo:widget.userid)
                             .snapshots(),



                         builder: (BuildContext context, snapshot) {
                           if (snapshot.hasError) {
                             if (kDebugMode) {
                               print(snapshot.error.toString());
                             }
                           } else if (snapshot.connectionState ==
                               ConnectionState.waiting) {
                             return Center(
                               child: Padding(
                                 padding: EdgeInsets.all(40),
                                 child: Column(
                                   mainAxisAlignment: MainAxisAlignment.center,
                                   children: [
                                     Container(
                                       alignment: Alignment.center,
                                       child: const CircularProgressIndicator(),
                                     ),
                                   ],
                                 ),
                               ),
                             );
                           } else if (!snapshot.hasData) {
                             return const Text("No data ");
                           }
                           var ds = snapshot.data!.docs;
                           double sum = 0.0;

                           for(int i=0; i<ds.length;i++) {
                             sum+=(ds[i]['delivery_fee']).toDouble();
                           }



                           return Column(children: [
                             const Text(
                               "This month",
                               style: TextStyle(
                                 fontWeight: FontWeight.w600,
                                 fontSize: 14,
                                 letterSpacing: 0.27,
                                 color: DesignCourseAppTheme.nearlyBlack,
                               ),
                             ),
                             Text(((data['commissionInPercent'] / 100)*sum).toString()+"ETB",
                               style: TextStyle(
                                 fontWeight: FontWeight.w600,
                                 fontSize: 14,
                                 letterSpacing: 0.27,
                                 color: DesignCourseAppTheme.mainLogoColor,
                               ),
                             )
                           ],);

                         }),
                   ],
                 ),
               ),

             ],
           ),
         );
       }
       return const SizedBox();
     },
   );


  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) => ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );
  Future<String> getStorageUrlString() async {
    String downloadURL = await firebase_storage.FirebaseStorage.instance
        .ref('profile-pics/' + widget.userid)
        .getDownloadURL();
    return downloadURL.toString();
  }
}
