import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/core/utils/spacer.dart';
import 'package:earnwise_app/presentation/features/conversations/views/past_calls_view.dart';
import 'package:earnwise_app/presentation/features/conversations/views/pending_calls_view.dart';
import 'package:earnwise_app/presentation/features/conversations/views/upcoming_calls_view.dart';
import 'package:earnwise_app/presentation/styles/palette.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:flutter/material.dart';

class CallsView extends StatelessWidget {
  const CallsView({super.key});

  @override
  Widget build(BuildContext context) {
    var brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;
    
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          YMargin(20),
          Container(
            margin: EdgeInsets.symmetric(horizontal: config.sw(20)),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isDarkMode ? Palette.darkFillColor : Palette.lightFillColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: TabBar(
              dividerColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: isDarkMode ? Palette.lightFillColor : Palette.darkFillColor,
                borderRadius: BorderRadius.circular(12),
              ),
              labelColor: isDarkMode ? Palette.textGeneralLight : Palette.textGeneralDark,
              unselectedLabelColor: isDarkMode ? Palette.textGeneralDark.withOpacity(0.7) : Palette.textGeneralLight.withOpacity(0.7),
              labelStyle: TextStyles.mediumSemiBold,
              tabs: const [
                Tab(text: "Pending",),
                Tab(text: "Upcoming"),
                Tab(text: "Past"),
              ],
            ),
          ),
          YMargin(10),
          Expanded(
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                PendingCallsView(
                  isExpertView: false,
                ),
                UpcomingCallsView(
                  isExpertView: false,
                ),
                PastCallsView()
              ],
            ),
          ),
        ],
      ),
    );
  }
}