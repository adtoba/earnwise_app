import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/core/utils/spacer.dart';
import 'package:earnwise_app/presentation/styles/palette.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:flutter/material.dart';

class ExpertScheduledCallsView extends StatelessWidget {
  const ExpertScheduledCallsView({super.key});

  @override
  Widget build(BuildContext context) {
    var brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;

    final cardColor = isDarkMode ? Palette.darkFillColor : Palette.lightBackground;
    final borderColor = isDarkMode ? Palette.borderDark : Palette.borderLight;
    final secondaryTextColor = isDarkMode ? Palette.textGreyscale700Dark : Palette.textGreyscale700Light;

    final calls = [
      _ScheduledCall(
        name: "Jose Martinez",
        time: "Today • 10:00 AM",
        duration: "30 mins",
      ),
      _ScheduledCall(
        name: "Amanda Brooks",
        time: "Tomorrow • 2:30 PM",
        duration: "45 mins",
      ),
      _ScheduledCall(
        name: "Grace Okoro",
        time: "Wed • 9:00 AM",
        duration: "20 mins",
      ),
      _ScheduledCall(
        name: "Daniel Romero",
        time: "Thu • 1:15 PM",
        duration: "40 mins",
      ),
      _ScheduledCall(
        name: "Michael Chen",
        time: "Fri • 4:00 PM",
        duration: "25 mins",
      ),
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: config.sw(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Upcoming Calls",
                style: TextStyles.largeSemiBold.copyWith(
                  color: isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight,
                ),
              ),
              Spacer(),
              Text(
                "Next 7 days",
                style: TextStyles.smallRegular.copyWith(color: secondaryTextColor),
              ),
            ],
          ),
          YMargin(12),
          Container(
            padding: EdgeInsets.symmetric(horizontal: config.sw(16), vertical: config.sh(14)),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              children: [
                for (int i = 0; i < calls.length; i++) ...[
                  _ScheduledCallRow(
                    call: calls[i],
                    isDarkMode: isDarkMode,
                  ),
                  if (i != calls.length - 1)
                    Divider(height: config.sh(20), color: borderColor),
                ],
              ],
            ),
          ),
          YMargin(10),
        ],
      ),
    );
  }
}

class _ScheduledCall {
  const _ScheduledCall({
    required this.name,
    required this.time,
    required this.duration,
  });

  final String name;
  final String time;
  final String duration;
}

class _ScheduledCallRow extends StatelessWidget {
  const _ScheduledCallRow({
    required this.call,
    required this.isDarkMode,
  });

  final _ScheduledCall call;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    final valueColor = isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight;
    final labelColor = isDarkMode ? Palette.textGreyscale700Dark : Palette.textGreyscale700Light;

    return Row(
      children: [
        CircleAvatar(
          radius: config.sw(18),
          backgroundColor: Palette.primary.withOpacity(0.15),
          child: const Icon(Icons.call, size: 18, color: Palette.primary),
        ),
        XMargin(10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                call.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.mediumSemiBold.copyWith(color: valueColor),
              ),
              YMargin(4),
              Text(
                call.time,
                style: TextStyles.smallRegular.copyWith(color: labelColor),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: config.sw(10), vertical: config.sh(6)),
          decoration: BoxDecoration(
            color: Palette.surfaceButtonLight,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            call.duration,
            style: TextStyles.smallSemiBold.copyWith(color: Palette.primary),
          ),
        ),
      ],
    );
  }
}