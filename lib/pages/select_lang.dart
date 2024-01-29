import 'package:easy_localization/easy_localization.dart';
import 'package:flag/flag_enum.dart';
import 'package:flag/flag_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../app_theme.dart';
import '../login_page.dart';

class SelectLang extends StatefulWidget {
  const SelectLang({Key? key}) : super(key: key);

  @override
  _SelectLangState createState() => _SelectLangState();
}

class _SelectLangState extends State<SelectLang> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: DesignCourseAppTheme.nearlyWhite,
      child:Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height*0.3,),
            SizedBox(height: 14.0),

             Padding(
              padding: EdgeInsets.only(top: 28.0, left: 38, right: 38),

               child:Column(
                 children: [
                   Row(
                     children: [

                       Text(
                         'Pick',
                         textAlign: TextAlign.center,
                         style: TextStyle(
                           fontWeight: FontWeight.bold,
                           fontSize: 30,
                           letterSpacing: 0.27,
                           color: DesignCourseAppTheme.mainLogoColor,
                         ),
                       ),
                       Text(
                         'Pro',
                         textAlign: TextAlign.center,
                         style: TextStyle(
                           fontWeight: FontWeight.bold,
                           fontSize: 30,
                           letterSpacing: 0.27,
                           color: Colors.black,
                         ),
                       ),
                     ],

                   ),
                   SizedBox(height: 16),
                   const Text(
                     "Select a language / ቋንቋ ይምረጡ",
                     textAlign: TextAlign.center,
                     style: TextStyle(
                         fontSize: 16,
                         ),
                   ),
                   SizedBox(height: 4),
                   Row(
                     children: [
                       SizedBox(width: 40.0),

                       ElevatedButton(
                         style: ButtonStyle(
                             backgroundColor: MaterialStateProperty.all(Colors.amber),
                             shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                 RoundedRectangleBorder(
                                   borderRadius: BorderRadius.circular(35.0),
                                 ))),
                         onPressed: () {
                           EasyLocalization.of(context)!.setLocale(const Locale.fromSubtags(languageCode: 'en'),);
                           Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyLoginPage()));
                         },
                         child:Row(
                           children: [
                             Flag.fromCode(
                               FlagsCode.US,
                               height: 25,
                               width: 28,
                             ),
                             SizedBox(width: 4),
                             Text(
                               "English".toUpperCase(),
                               style: const TextStyle(

                                 fontSize: 14,
                                 letterSpacing: 0.27,
                                 color: Colors.white,
                               ),
                             ),
                           ],
                         ),

                       ),
                       SizedBox(width: 6),

                       ElevatedButton(
                         style: ButtonStyle(
                             backgroundColor: MaterialStateProperty.all(Colors.amber),
                             shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                 RoundedRectangleBorder(
                                   borderRadius: BorderRadius.circular(35.0),
                                 ))),
                         onPressed: () {
                           EasyLocalization.of(context)!.setLocale(const Locale.fromSubtags(languageCode: 'am'),);
                           Navigator.of(context).push(MaterialPageRoute(
                               builder: (context) => MyLoginPage()));
                         },
                         child:Row(
                           children: [
                             Flag.fromCode(
                               FlagsCode.ET,
                               height: 25,
                               width: 28,
                             ),
                             SizedBox(width: 4),
                             Text(
                               "አማርኛ".toUpperCase(),
                               style: const TextStyle(

                                 fontSize: 14,
                                 letterSpacing: 0.27,
                                 color: Colors.white,
                               ),
                             ),
                           ],
                         ),

                       ),
                     ],
                   ),

                 ],
               ),

             ),

          ],
        ),
      ),

    );
  }
}
