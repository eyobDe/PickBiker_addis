import 'package:flutter/material.dart';
import 'package:pick_delivery_adama_biker/widget/phone_orders_card.dart';

import '../model/order.dart';
import '../model/phoneOrders.dart';
import 'order_card.dart';

class PhoneOrderGrid extends StatelessWidget {
  const PhoneOrderGrid({

    required List<PhoneOrders> PhoneOrders,
  })  : _phoneOrder = PhoneOrders;


  final List<PhoneOrders> _phoneOrder;



  @override
  Widget build(BuildContext context) {

    return ListView.builder(
      padding:  const EdgeInsets.only(
        top: 4, bottom: 1,),
      itemCount: _phoneOrder.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {

        return PhoneOrderCard(
          order:_phoneOrder[index],
        );
      },
    );

  }
}
