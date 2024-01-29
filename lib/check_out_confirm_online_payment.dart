import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../home_for_orders.dart';

class CheckOutOnlinePayment extends StatefulWidget {
  const CheckOutOnlinePayment({Key? key}) : super(key: key);

  @override
  _CheckOutOnlinePaymentState createState() => _CheckOutOnlinePaymentState();
}

class _CheckOutOnlinePaymentState extends State<CheckOutOnlinePayment> {

  var args;


  @override
  void initState() {


    Future.delayed(Duration.zero,(){
      setState(() {
        if(ModalRoute.of(context)?.settings.arguments!= null)
        {
          args=ModalRoute.of(context)?.settings.arguments;
          print('message after payment');
          print(args['message']);

        }
      });

    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [


          Padding(
            padding: EdgeInsets.only(
              left: 13,right: 3,
              top: (MediaQuery.of(context).size.height / 2.65) ,
            ),
            child: const Text(
              "Track your orders status",
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 16,
                letterSpacing: 0.27,
                color: DesignCourseAppTheme.delivery,
              ),
            ),
          ),
        ],
      ),
    );
  }

}
