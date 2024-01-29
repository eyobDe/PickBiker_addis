import 'package:flutter/material.dart';
import 'package:pick_delivery_adama_biker/widget/order_grid.dart';

import 'app_theme.dart';
import 'data/orders_provider.dart';
import 'model/order.dart';

class HomeForOrders extends StatefulWidget {
  const HomeForOrders({
    Key? key,


  }) : super(key: key);



  @override
  _DesignCourseHomeScreenMenuState createState() => _DesignCourseHomeScreenMenuState();

}

class _DesignCourseHomeScreenMenuState extends State<HomeForOrders> {



  //var users = FirebaseFirestore.instance.collection('cuisine');
  //var userid = FirebaseAuth.instance.currentUser!.uid.toString();


  bool _isLoading = true;
  final FirestoreOrderProvider _firestoreOrderProvider =
  FirestoreOrderProvider();



  String Name = "";

  @override
  void initState() {

    _firestoreOrderProvider.loadOrderdMenus();
    //_firestoreMenuProvider.loadAllMenus();
    _isLoading = false;
    super.initState();
  }
  @override
  void dispose() {
    _firestoreOrderProvider.dispose();
    super.dispose();
  }

  @override


  Widget build(BuildContext context) {
    return StreamBuilder<List<Order>>(
      stream: _firestoreOrderProvider.allMenus,
      initialData: [],
      builder:
          (BuildContext context, AsyncSnapshot<List<Order>> snapshot) {
        final _orders = snapshot.data!;

        return  SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                  decoration: BoxDecoration(
                    //color: HexColor('#F8FAFB'),
                    borderRadius: BorderRadius.circular(35),

                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: DesignCourseAppTheme.notWhite
                              .withOpacity(0.1),
                          offset: const Offset(1, 1),
                          blurRadius: 4.0),
                    ],

                  ),

                  child: _isLoading
                      ?  const CircularProgressIndicator(color: Colors.amber,)
                      : _orders.isNotEmpty
                      ? OrderGrid(
                    order: _orders,

                  ) :Center(
                    child: Padding(
                      padding: EdgeInsets.all(40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            child: const CircularProgressIndicator(color: Colors.amber,),
                          ),
                        ],
                      ),
                    ),
                  )

                // :CircularProgressIndicator(color: Colors.amber,),

                //     : EmptyListView(
                //   child: Text('FriendlyEats has no restaurants yet!'),
                //   //onPressed: _onAddRandomRestaurantsPressed,
                // ),
              )
            ],
          ),
        );


      },
    );
  }


}


