import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pick_delivery_adama_biker/widget/empty_listview.dart';
import 'package:pick_delivery_adama_biker/widget/feature_grid.dart';
import 'package:pick_delivery_adama_biker/widget/offers_grid.dart';

import 'app_theme.dart';
import 'data/feature_provider.dart';
import 'data/offers_provider.dart';
import 'model/feature.dart';
import 'model/offers.dart';

class DesignCourseHomeScreenOffers extends StatefulWidget {
  const DesignCourseHomeScreenOffers({Key? key}) : super(key: key);

  @override
  _DesignCourseHomeScreenOfferState createState() => _DesignCourseHomeScreenOfferState();
}

class _DesignCourseHomeScreenOfferState extends State<DesignCourseHomeScreenOffers> {
  CategoryType categoryType = CategoryType.ui;
  var users = FirebaseFirestore.instance.collection('biker');
  //var userid = FirebaseAuth.instance.currentUser!.uid.toString();

  bool _isLoading = true;
  bool _isEmpity = false;
  final FirestoreOffersProvider _firestoreOfferProvider =
  FirestoreOffersProvider();

  String Name = "";

  @override
  void initState() {

    _firestoreOfferProvider.loadAllOffers();
    _isLoading = false;
    //_isEmpity = true;

    super.initState();
  }
  @override
  void dispose() {
    _firestoreOfferProvider.dispose();
    super.dispose();
  }

  @override

  Widget build(BuildContext context) {
    return StreamBuilder<List<Offers>>(
      stream: _firestoreOfferProvider.allOffers,
      initialData: [],
      builder:
          (BuildContext context, AsyncSnapshot<List<Offers>> snapshot) {
        final _Offers = snapshot.data!;


        return Scaffold(

          body: Center(

            child: Container(
              decoration: BoxDecoration(
                //color: HexColor('#F8FAFB'),
                borderRadius: BorderRadius.circular(15),

                // boxShadow: <BoxShadow>[
                //   BoxShadow(
                //       color: DesignCourseAppTheme.notWhite
                //           .withOpacity(0.1),
                //       offset: const Offset(1, 1),
                //       blurRadius: 4.0),
                // ],

              ),


              child: _isLoading ? const CircularProgressIndicator(color: Colors.amber,)
                  : _Offers.isNotEmpty ? OfferGrid(Offers: _Offers,)
                  :const CircularProgressIndicator(color: Colors.amber,)

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

enum CategoryType {
  ui,
  coding,
  basic,
}
