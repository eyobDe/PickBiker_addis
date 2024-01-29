import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pick_delivery_adama_biker/loading.dart';

import 'app.dart';
import 'login_page.dart';

class AuthService {
  //Handles Auth
  handleAuth() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loading();
          }
          if (snapshot.hasData) {
            var users = FirebaseFirestore.instance.collection('biker');
            var userid = FirebaseAuth.instance.currentUser!.uid.toString();

          return FutureBuilder<DocumentSnapshot>(
              future: users.doc(userid).get(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshothere) {
                if (snapshothere.connectionState == ConnectionState.done) {
                  Map<String, dynamic> data =
                  snapshothere.data!.data() as Map<String, dynamic>;

                  //return DesignCourseHomeScreen();

                  return const SuperHomeScreen();

                }
                return const Loading();
              },
            );

          } else {
            // return const SelectLang();
            return MyLoginPage();

          }
        });
  }
  handleTest() {
    return Scaffold(
      body: Stack(
        children: const [


          Padding(
            padding: EdgeInsets.only(
              left: 13,right: 3,
              top: ( 2.65) ,
            ),
            child: Text(
              "Track your orders status",
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 16,
                letterSpacing: 0.27,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //Sign out
  signOut() {
    FirebaseAuth.instance.signOut();
  }

  //SignIn
  signIn(AuthCredential authCreds) {
    FirebaseAuth.instance.signInWithCredential(authCreds);
  }

  signInWithOTP(smsCode, verId) {
    AuthCredential authCreds =
        PhoneAuthProvider.credential(verificationId: verId, smsCode: smsCode);
    signIn(authCreds);
  }
}
