import 'package:flutter/material.dart';

import '../model/order.dart';
import 'order_card.dart';

class OrderGrid extends StatelessWidget {
  const OrderGrid({

    required List<Order> order,
  })  : _order = order;


  final List<Order> _order;

  @override
  Widget build(BuildContext context) {

    return ListView.builder(
      padding:  const EdgeInsets.only(
        top: 4, bottom: 1,),
      itemCount: _order.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {

        return OrderCard(
          order:_order[index],
        );
      },
    );

  }
}
