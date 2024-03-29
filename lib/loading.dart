import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(

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
      ),
    );
  }
}
