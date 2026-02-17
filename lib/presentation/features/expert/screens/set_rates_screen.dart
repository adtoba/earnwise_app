import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/core/utils/spacer.dart';
import 'package:earnwise_app/presentation/styles/palette.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:earnwise_app/presentation/widgets/primary_button.dart';
import 'package:earnwise_app/presentation/widgets/search_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SetRatesScreen extends StatefulWidget {
  const SetRatesScreen({super.key});

  @override
  State<SetRatesScreen> createState() => _SetRatesScreenState();
}

class _SetRatesScreenState extends State<SetRatesScreen> {
  @override
  Widget build(BuildContext context) {
    var brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;

    final secondaryTextColor = isDarkMode ? Palette.textGreyscale700Dark : Palette.textGreyscale700Light;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Your Rates',
          style: TextStyles.largeBold.copyWith(
            color: isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: config.sw(20), vertical: config.sh(16)),
        children: [
          Text(
            "Set your rates",
            style: TextStyles.mediumSemiBold.copyWith(
              color: isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight,
            ),
          ),
          YMargin(6),
          Text(
            "Keep pricing clear and competitive.",
            style: TextStyles.smallRegular.copyWith(color: secondaryTextColor),
          ),
          YMargin(16),
          RateRowInline(
            title: "Text/Audio response",
            subtitle: "(Min. \$10 per response)",
            hint: "\$10 / response",
            isDarkMode: isDarkMode,
            showDivider: true,
          ),
          RateRowInline(
            title: "Video response",
            subtitle: "(Min. \$20 per response)",
            hint: "\$20 / response",
            isDarkMode: isDarkMode,
            showDivider: true,
          ),
          RateRowInline(
            title: "Video call",
            subtitle: "(Min. \$1 per minute)",
            hint: "\$1 / minute",
            isDarkMode: isDarkMode,
            showDivider: false,
          ),
        ],
      ),
      persistentFooterButtons: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: config.sw(20), vertical: config.sh(12)),
          child: PrimaryButton(
            text: "Save Changes",
            onPressed: () {},
          ),
        )
      ],
    );
  }
}

class RateRowInline extends StatelessWidget {
  const RateRowInline({
    super.key,
    required this.title,
    required this.subtitle,
    required this.hint,
    required this.isDarkMode,
    required this.showDivider,
    this.controller,
    this.validator,
  });

  final String title;
  final String subtitle;
  final String hint;
  final bool isDarkMode;
  final bool showDivider;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    final borderColor = isDarkMode ? Palette.borderDark : Palette.borderLight;
    final secondaryTextColor = isDarkMode ? Palette.textGreyscale700Dark : Palette.textGreyscale700Light;

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyles.mediumSemiBold.copyWith(
                      color: isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight,
                    ),
                  ),
                  YMargin(4),
                  Text(
                    subtitle,
                    style: TextStyles.smallRegular.copyWith(color: secondaryTextColor),
                  ),
                ],
              ),
            ),
            XMargin(12),
            SizedBox(
              width: config.sw(100),
              child: SearchTextField(
                hint: hint,
                controller: controller,
                validator: validator,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ),
          ],
        ),
        if (showDivider) ...[
          YMargin(14),
          Divider(height: config.sh(12), color: borderColor),
          YMargin(14),
        ],
      ],
    );
  }
}