import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';

import 'app.dart';
import 'app_theme.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  var users = FirebaseFirestore.instance.collection('biker');
  var userid = FirebaseAuth.instance.currentUser!.uid.toString();

  //final _formKey = GlobalKey<FormBuilderState>();


  TextEditingController nameController = TextEditingController();
  Position? _currentPosition;

  Geolocator geolocator = Geolocator();

  final geo = Geoflutterfire();

  bool isSwitched = false;
  int isPro = 1;
  var textValue = 'no';

  List<int> services = [];

  @override
  void initState() {
    _getCurrentLocation();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _getCurrentLocation();
  }

  void toggleSwitch(bool value) {
    if (isSwitched == false) {
      setState(() {
        isSwitched = true;
        textValue = 'yes';
        isPro = 0;
      });
    } else {
      setState(() {
        isSwitched = false;
        textValue = 'no';
        isPro = 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: DesignCourseAppTheme.nearlyWhite,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            SizedBox(
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.1,
            ),

            Padding(
              padding: const EdgeInsets.only( left: 38, right: 38),
              child: Column(
                children: <Widget>[
                  Center(
                    child: (

                        Image.asset('assets/images/PickPro Louncher Foreground With Text Name.png',
                          height: 220,
                          width: 220,)
                    ),
                  ),

                  // Row(
                  //   children: [
                  //     Text(
                  //       "Pick",
                  //       textAlign: TextAlign.center,
                  //       style: TextStyle(
                  //         fontWeight: FontWeight.bold,
                  //         fontSize: 30,
                  //         letterSpacing: 0.27,
                  //         color: DesignCourseAppTheme.mainLogoColor,
                  //       ),
                  //     ),
                  //     Text(
                  //       "Delivery",
                  //       textAlign: TextAlign.center,
                  //       style: TextStyle(
                  //         fontWeight: FontWeight.bold,
                  //         fontSize: 30,
                  //         letterSpacing: 0.27,
                  //         color: DesignCourseAppTheme.delivery,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  //SizedBox(height: 12),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Your name",
                    ),
                    controller: nameController,
                  ),
                  SizedBox(height: 12.0),

                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 166,
                      ),
                      Expanded(
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                              MaterialStateProperty.all(Colors.amber),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(35.0),
                                  ))),
                          onPressed: () async {
                            if (nameController.text.isNotEmpty) {
                              userSetup(nameController.text);
                            } else if (nameController.text.isEmpty) {
                              showAlertDialogToVerifyName(this.context);
                            }
                          },
                          child: const Text(
                            "Register",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _getCurrentLocation() {
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
    }).catchError((e) {
      print(e);
    });
  }

  showAlertDialogToVerifyName(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text(
        "\u{2713} " + "ok".tr().toUpperCase(),
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 14,
          letterSpacing: 0.27,
          color: Colors.amber,
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("wrongNameTi".tr()),
      content: Text("wrongNameDesc".tr()),
      actions: [
        cancelButton,
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

  userSetup(String displayName) {
    DateTime _now = DateTime.now();
    CollectionReference users = FirebaseFirestore.instance.collection('biker');

    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid.toString();
    String phoneNumber = auth.currentUser!.phoneNumber!;
    users.doc(uid).set({
      'displayName': displayName,
      'uid': uid,
      'joined': _now,
      'phoneNumber': phoneNumber,
      'ref': "",
      'rate': 2.5,
      'status': 0,
      'totalDeliveries': 0,
      'totalIncome': 0,
      'commissionInPercent': 50,
      'photo_url': "https://firebasestorage.googleapis.com/v0/b/the-adama-project.appspot.com/o/bikerImage.jpg?alt=media&token=faeba148-1ac0-4ff5-8b5f-3277d662ce0a",
      'area': "",

    }).then((value) =>
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const SuperHomeScreen()),
        ),
    );

    // GeoFirePoint myLocation = geo.point(
    //     latitude: _currentPosition!.latitude,
    //     longitude: _currentPosition!.longitude);
    // if (_currentPosition != null) {
    //   users.doc(userid).update({'location': myLocation.data}).then((value) =>
    //       Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //             builder: (context) =>
    //                 DesignCourseHomeScreen()),
    //       ),
    //   );
    // }

  }
}
