import 'package:flutter/material.dart';
import 'package:pick_delivery_adama_biker/pages/profile_page.dart';

//import 'home_page.dart';
import 'app_extended.dart';
import 'check_out_confirm_online_payment.dart';
import 'restaurant_page.dart';

class SuperHomeScreen extends StatelessWidget {
  const SuperHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/checkOutOnlinePayment':(context)=> const ProfilePage()
      },

      home:  const AppExtended(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case RestaurantPage.route:
            final RestaurantPageArguments arguments =
            settings.arguments as RestaurantPageArguments;
            return MaterialPageRoute(
              builder: (context) => RestaurantPage(
                restaurant: arguments.restaurant,

              ),
            );

          default:
            return MaterialPageRoute(builder: (context) => const AppExtended());
        }
      },
    );
  }
}
