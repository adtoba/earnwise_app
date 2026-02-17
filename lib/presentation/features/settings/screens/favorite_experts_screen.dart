import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/core/utils/navigator.dart';
import 'package:earnwise_app/core/utils/spacer.dart';
import 'package:earnwise_app/presentation/features/explore/widgets/expert_list_item.dart';
import 'package:earnwise_app/presentation/features/home/screens/expert_profile_screen.dart';
import 'package:earnwise_app/presentation/styles/palette.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:flutter/material.dart';

class FavoriteExpertsScreen extends StatefulWidget {
  const FavoriteExpertsScreen({super.key});

  @override
  State<FavoriteExpertsScreen> createState() => _FavoriteExpertsScreenState();
}

class _FavoriteExpertsScreenState extends State<FavoriteExpertsScreen> {
  @override
  Widget build(BuildContext context) {
    var brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;

    final experts = [
      {
        "name": "Amanda Brooks",
        "rating": 4.8,
        "consultations": 124,
        "location": "Lagos, Nigeria",
        "state": "Lagos",
        "rate": "\$30 / text",
        "description": "Helps founders set up clear financial models and cashflow plans.",
        "imageUrl": "https://img.freepik.com/free-photo/portrait-confident-young-businesswoman_23-2148176209.jpg?semt=ais_hybrid&w=740&q=80",
      },
      {
        "name": "Michael Chen",
        "rating": 4.9,
        "consultations": 210,
        "location": "San Francisco, USA",
        "state": "California",
        "rate": "\$65 / text",
        "description": "Career coach for product managers and early-stage tech leaders.",
        "imageUrl": "https://img.freepik.com/free-photo/portrait-handsome-young-businessman_23-2148176205.jpg?semt=ais_hybrid&w=740&q=80",
      },
      {
        "name": "Grace Okoro",
        "rating": 4.7,
        "consultations": 98,
        "location": "Accra, Ghana",
        "state": "Accra",
        "rate": "\$40 / text",
        "description": "Tax planning and compliance for small business owners.",
        "imageUrl": "https://img.freepik.com/free-photo/young-african-woman-with-arms-crossed-smiling_23-2148176180.jpg?semt=ais_hybrid&w=740&q=80",
      },
      {
        "name": "Daniel Romero",
        "rating": 4.6,
        "consultations": 76,
        "location": "Madrid, Spain",
        "state": "Madrid",
        "rate": "\$55 / text",
        "description": "Guides first-time investors on diversified portfolios.",
        "imageUrl": "https://img.freepik.com/free-photo/portrait-smiling-businessman_23-2148176206.jpg?semt=ais_hybrid&w=740&q=80",
      },
    ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text(
          "Saved Experts",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyles.largeBold.copyWith(
            color: isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: config.sw(20), vertical: config.sh(20)),
              itemBuilder: (context, index) {
                final expert = experts[index];
                return ExpertListItem(
                  name: expert["name"] as String,
                  rating: expert["rating"] as double,
                  consultations: expert["consultations"] as int,
                  location: expert["location"] as String,
                  rate: expert["rate"] as String,
                  state: expert["state"] as String,
                  description: expert["description"] as String,
                  imageUrl: expert["imageUrl"] as String,
                  onTap: () {
                    push(ExpertProfileScreen());
                  },
                );
              },
              separatorBuilder: (context, index) => YMargin(14),
              itemCount: experts.length,
            ),
          ),
        ],
      ),
    );
  }
}