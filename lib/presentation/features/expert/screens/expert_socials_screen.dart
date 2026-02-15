import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/core/utils/extensions.dart';
import 'package:earnwise_app/core/utils/spacer.dart';
import 'package:earnwise_app/presentation/styles/palette.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:earnwise_app/presentation/widgets/primary_button.dart';
import 'package:earnwise_app/presentation/widgets/search_textfield.dart';
import 'package:flutter/material.dart';

class ExpertSocialsScreen extends StatefulWidget {
  const ExpertSocialsScreen({super.key});

  @override
  State<ExpertSocialsScreen> createState() => _ExpertSocialsScreenState();
}

class _ExpertSocialsScreenState extends State<ExpertSocialsScreen> {
  @override
  Widget build(BuildContext context) {
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
          onPressed: () {
            
          }
        ),
      )
    );
  }
}