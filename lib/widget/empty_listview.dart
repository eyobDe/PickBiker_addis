import 'package:flutter/material.dart';

//.l;/'
// import '../utils.dart';

typedef EmptyListActionButtonCallback = void Function();

class EmptyListView extends StatelessWidget {
  const EmptyListView({
    required this.child,
    this.onPressed,
  });

  final Widget child;
  final EmptyListActionButtonCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    var imageSize = 600.0;
    if (screenWidth < 640 || screenHeight < 820) {
      imageSize = 300;
    }
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // Container(
          //   width: imageSize,
          //   height: imageSize,
          //   child: Image.asset(
          //     imagePath('friendlyeater.png'),
          //   ),
          // ),
          child,
          MaterialButton(
            child: Text('ADD SOME'),
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }
}
