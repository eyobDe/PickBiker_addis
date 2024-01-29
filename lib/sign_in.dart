import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'app_theme.dart';
import 'authservice.dart';
import 'dashboard.dart';


class VerifyNumber extends StatefulWidget {
  const VerifyNumber({Key? key}) : super(key: key);

  @override
  _VerifyNumberState createState() => _VerifyNumberState();
}

class _VerifyNumberState extends State<VerifyNumber>
    with TickerProviderStateMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  FirebaseAuth auth = FirebaseAuth.instance;

  final TextEditingController controller = TextEditingController();
  String initialCountry = 'ET';
  //PhoneNumber number = PhoneNumber(isoCode: 'ET');

  late String pNumber, verificationId;
  late String smsCode='';
  bool codeSent = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: DesignCourseAppTheme.nearlyWhite,
      child: Scaffold(
        body: Column(
          children: [
            Container(
              height: 130,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25)),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment(0.8, 0.0),
                  colors: <Color>[Color(0xffee0000), Color(0xffeeee00)],
                ),
              ),
            ),
            const SizedBox(height: 25),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  color: DesignCourseAppTheme.notWhite,
                  boxShadow: [
                    BoxShadow(
                        color: DesignCourseAppTheme.notWhite,
                        offset: Offset(4, 4))
                  ]),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                    // InternationalPhoneNumberInput(
                    //   onInputChanged: (PhoneNumber number) {
                    //     //print(number.phoneNumber);
                    //     setState(() {
                    //       this.pNumber = number.phoneNumber!;
                    //     });
                    //   },
                    //   onInputValidated: (bool value) {
                    //     print(value);
                    //   },
                    //   selectorConfig: const SelectorConfig(
                    //     selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                    //   ),
                    //   ignoreBlank: false,
                    //   countrySelectorScrollControlled: false,
                    //   autoValidateMode: AutovalidateMode.disabled,
                    //   selectorTextStyle: const TextStyle(color: Colors.black),
                    //   initialValue: number,
                    //   textFieldController: controller,
                    //   formatInput: true,
                    //   keyboardType: const TextInputType.numberWithOptions(
                    //       signed: true, decimal: true),
                    // ),
                    //
                    Padding(
                            padding: EdgeInsets.only(left: 25.0, right: 25.0),
                            child: TextFormField(
                              keyboardType: TextInputType.phone,
                              decoration:
                                  const InputDecoration(hintText: 'Enter OTP'),
                              onChanged: (val) {
                                setState(() {
                                  this.smsCode = val;
                                });
                              },
                            )),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25))),
                              ),
                              // child: const Text('Continue'),
                              child: const Center(
                                  child: Text('Verify')),
                              onPressed: () {
                                verifyPhone(pNumber);
                                // Navigator.push<dynamic>(
                                //     context,
                                //     MaterialPageRoute<dynamic>(
                                //       builder: (BuildContext context) => OTP_Screen(),
                                //     ),
                                //   );
                              }),
                        ),
                        Expanded(
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(25))),
                              ),
                              // child: const Text('Continue'),
                              child: const Center(
                                  child: Text('login')),
                              onPressed: () {
                                verifyPhone(pNumber);
                                // Navigator.push<dynamic>(
                                //     context,
                                //     MaterialPageRoute<dynamic>(
                                //       builder: (BuildContext context) => OTP_Screen(),
                                //     ),
                                //   );
                              }),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  // void getPhoneNumber(String phoneNumber) async {
  //   PhoneNumber number =
  //       await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber, 'ET');
  //   setState(() {
  //     this.number = number;
  //   });
  // }

  Future<void> verifyPhone(String pNumber) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: pNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        // ANDROID ONLY!
        // Sign the user in (or link) with the auto-generated credential
          Navigator.push<dynamic>(
            context,
            MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => DashboardPage(),
            ),
          );
        await auth.signInWithCredential(credential);
        AuthService().signIn(credential);

      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }
        // Handle other errors
      },
      codeSent: (String verificationId, int? resendToken) async {
        this.verificationId = verificationId;

        // Update the UI - wait for the user to enter the SMS code
        //String smsCode = '123456';

        // Create a PhoneAuthCredential with the code
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: verificationId, smsCode: smsCode);

        // Sign the user in (or link) with the credential
        await auth.signInWithCredential(credential);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Auto-resolution timed out...
      },
    );
  }

}
