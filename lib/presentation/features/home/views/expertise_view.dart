import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/core/utils/spacer.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:flutter/material.dart';

class ExpertiseView extends StatelessWidget {
  const ExpertiseView({super.key, this.categories});

  final List<String>? categories;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: config.sw(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Expert In",
            style: TextStyles.h4Bold,
            maxLines: 1,
            textScaler: TextScaler.noScaling,
          ),
          YMargin(10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              ...categories!.map((e) => Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(e),
              ))
            ],
          ),
        ],
      ),
    );
  }
}