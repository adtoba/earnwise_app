import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/core/utils/navigator.dart';
import 'package:earnwise_app/core/utils/spacer.dart';
import 'package:earnwise_app/presentation/features/expert/screens/expert_socials_screen.dart';
import 'package:earnwise_app/presentation/styles/palette.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:earnwise_app/presentation/widgets/primary_button.dart';
import 'package:earnwise_app/presentation/widgets/search_textfield.dart';
import 'package:flutter/material.dart';

class ExpertSetAvailabilityScreen extends StatefulWidget {
  const ExpertSetAvailabilityScreen({super.key});

  @override
  State<ExpertSetAvailabilityScreen> createState() => _ExpertSetAvailabilityScreenState();
}

class _ExpertSetAvailabilityScreenState extends State<ExpertSetAvailabilityScreen> {
  final List<String> _days = const ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
  late final Map<String, _DayAvailability> _availability;

  @override
  void initState() {
    super.initState();
    _availability = {
      for (final day in _days) day: _DayAvailability(),
    };
  }

  @override
  void dispose() {
    for (final day in _availability.values) {
      day.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;

    final borderColor = isDarkMode ? Palette.borderDark : Palette.borderLight;
    final secondaryTextColor = isDarkMode ? Palette.textGreyscale700Dark : Palette.textGreyscale700Light;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Set Availability",
          style: TextStyles.largeBold.copyWith(
            color: isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: config.sw(20), vertical: config.sh(16)),
        children: [
          Text(
            "Choose when you're available.",
            style: TextStyles.smallRegular.copyWith(color: secondaryTextColor),
          ),
          YMargin(12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final day = _days[index];
              final availability = _availability[day]!;
              return Container(
                padding: EdgeInsets.all(config.sw(14)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: borderColor),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          day,
                          style: TextStyles.mediumSemiBold.copyWith(
                            color: isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight,
                          ),
                        ),
                        Spacer(),
                        Switch.adaptive(
                          value: availability.isEnabled,
                          activeColor: Palette.primary,
                          onChanged: (value) {
                            setState(() {
                              availability.isEnabled = value;
                            });
                          },
                        ),
                      ],
                    ),
                    if (availability.isEnabled) ...[
                      YMargin(10),
                      Row(
                        children: [
                          Expanded(
                            child: SearchTextField(
                              hint: "Start time",
                              controller: availability.startController,
                            ),
                          ),
                          XMargin(10),
                          Expanded(
                            child: SearchTextField(
                              hint: "End time",
                              controller: availability.endController,
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      YMargin(6),
                      Text(
                        "Not available",
                        style: TextStyles.smallRegular.copyWith(color: secondaryTextColor),
                      ),
                    ],
                  ],
                ),
              );
            },
            separatorBuilder: (_, __) => YMargin(12),
            itemCount: _days.length,
          ),
          YMargin(20),
        ],
      ),
      persistentFooterButtons: [
        Padding(
          padding: EdgeInsetsGeometry.symmetric(
            horizontal: config.sw(20),
          ),
          child: PrimaryButton(
            text: "Save Changes", 
            onPressed: () {
              push(ExpertSocialsScreen());
            }
          ),
        )
      ],
    );
  }
}

class _DayAvailability {
  _DayAvailability()
      : startController = TextEditingController(text: "9:00 AM"),
        endController = TextEditingController(text: "5:00 PM");

  bool isEnabled = true;
  final TextEditingController startController;
  final TextEditingController endController;

  void dispose() {
    startController.dispose();
    endController.dispose();
  }
}