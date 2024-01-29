import 'package:flutter/material.dart';
import 'package:pick_delivery_adama_biker/widget/menu_grid.dart';

import 'app_theme.dart';
import 'data/menu_provider.dart';
import 'model/menu.dart';

class DesignCourseHomeScreenMenu extends StatefulWidget {
  const DesignCourseHomeScreenMenu({
    Key? key,
    required this.rest,
    required this.catID,

  }) : super(key: key);

  final String rest;
  final String catID;

  @override
  _DesignCourseHomeScreenMenuState createState() => _DesignCourseHomeScreenMenuState();

}

class _DesignCourseHomeScreenMenuState extends State<DesignCourseHomeScreenMenu> {



  //var users = FirebaseFirestore.instance.collection('cuisine');
  //var userid = FirebaseAuth.instance.currentUser!.uid.toString();


  bool _isLoading = true;
  late final FirestoreMenuProvider _firestoreMenuProvider;
  late final FirestoreMenuProvider _filteredMenuProvider;



  String Name = "";

  @override
  void initState() {

    super.initState();
     _firestoreMenuProvider = FirestoreMenuProvider(widget.rest,widget.catID);
     _filteredMenuProvider = FirestoreMenuProvider(widget.rest,widget.catID);

    _firestoreMenuProvider.loadRestMenus();
     _filteredMenuProvider.loadFilteredMenus();



    //_firestoreMenuProvider.loadAllMenus();
    _isLoading = false;

  }
  @override
  void dispose() {
    _firestoreMenuProvider.dispose();
    _filteredMenuProvider.dispose();

    _firestoreMenuProvider.dispose();
    _filteredMenuProvider.dispose();


    super.dispose();
  }

  @override


  Widget build(BuildContext context) {
    if(widget.catID =="1"){
      return StreamBuilder<List<Menu>>(
        stream: _firestoreMenuProvider.allMenus,
        initialData: [],
        builder:
            (BuildContext context, AsyncSnapshot<List<Menu>> snapshot) {
          final _menus = snapshot.data!;

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
                        ? const CircularProgressIndicator(color: Colors.amber,)
                        : _menus.isNotEmpty
                        ? MenuGrid(
                      menu: _menus,

                    ) :Center(
                      child: Padding(
                        padding: EdgeInsets.all(40),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              child: CircularProgressIndicator(color: Colors.amber,),
                            ),
                          ],
                        ),
                      ),
                    )


                )
              ],
            ),
          );


        },
      );
    }
    else {
      return StreamBuilder<List<Menu>>(
        stream: _filteredMenuProvider.filteredMenus,
        initialData: [],
        builder:
            (BuildContext context, AsyncSnapshot<List<Menu>> snapshot) {
          final _menus = snapshot.data!;

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
                        ? const CircularProgressIndicator(color: Colors.amber,)
                        : _menus.isNotEmpty
                        ? MenuGrid(
                      menu: _menus,

                    ) :Center(
                      child: Padding(
                        padding: EdgeInsets.all(40),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              child: CircularProgressIndicator(color: Colors.amber,),
                            ),
                          ],
                        ),
                      ),
                    )


                )
              ],
            ),
          );


        },
      );
    }

  }


}


