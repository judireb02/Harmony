import 'package:flutter/material.dart';

import 'package:harmony/src/widgets/profile_image.dart';

class StatusImages extends StatefulWidget {
  const StatusImages({super.key});

  @override
  StatusImagesState createState() => StatusImagesState();
}

class StatusImagesState extends State<StatusImages> {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
              9,
              (index) => ProfileImage(
                    image: "assets/images/profile0${index + 1}.png",
                    hasStatus: true,
                  )),
        ),
      ),
    );
  }
}
