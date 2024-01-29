import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pick_delivery_adama_biker/widget/empty_listview.dart';
import 'package:pick_delivery_adama_biker/widget/feature_grid.dart';
import 'package:pick_delivery_adama_biker/widget/offers_grid.dart';
import 'package:pick_delivery_adama_biker/widget/order_grid.dart';
import 'package:pick_delivery_adama_biker/widget/phone_order_grid.dart';

import 'app_theme.dart';
import 'data/feature_provider.dart';
import 'data/offers_provider.dart';
import 'data/orders_provider.dart';
import 'data/phone_orders_provider.dart';
import 'model/feature.dart';
import 'model/offers.dart';
import 'model/order.dart';
import 'model/phoneOrders.dart';
//import 'model/phoneOrders.dart';

class DesignCourseHomeScreenPhoneOrders extends StatefulWidget {
  const DesignCourseHomeScreenPhoneOrders({Key? key}) : super(key: key);

  @override
  _DesignCourseHomeScreenOfferState createState() => _DesignCourseHomeScreenOfferState();
}

class _DesignCourseHomeScreenOfferState extends State<DesignCourseHomeScreenPhoneOrders> {
  CategoryType categoryType = CategoryType.ui;
  var users = FirebaseFirestore.instance.collection('biker');
  //var userid = FirebaseAuth.instance.currentUser!.uid.toString();

  bool _isLoading = true;
  bool _isEmpity = false;
  final PhoneFirestoreOrderProvider _firestorePhoneOrderProvider =
  PhoneFirestoreOrderProvider();

  String Name = "";

  @override
  void initState() {

    _firestorePhoneOrderProvider.loadAllOrders();
    _isLoading = false;
    //_isEmpity = true;

    super.initState();
  }
  @override
  void dispose() {
    _firestorePhoneOrderProvider.dispose();
    super.dispose();
  }

  @override

  Widget build(BuildContext context) {
    return StreamBuilder<List<PhoneOrders>>(
      stream: _firestorePhoneOrderProvider.allOrders,
      initialData: [],
      builder:
          (BuildContext context, AsyncSnapshot<List<PhoneOrders>> snapshot) {
        final _Orders = snapshot.data!;

        return Scaffold(

          body: Center(

            child: Container(
                decoration: BoxDecoration(

                  borderRadius: BorderRadius.circular(15),
                ),
                child: _isLoading ? const CircularProgressIndicator(color: Colors.amber,)
                    : _Orders.isNotEmpty ? PhoneOrderGrid(PhoneOrders: _Orders,)
                    :const CircularProgressIndicator(color: Colors.amber,)
            ),
          ),
        );
      },
    );
  }

}

enum CategoryType {
  ui,
  coding,
  basic,
}
