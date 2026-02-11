import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/core/utils/spacer.dart';
import 'package:earnwise_app/presentation/features/home/views/expert_feeds_view.dart';
import 'package:earnwise_app/presentation/features/home/views/expert_home_analytics_view.dart';
import 'package:earnwise_app/presentation/features/home/views/expert_home_wallet_view.dart';
import 'package:earnwise_app/presentation/features/home/views/expert_scheduled_calls.dart';
import 'package:earnwise_app/presentation/features/home/views/suggested_experts_view.dart';
import 'package:earnwise_app/presentation/styles/palette.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:earnwise_app/presentation/widgets/primary_textfield.dart';
import 'package:earnwise_app/presentation/widgets/search_textfield.dart';
import 'package:flutter/material.dart';

class ExpertHomeScreen extends StatefulWidget {
  const ExpertHomeScreen({super.key});

  @override
  State<ExpertHomeScreen> createState() => _ExpertHomeScreenState();
}

class _ExpertHomeScreenState extends State<ExpertHomeScreen> {
  @override
  Widget build(BuildContext context) {
    var brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        // leading: Icon(Icons.access_alarms_sharp),
        title: Text(
          'Dashboard',
          style: TextStyles.largeBold.copyWith(
            fontFamily: TextStyles.fontFamily,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {}
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ExpertHomeWalletView(),
            YMargin(20),
            ExpertHomeAnalyticsView(),
            YMargin(20),
            ExpertScheduledCallsView()
          ],
        ),
      ),
    );
  }
}