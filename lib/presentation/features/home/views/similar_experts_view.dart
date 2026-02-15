import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/core/utils/navigator.dart';
import 'package:earnwise_app/core/utils/spacer.dart';
import 'package:earnwise_app/presentation/features/home/screens/expert_profile_screen.dart';
import 'package:earnwise_app/presentation/features/home/widgets/suggested_expert_item.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:flutter/material.dart';

class SimilarExpertsView extends StatelessWidget {
  const SimilarExpertsView({super.key});

  @override
  Widget build(BuildContext context) {
    var brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: config.sw(20)),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  "Experts you might like",
                  maxLines: 1,
                  textScaler: TextScaler.noScaling,
                  style: TextStyles.h4Bold,
                ),
              ),
            ],
          ),
        ),
        YMargin(10),
        SizedBox(
          height: config.sh(200),
          child: ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: config.sw(20)),
            scrollDirection: Axis.horizontal,
            itemBuilder: (c, i) {
              return SuggestedExpertItem(
                imageUrl: "https://img.freepik.com/free-photo/portrait-confident-young-businessman-with-his-arms-crossed_23-2148176206.jpg?semt=ais_hybrid&w=740&q=80", 
                name: "Jose Martinez", 
                title: "Business Consultant",
                onTap: () {
                  push(ExpertProfileScreen());
                }
              );
            }, 
            separatorBuilder: (c, i) => XMargin(10), 
            itemCount: 5
          ),
        ),
      ],
    );
  }
}