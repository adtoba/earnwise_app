import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/core/utils/spacer.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:flutter/material.dart';

class AboutExpertView extends StatelessWidget {
  const AboutExpertView({super.key, this.bio});

  final String? bio;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: config.sw(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "About",
            style: TextStyles.h4Bold,
            maxLines: 1,
            textScaler: TextScaler.noScaling,
          ),
          YMargin(10),
          Text(
            bio ?? "",
          ),
          YMargin(10),
          Row(
            children: [
            
            ],
          )
        ],
      ),
    );
  }
}