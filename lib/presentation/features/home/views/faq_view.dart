import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/core/utils/spacer.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:flutter/material.dart';

class FaqView extends StatelessWidget {
  const FaqView({super.key, this.faq});

  final List<String>? faq;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: config.sw(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Frequently Asked Questions",
            maxLines: 1,
            textScaler: TextScaler.noScaling,
            style: TextStyles.h4Bold,
          ),
          YMargin(10),
          ...faq!.map((e) => Padding(
            padding: EdgeInsets.only(bottom: config.sh(10)),
            child: Row(
              children: [
                Icon(Icons.circle, size: 5),
                XMargin(10),
                Text(e),
              ],
            ),
          ))
        ],
      ),
    );
  }
}