import 'dart:math';

import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/core/providers/expert_provider.dart';
import 'package:earnwise_app/core/utils/navigator.dart';
import 'package:earnwise_app/core/utils/spacer.dart';
import 'package:earnwise_app/presentation/features/home/screens/expert_profile_screen.dart';
import 'package:earnwise_app/presentation/features/home/widgets/suggested_expert_item.dart';
import 'package:earnwise_app/presentation/styles/palette.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:earnwise_app/presentation/widgets/custom_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SuggestedExpertsView extends ConsumerStatefulWidget {
  const SuggestedExpertsView({super.key});

  @override
  ConsumerState<SuggestedExpertsView> createState() => _SuggestedExpertsViewState();
}

class _SuggestedExpertsViewState extends ConsumerState<SuggestedExpertsView> {
  final List<String> _fallbackImages = const [
    "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400&q=80",
    "https://images.unsplash.com/photo-1544723795-3fb6469f5b39?w=400&q=80",
    "https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=400&q=80",
    "https://images.unsplash.com/photo-1525134479668-1bee5c7c6845?w=400&q=80",
    "https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?w=400&q=80",
    "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=400&q=80",
  ];

  String _randomImageForIndex(int index) {
    final rand = Random(index);
    return _fallbackImages[rand.nextInt(_fallbackImages.length)];
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(expertNotifier).getRecommendedExperts();
    });
  }
  @override
  Widget build(BuildContext context) {
    var expertProvider = ref.watch(expertNotifier);
    var recommendedExperts = expertProvider.recommendedExperts;
    var isRecommendedExpertsLoading = expertProvider.isRecommendedExpertsLoading;
    var brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;
    
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: config.sw(16)),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  "Recommended Experts",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.xLargeBold
                ),
              ),
              TextButton(
                onPressed: () {}, 
                child: Text(
                  "See All ", 
                  style: TextStyles.mediumMedium.copyWith(
                    fontFamily: TextStyles.fontFamily,
                    color: isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight,
                  )
                )
              )
            ],
          ),
        ),
        YMargin(10),
        if (isRecommendedExpertsLoading && recommendedExperts.isEmpty) ...[
          Center(
            child: CustomProgressIndicator(),
          )
        ] else if (recommendedExperts.isEmpty) ...[
          Center(
            child: Text("No recommended experts found"),
          )
        ] else ...[
          SizedBox(
            height: config.sh(200),
            child: ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: config.sw(16)),
              scrollDirection: Axis.horizontal,
              itemBuilder: (c, i) {
                var expert = recommendedExperts[i];
                return SuggestedExpertItem(
                  imageUrl: expert.user?.profilePicture != "" ? expert.user?.profilePicture ?? "" : "https://img.freepik.com/free-photo/portrait-confident-young-businessman-with-his-arms-crossed_23-2148176206.jpg?semt=ais_hybrid&w=740&q=80",
                  name: "${expert.user?.firstName ?? ""} ${expert.user?.lastName ?? ""}", 
                  title: expert.professionalTitle ?? "",
                  rating: expert.rating ?? 0,
                  rate: expert.rates?.text ?? 0,
                  onTap: () {
                    push(ExpertProfileScreen(
                      expert: expert,
                    ));
                  }
                );
              }, 
              separatorBuilder: (c, i) => XMargin(10), 
              itemCount: recommendedExperts.length
            ),
          ),
        ]
      ],
    );
  }
}