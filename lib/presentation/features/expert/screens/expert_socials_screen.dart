
import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/core/providers/expert_provider.dart';
import 'package:earnwise_app/core/utils/extensions.dart';
import 'package:earnwise_app/core/utils/spacer.dart';
import 'package:earnwise_app/domain/dto/update_expert_socials_dto.dart';
import 'package:earnwise_app/presentation/styles/palette.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:earnwise_app/presentation/widgets/primary_button.dart';
import 'package:earnwise_app/presentation/widgets/search_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpertSocialsScreen extends ConsumerStatefulWidget {
  const ExpertSocialsScreen({super.key});

  @override
  ConsumerState<ExpertSocialsScreen> createState() => _ExpertSocialsScreenState();
}

class _ExpertSocialsScreenState extends ConsumerState<ExpertSocialsScreen> {
  final instagramController = TextEditingController();
  final xController = TextEditingController();
  final linkedinController = TextEditingController();
  final websiteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final expertProvider = ref.watch(expertNotifier);
    var isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDarkMode ? Palette.borderDark : Palette.borderLight;
    final secondaryTextColor = isDarkMode ? Palette.textGreyscale700Dark : Palette.textGreyscale700Light;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Social Media",
          style: TextStyles.largeBold,
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: config.sw(20), vertical: config.sh(20)),
        child: ListView(
          children: [
            Text(
            "Link your social media accounts.",
            style: TextStyles.smallRegular.copyWith(color: secondaryTextColor),
            ),
            YMargin(12),
            SearchTextField(
              controller: websiteController,
              prefix: Image.asset(
                "website".png,
                height: config.sh(20),
                width: config.sw(20),
              ),
              hint: "Your Website URL",
              onChanged: (value) {
                // TODO: Implement search
              },
            ),
            YMargin(10),
            SearchTextField(
              controller: instagramController,
              prefix: Image.asset(
                "instagram".png,
                height: config.sh(20),
                width: config.sw(20),
              ),
              hint: "Your Instagram URL",
              onChanged: (value) {
                // TODO: Implement search
              },
            ),
            YMargin(10),
            SearchTextField(
              controller: xController,
              prefix: Image.asset(
                "x".png,
                height: config.sh(20),
                width: config.sw(20),
              ),
              hint: "Your X URL",
              onChanged: (value) {
                // TODO: Implement search
              },
            ),
            YMargin(10),
            SearchTextField(
              controller: linkedinController,
              prefix: Image.asset(
                "linkedin".png,
                height: config.sh(20),
                width: config.sw(20),
              ),
              hint: "Your Linkedin URL",
              onChanged: (value) {
                // TODO: Implement search
              },
            )
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsetsGeometry.only(
          left: config.sw(20),
          right: config.sw(20),
          bottom: config.sh(60)
        ),
        child: PrimaryButton(
          text: "Save Changes", 
          isLoading: expertProvider.isLoading,
          onPressed: () {
            expertProvider.createExpertProfileDto?.socials = UpdateExpertSocialsDto(
              instagram: instagramController.text,
              x: xController.text,
              linkedin: linkedinController.text,
              website: websiteController.text,
            );

            expertProvider.createExpertProfile();
          }
        ),
      )
    );
  }
}