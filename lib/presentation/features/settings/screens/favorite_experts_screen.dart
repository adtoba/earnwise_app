import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/core/providers/expert_provider.dart';
import 'package:earnwise_app/core/utils/navigator.dart';
import 'package:earnwise_app/core/utils/spacer.dart';
import 'package:earnwise_app/presentation/features/explore/widgets/expert_list_item.dart';
import 'package:earnwise_app/presentation/features/home/screens/expert_profile_screen.dart';
import 'package:earnwise_app/presentation/styles/palette.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:earnwise_app/presentation/widgets/custom_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoriteExpertsScreen extends ConsumerStatefulWidget {
  const FavoriteExpertsScreen({super.key});

  @override
  ConsumerState<FavoriteExpertsScreen> createState() => _FavoriteExpertsScreenState();
}

class _FavoriteExpertsScreenState extends ConsumerState<FavoriteExpertsScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(expertNotifier).getSavedExperts();
    });
  }

  @override
  Widget build(BuildContext context) {
    var brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;
    var expertProvider = ref.watch(expertNotifier);
    var savedExperts = expertProvider.savedExperts;

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
          if(expertProvider.isSavedExpertsLoading)...[
            Expanded(
              child: Center(
                child: CustomProgressIndicator(),
              ),
            ),
          ] else if(savedExperts.isEmpty)...[
            Expanded(
              child: Center(
                child: Text("No saved experts found"),
              ),
            ),
          ] else ...[
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: config.sw(20), vertical: config.sh(20)),
                itemBuilder: (context, index) {
                  final expert = savedExperts[index];
                  return ExpertListItem(
                    name: "${expert.user?.firstName ?? ""} ${expert.user?.lastName ?? ""}",
                    rating: expert.rating ?? 0,
                    consultations: expert.totalConsultations ?? 0,
                    location: expert.user?.country ?? "",
                    state: expert.user?.state ?? "",
                    rate: "${expert.rates?.text ?? 0} / text",
                    description: expert.bio ?? "",
                    imageUrl: expert.user?.profilePicture ?? "",
                    onTap: () {
                      push(ExpertProfileScreen(
                        expert: expert,
                      ));
                    },
                  );
                },
                separatorBuilder: (context, index) => YMargin(14),
                itemCount: savedExperts.length,
              ),
            ),
          ]
        ],
      ),
    );
  }
}