// Copyright 2022 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

//import '../model/restaurant.dart';
import '../app_theme.dart';
import '../model/feature.dart';
//import '../widgets/star_rating.dart';

class FeaturedCard extends StatelessWidget {
  FeaturedCard({
    required this.features,

  }) ;

  final Features features;


  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: InkWell(
        splashColor: Colors.transparent,
        // onTap: callback,
        onTap: () {

        },
        child:  Container(
          width: 300,
          height: (MediaQuery.of(context).size.height / 3),
          decoration: BoxDecoration(
            //color: HexColor('#F8FAFB'),
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(
              image: CachedNetworkImageProvider(
                features.photo!,
              ),

              fit: BoxFit.cover,
              colorFilter:
              ColorFilter.mode(Colors.black.withOpacity(0.25), BlendMode.srcOver),
            ),

            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: DesignCourseAppTheme.notWhite
                      .withOpacity(0.1),
                  offset: const Offset(1, 1),
                  blurRadius: 4.0),
            ],

          ),


        ),

      ),


    );
  }
}
