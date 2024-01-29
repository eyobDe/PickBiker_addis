// import 'package:easy_localization/src/public_ext.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:intl_phone_field/intl_phone_field.dart';
// //import 'package:intl_phone_number_input/intl_phone_number_input.dart';
// import 'package:pick_delivery_adama_biker/register.dart';
//
//
// class MyLoginPage extends StatefulWidget {
//   @override
//   _MyLoginPageState createState() => _MyLoginPageState();
// }
//
// class _MyLoginPageState extends State<MyLoginPage> {
//   FirebaseAuth firebaseAuth = FirebaseAuth.instance;
//   //SmsAutoFill smsAutoFill = SmsAutoFill();
//   late String strVerificationId;
//   final globalKey = GlobalKey<ScaffoldState>();
//
//   TextEditingController phoneNumEditingController = TextEditingController();
//   TextEditingController smsEditingController = TextEditingController();
//
//
//   String initialCountry = 'ET';
//   //PhoneNumber number = PhoneNumber(isoCode: 'ET');
//
//   late String pNumber, verificationId;
//   late String smsCode='';
//
//   bool showVerifyNumberWidget = true;
//   bool showVerificationCodeWidget = false;
//   bool showSuccessWidget = false;
//   bool phonevalidated=false;
//
//   @override
//   void initState() {
//     super.initState();
//     getCurrentNumber();
//   }
//
//   getCurrentNumber() async {
//   //   phoneNumEditingController.text = (await smsAutoFill.hint)!;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         key: globalKey,
//         backgroundColor: Colors.white,
//         resizeToAvoidBottomInset: false,
//         body: Padding(
//
//           padding: EdgeInsets.only( left: 38, right: 38),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: <Widget>[
//               SizedBox(
//                 height: 100,
//               ),
//               Container(
//                 alignment: Alignment.center,
//
//
//                 child: (
//
//                     Image.asset(
//                       'assets/images/PickPro Louncher Foreground With Text Name.png',
//                       height: 220,
//                       width: 220,
//                     )
//                 ),
//               ),
//               // SizedBox(
//               //   height: 25,
//               // ),
//
//
//               IntlPhoneField(
//                 decoration: const InputDecoration(
//                   labelText: 'Phone Number',
//                   border: OutlineInputBorder(
//                     borderSide: BorderSide(),
//                   ),
//                 ),
//                 initialCountryCode: 'ET',
//                 onChanged: (phone) {
//                   if (kDebugMode) {
//                     print(phone.completeNumber);
//                   }
//                   setState(() {
//                     this.pNumber = phone.completeNumber;
//                   });
//                 },
//               ),
//
//               // InternationalPhoneNumberInput(
//               //   onInputChanged: (PhoneNumber number) {
//               //     //print(number.phoneNumber);
//               //     setState(() {
//               //       this.pNumber = number.phoneNumber!;
//               //     });
//               //   },
//               //   onInputValidated: (bool value) {
//               //     print(value);
//               //     setState(() {
//               //       phonevalidated=value;
//               //     });
//               //   },
//               //   hintText:'phoneno'.tr(),
//               //   errorMessage:'invalidno'.tr(),
//               //   selectorConfig: const SelectorConfig(
//               //     selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
//               //   ),
//               //   ignoreBlank: false,
//               //   countrySelectorScrollControlled: false,
//               //   autoValidateMode: AutovalidateMode.disabled,
//               //   selectorTextStyle: const TextStyle(color: Colors.black),
//               //   initialValue: number,
//               //   textFieldController: phoneNumEditingController,
//               //   formatInput: true,
//               //   keyboardType: const TextInputType.numberWithOptions(
//               //       signed: true, decimal: true),
//               // ),
//
//               SizedBox(
//                 height: 16,
//               ),
//               if(showVerifyNumberWidget) Container(
//                 padding: const EdgeInsets.symmetric(vertical: 12.0),
//                 alignment: Alignment.center,
//                 child:Row(
//                   children: [
//                     SizedBox(
//                       width: 176,
//                     ),
//                     Expanded(
//
//                       child:ElevatedButton(
//
//                         style: ButtonStyle(
//                             backgroundColor: MaterialStateProperty.all(Colors.amber),
//
//                             shape: MaterialStateProperty.all<
//                                 RoundedRectangleBorder>(
//                                 RoundedRectangleBorder(
//                                   borderRadius:
//                                   BorderRadius.circular(
//                                       35.0),
//                                 ))),
//
//                         onPressed: () async {
//
//                           if(phonevalidated==true){
//                             phoneNumberVerification();
//                             FocusScope.of(context).unfocus();
//                           }
//                           if(phonevalidated==false){
//                             showAlertDialogToVerifyNum(this.context);
//                           }
//
//                         },
//                         child: Text("verify".tr(),
//                           style: TextStyle(
//                             color: Colors.white,
//                           ),),
//                       ),
//                     ),
//                   ],
//                 ),
//
//               ),
//               if(showVerificationCodeWidget) TextFormField(
//                 controller: smsEditingController,
//                 keyboardType: const TextInputType.numberWithOptions(
//                     signed: true, decimal: true),
//                 decoration: InputDecoration(
//                   labelText: "verifCode".tr(),
//                 ),
//               ),
//               SizedBox(
//                 height: 25,
//               ),
//               if(showVerificationCodeWidget) Container(
//                 padding: const EdgeInsets.only(top: 16.0),
//                 alignment: Alignment.center,
//                 child:ElevatedButton(
//
//                   style: ButtonStyle(
//                       backgroundColor: MaterialStateProperty.all(Colors.amber),
//
//                       shape: MaterialStateProperty.all<
//                           RoundedRectangleBorder>(
//                           RoundedRectangleBorder(
//                             borderRadius:
//                             BorderRadius.circular(
//                                 35.0),
//                           ))),
//                   onPressed: () async {
//                     signInWithPhoneNumber();
//                   },
//                   child: Text("singnIn".tr().toUpperCase()),
//                 ),
//
//               ),
//               if(showSuccessWidget)
//                 const Text('', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold))
//             ],
//           ),
//         ));
//   }
//   showAlertDialogToVerifyNum(BuildContext context) {
//     // set up the buttons
//     Widget cancelButton = TextButton(
//       child: Text(
//         "\u{2713} "+"ok".tr().toUpperCase(),
//         style: TextStyle(
//           fontWeight: FontWeight.w900,
//           fontSize: 14,
//           letterSpacing: 0.27,
//           color: Colors.amber,
//         ),
//       ),
//       onPressed: () {
//         Navigator.of(context).pop();
//       },
//     );
//     // set up the AlertDialog
//     AlertDialog alert = AlertDialog(
//       title: Text("wrongPhoneTi".tr()),
//       content: Text("wrongPhoneDesc".tr()),
//       actions: [
//         cancelButton,
//       ],
//     );
//     // show the dialog
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return alert;
//       },
//     );
//   }
//
//   Future<void> phoneNumberVerification() async {
//
//     displayMessage('We are sending you an SMS verification code please wait...');
//
//     setState(() {
//       showVerifyNumberWidget = false;
//       showVerificationCodeWidget = true;
//     });
//
//     PhoneVerificationCompleted phoneVerificationCompleted =
//         (PhoneAuthCredential phoneAuthCredential) async {
//       await firebaseAuth.signInWithCredential(phoneAuthCredential);
//
//       displayMessage("Your phone is now auto verified");
//
//       Navigator.push<dynamic>(
//         context,
//         MaterialPageRoute<dynamic>(
//           builder: (BuildContext context) => const RegisterForm(),
//         ),
//       );
//
//       setState(() {
//         showVerifyNumberWidget = true;
//         showVerificationCodeWidget = false;
//         //showSuccessWidget = true;
//       });
//     };
//
//     PhoneVerificationFailed phoneVerificationFailed =
//         (FirebaseAuthException authException) {
//       displayMessage('Phone number verification is failed. Code: ${authException.code}. Message: ${authException.message}');
//       // displayMessage('failedVerify'.tr());
//     };
//
//     PhoneCodeSent phoneCodeSent =
//         (String verificationId,int? resendToken) async {
//       displayMessage('We have just sent you the verification code, please check you SMS');
//       strVerificationId = verificationId;
//       // setState(() {
//       //   showVerifyNumberWidget = false;
//       //   showVerificationCodeWidget = true;
//       // });
//     };
//
//     PhoneCodeAutoRetrievalTimeout phoneCodeAutoRetrievalTimeout =
//         (String verificationId) {
//       // displayMessage("verification code: " + verificationId);
//       strVerificationId = verificationId;
//       setState(() {
//         showVerifyNumberWidget = false;
//         showVerificationCodeWidget = true;
//       });
//     };
//
//     try {
//       await firebaseAuth.verifyPhoneNumber(
//           phoneNumber: pNumber,
//           timeout: const Duration(seconds: 5),
//           verificationCompleted: phoneVerificationCompleted,
//           verificationFailed: phoneVerificationFailed,
//           codeSent: phoneCodeSent,
//           codeAutoRetrievalTimeout: phoneCodeAutoRetrievalTimeout);
//     } catch (e) {
//       displayMessage("Failed to Verify Phone Number: ${e}");
//       // displayMessage('failedVerify'.tr());
//     }
//   }
//
//   void displayMessage(String message) {
//     globalKey.currentState!.showSnackBar(
//         SnackBar(
//             content:
//                 Text(message),
//                 duration: const Duration(seconds: 8),
//         )
//     );
//   }
//
//   void signInWithPhoneNumber() async {
//     try {
//       final AuthCredential credential = PhoneAuthProvider.credential(
//         verificationId: strVerificationId,
//         smsCode: smsEditingController.text,
//       );
//
//       final User? user = (await firebaseAuth.signInWithCredential(credential)).user;
//
//      // displayMessage("Successfully signed in UID: ${user!.uid}");
//
//         Navigator.push<dynamic>(
//           context,
//           MaterialPageRoute<dynamic>(
//             builder: (BuildContext context) => const RegisterForm(),
//           ),
//         );
//
//       setState(() {
//         showVerificationCodeWidget = false;
//         showSuccessWidget = true;
//       });
//     } catch (e) {
//       displayMessage("Failed to sign in: " + e.toString());
//       //displayMessage('failedVerify'.tr());
//     }
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:pick_delivery_adama_biker/register.dart';
import 'package:intl_phone_field/intl_phone_field.dart';


class MyLoginPage extends StatefulWidget {
  @override
  _MyLoginPageState createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  //SmsAutoFill smsAutoFill = SmsAutoFill();
  late String strVerificationId;
  final globalKey = GlobalKey<ScaffoldState>();

  TextEditingController phoneNumEditingController = TextEditingController();
  TextEditingController smsEditingController = TextEditingController();


  String initialCountry = 'ET';
  //PhoneNumber number = PhoneNumber(isoCode: 'ET');

  late String pNumber, verificationId;
  late String smsCode='';

  bool showVerifyNumberWidget = true;
  bool showVerificationCodeWidget = false;
  bool showSuccessWidget = false;
  bool phonevalidated=false;

  @override
  void initState() {
    super.initState();
    getCurrentNumber();
  }

  getCurrentNumber() async {
    //   phoneNumEditingController.text = (await smsAutoFill.hint)!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: globalKey,
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: Padding(

          padding: EdgeInsets.only( left: 38, right: 38),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 100,
              ),
              Container(
                alignment: Alignment.center,


                child: (

                    Image.asset(
                      'assets/images/Logo final2.png',
                      height: 220,
                      width: 220,)
                ),
              ),
              const SizedBox(
                height: 15,
              ),

              const Text("Please verify your phone number ",
                textAlign: TextAlign.left,

                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15

                ),),
              const SizedBox(
                height: 8,
              ),
              IntlPhoneField(
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(),
                  ),
                ),
                initialCountryCode: 'ET',
                onChanged: (phone) {
                  if (kDebugMode) {
                    print(phone.completeNumber);
                  }
                  setState(() {
                    pNumber = phone.completeNumber;
                  });
                },
              ),

              // InternationalPhoneNumberInput(
              //   onInputChanged: (PhoneNumber number) {
              //     //print(number.phoneNumber);
              //     setState(() {
              //       this.pNumber = number.phoneNumber!;
              //     });
              //   },
              //   onInputValidated: (bool value) {
              //     print(value);
              //     setState(() {
              //       phonevalidated=value;
              //     });
              //   },
              //   hintText:'phoneno',
              //   errorMessage:'invalidno',
              //   selectorConfig: const SelectorConfig(
              //     selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
              //   ),
              //   ignoreBlank: false,
              //   countrySelectorScrollControlled: false,
              //   autoValidateMode: AutovalidateMode.disabled,
              //   selectorTextStyle: const TextStyle(color: Colors.black),
              //   initialValue: number,
              //   textFieldController: phoneNumEditingController,
              //   formatInput: true,
              //   keyboardType: const TextInputType.numberWithOptions(
              //       signed: true, decimal: true),
              // ),

              const SizedBox(
                height: 10,
              ),
              if(showVerifyNumberWidget) Container(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                alignment: Alignment.center,
                child:Row(
                  children: [
                    const SizedBox(
                      width: 176,
                    ),
                    Expanded(

                      child:ElevatedButton(

                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.amber),

                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(
                                      35.0),
                                ))),

                        onPressed: () async {

                          phoneNumberVerification();
                          // if(phonevalidated==true){
                          //   phoneNumberVerification();
                          //   FocusScope.of(context).unfocus();
                          // }
                          // if(phonevalidated==false){
                          //   showAlertDialogToVerifyNum(this.context);
                          // }
                        },
                        child: const Text("Verify",
                          style: TextStyle(
                            color: Colors.white,
                          ),),
                      ),
                    ),
                  ],
                ),

              ),
              if(showVerificationCodeWidget) TextFormField(
                controller: smsEditingController,
                keyboardType: const TextInputType.numberWithOptions(
                    signed: true, decimal: true),
                decoration: const InputDecoration(
                  labelText: "Enter verification code",
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              if(showVerificationCodeWidget) Container(
                padding: const EdgeInsets.only(top: 16.0),
                alignment: Alignment.center,
                child:ElevatedButton(

                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.amber),

                      shape: MaterialStateProperty.all<
                          RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(
                                35.0),
                          ))),
                  onPressed: () async {
                    signInWithPhoneNumber();
                  },
                  child: Text("sing in ".toUpperCase()),
                ),

              ),
              if(showSuccessWidget)
                const Text('', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold))
            ],
          ),
        ));
  }
  showAlertDialogToVerifyNum(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text(
        "\u{2713} "+"ok".toUpperCase(),
        style: const TextStyle(
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
      title: Text("wrongPhoneTi"),
      content: Text("wrongPhoneDesc"),
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

  Future<void> phoneNumberVerification() async {

    displayMessage('We are sending you an SMS verification code please wait...');

    setState(() {
      showVerifyNumberWidget = false;
      showVerificationCodeWidget = true;
    });

    PhoneVerificationCompleted phoneVerificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {
      await firebaseAuth.signInWithCredential(phoneAuthCredential);

      displayMessage("Your phone is now auto verified");

      Navigator.push<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => const RegisterForm(),
        ),
      );

      setState(() {
        showVerifyNumberWidget = true;
        showVerificationCodeWidget = false;
        //showSuccessWidget = true;
      });
    };

    PhoneVerificationFailed phoneVerificationFailed =
        (FirebaseAuthException authException) {
      displayMessage('Phone number verification is failed. Code: ${authException.code}. Message: ${authException.message}');
      // displayMessage('failedVerify'.tr());
    };

    PhoneCodeSent phoneCodeSent =
        (String verificationId,int? resendToken) async {
      displayMessage('We have just sent you the verification code, please check you SMS');
      strVerificationId = verificationId;
      // setState(() {
      //   showVerifyNumberWidget = false;
      //   showVerificationCodeWidget = true;
      // });
    };

    PhoneCodeAutoRetrievalTimeout phoneCodeAutoRetrievalTimeout =
        (String verificationId) {
      // displayMessage("verification code: " + verificationId);
      strVerificationId = verificationId;
      setState(() {
        showVerifyNumberWidget = false;
        showVerificationCodeWidget = true;
      });
    };

    try {
      await firebaseAuth.verifyPhoneNumber(
          phoneNumber: pNumber,
          timeout: const Duration(seconds: 5),
          verificationCompleted: phoneVerificationCompleted,
          verificationFailed: phoneVerificationFailed,
          codeSent: phoneCodeSent,
          codeAutoRetrievalTimeout: phoneCodeAutoRetrievalTimeout);
    } catch (e) {
      displayMessage("Failed to Verify Phone Number: ${e}");
      // displayMessage('failedVerify'.tr());
    }
  }

  void displayMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
          Text(message),
          duration: const Duration(seconds: 8),
        )
    );
  }

  void signInWithPhoneNumber() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: strVerificationId,
        smsCode: smsEditingController.text,
      );

      final User? user = (await firebaseAuth.signInWithCredential(credential)).user;

      // displayMessage("Successfully signed in UID: ${user!.uid}");

      Navigator.push<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => const RegisterForm(),
        ),
      );

      setState(() {
        showVerificationCodeWidget = false;
        showSuccessWidget = true;
      });
    } catch (e) {
      displayMessage("Failed to sign in: " + e.toString());
      //displayMessage('failedVerify'.tr());
    }
  }
}