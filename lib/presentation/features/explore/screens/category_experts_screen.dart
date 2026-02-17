import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/core/providers/category_provider.dart';
import 'package:earnwise_app/core/utils/extensions.dart';
import 'package:earnwise_app/core/utils/navigator.dart';
import 'package:earnwise_app/core/utils/spacer.dart';
import 'package:earnwise_app/presentation/features/explore/widgets/expert_list_item.dart';
import 'package:earnwise_app/presentation/features/home/screens/expert_profile_screen.dart';
import 'package:earnwise_app/presentation/styles/palette.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:earnwise_app/presentation/widgets/custom_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryExpertsScreen extends ConsumerStatefulWidget {
  const CategoryExpertsScreen({super.key, required this.category});
  
  final String category;

  @override
  ConsumerState<CategoryExpertsScreen> createState() => _CategoryExpertsScreenState();
}

class _CategoryExpertsScreenState extends ConsumerState<CategoryExpertsScreen> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(categoryNotifier).getExpertsByCategory(category: widget.category);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;
    var categoryProvider = ref.watch(categoryNotifier);
    var experts = categoryProvider.experts;

    // final experts = [
    //   {
    //     "name": "Amanda Brooks",
    //     "rating": 4.8,
    //     "consultations": 124,
    //     "location": "Lagos, Nigeria",
    //     "rate": "\$30 / text",
    //     "description": "Helps founders set up clear financial models and cashflow plans.",
    //     "imageUrl": "https://img.freepik.com/free-photo/portrait-confident-young-businesswoman_23-2148176209.jpg?semt=ais_hybrid&w=740&q=80",
    //   },
    //   {
    //     "name": "Michael Chen",
    //     "rating": 4.9,
    //     "consultations": 210,
    //     "location": "San Francisco, USA",
    //     "rate": "\$65 / text",
    //     "description": "Career coach for product managers and early-stage tech leaders.",
    //     "imageUrl": "https://img.freepik.com/free-photo/portrait-handsome-young-businessman_23-2148176205.jpg?semt=ais_hybrid&w=740&q=80",
    //   },
    //   {
    //     "name": "Grace Okoro",
    //     "rating": 4.7,
    //     "consultations": 98,
    //     "location": "Accra, Ghana",
    //     "rate": "\$40 / text",
    //     "description": "Tax planning and compliance for small business owners.",
    //     "imageUrl": "https://img.freepik.com/free-photo/young-african-woman-with-arms-crossed-smiling_23-2148176180.jpg?semt=ais_hybrid&w=740&q=80",
    //   },
    //   {
    //     "name": "Daniel Romero",
    //     "rating": 4.6,
    //     "consultations": 76,
    //     "location": "Madrid, Spain",
    //     "rate": "\$55 / text",
    //     "description": "Guides first-time investors on diversified portfolios.",
    //     "imageUrl": "https://img.freepik.com/free-photo/portrait-smiling-businessman_23-2148176206.jpg?semt=ais_hybrid&w=740&q=80",
    //   },
    // ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Column(
          children: [
            Hero(
              tag: widget.category,
              transitionOnUserGestures: true,
              child: Material(
                color: Colors.transparent,
                child: Text(
                  widget.category,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.largeBold.copyWith(
                    color: isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight,
                  ),
                ),
              ),
            ),
            YMargin(5),
            Text(
              "${experts.length} Expert(s)",
              style: TextStyles.smallRegular.copyWith(
                fontFamily: TextStyles.fontFamily,
                color: isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {}, 
            icon: Image.asset(
              "filter".png, 
              height: config.sh(24), 
              width: config.sw(24),
              color: isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight,
              colorBlendMode: BlendMode.srcIn,
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Builder(
              builder: (context) {
                if(ref.watch(categoryNotifier).isLoading) {
                  return Center(
                    child: CustomProgressIndicator()
                  );
                } else if(ref.watch(categoryNotifier).experts.isEmpty) {
                  return Center(
                    child: Text(
                      "No experts found",
                      style: TextStyles.largeBold.copyWith(
                        color: isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight,
                      ),
                    ),
                  );
                } else {
                  return ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: config.sw(20), vertical: config.sh(20)),
                    itemBuilder: (context, index) {
                      final expert = experts[index];
                      return ExpertListItem(
                        name: "${expert.user?.firstName ?? ""} ${expert.user?.lastName ?? ""}",
                        rating: expert.rating ?? 0,
                        consultations: expert.totalConsultations ?? 0,
                        location: expert.user?.country ?? "",
                        state: expert.user?.state ?? "",
                        rate: "${expert.rates?.text ?? 0} / text",
                        description: expert.bio ?? "",
                        imageUrl: "https://img.freepik.com/free-photo/portrait-confident-young-businesswoman_23-2148176209.jpg?semt=ais_hybrid&w=740&q=80",
                        onTap: () {
                          push(ExpertProfileScreen(
                            expert: expert,
                          ));
                        },
                      );
                    },
                    separatorBuilder: (context, index) => YMargin(14),
                    itemCount: experts.length,
                  );
                }
                
              }
            ),
          ),
        ],
      ),
    );
  }
}