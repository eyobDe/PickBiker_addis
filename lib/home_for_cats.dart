import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:pick_delivery_adama_biker/widget/order_grid.dart';
import 'package:pick_delivery_adama_biker/widget/restaurant_page_details.dart';

import 'app_theme.dart';
import 'data/orders_provider.dart';
import 'model/order.dart';

class HomeForCats extends StatefulWidget {
  final List<String> categories;

  const HomeForCats(this.categories, {
    Key? key,
  }) : super(key: key);


  @override
  _DesignCourseHomeScreenMenuState createState() => _DesignCourseHomeScreenMenuState();

}

class _DesignCourseHomeScreenMenuState extends State<HomeForCats> {

  CollectionReference cats = FirebaseFirestore.instance.collection('category');
  String catID="1";
  List<MultiSelectCard> currencyItems = [];

  @override
  void initState() {
    _getCatsData();
    setdata();
    currencyItems.insert(0, MultiSelectCard(value:'1', label: "All"));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void setdata(){

    for (int i = 0; i < widget.categories.length; i++) {
      FirebaseFirestore.instance
          .collection('category')
          .doc(widget.categories[i])
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        Map<String, dynamic> data =
        documentSnapshot.data() as Map<String, dynamic>;

        if (documentSnapshot.exists) {
          //print('Document data: ${documentSnapshot.data()}');

          currencyItems.add(MultiSelectCard(value:widget.categories[i], label:data['cat_name']));

          //Set the relevant data to variables as needed
        } else {
          print('Document does not exist on the database');
        }
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding:  EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: (MediaQuery.of(context).size.height / 3.2),


      ),

      child: FutureBuilder<MultiSelectContainer>(
        future: _getCatsData(),
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.waiting
              ? const CircularProgressIndicator(color: Colors.amber,)
              : snapshot.data!;
          //
          // MultiSelectContainer(
          //     singleSelectedItem:true,
          //     items:currencyItems.toList(),
          //     onChange: (allSelectedItems, selectedItem) {
          //       //categories=allSelectedItems;
          //       setState(() {
          //         catID=selectedItem.toString();
          //       });
          //
          //     });
        },
      ),


    );

  }

  Future<MultiSelectContainer> _getCatsData()   {
    return Future.delayed(const Duration(seconds: 2), () {
      return MultiSelectContainer(
          singleSelectedItem:true,
          items:currencyItems.toList(),
          onChange: (allSelectedItems, selectedItem) {
            //categories=allSelectedItems;
            //RestaurantDetailsState.updateProfile("j");
            // setState(() {
            //   catID="tst";
            // });
            //  updateProfile("tst");



          });
      // throw Exception("Custom Error");
    });

  }

}


