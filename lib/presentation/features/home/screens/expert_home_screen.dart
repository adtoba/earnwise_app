import 'package:earnwise_app/core/providers/expert_provider.dart';
import 'package:earnwise_app/core/utils/spacer.dart';
import 'package:earnwise_app/presentation/features/home/views/expert_home_analytics_view.dart';
import 'package:earnwise_app/presentation/features/home/views/expert_home_wallet_view.dart';
import 'package:earnwise_app/presentation/features/home/views/expert_scheduled_calls.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:earnwise_app/presentation/widgets/custom_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ExpertHomeScreen extends ConsumerStatefulWidget {
  const ExpertHomeScreen({super.key});

  @override
  ConsumerState<ExpertHomeScreen> createState() => _ExpertHomeScreenState();
}

class _ExpertHomeScreenState extends ConsumerState<ExpertHomeScreen> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(expertNotifier).getExpertDashboard();
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var expertDashboard = ref.watch(expertNotifier).expertDashboard;
    var isExpertDashboardLoading = ref.watch(expertNotifier).isExpertDashboardLoading;
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
            icon: Icon(FontAwesomeIcons.bell),
            onPressed: () {}
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(isExpertDashboardLoading)...[
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: CustomProgressIndicator(),
                ),
              )
            ] else ...[
              ExpertHomeWalletView(
                wallet: expertDashboard?.wallet,
              ),
              YMargin(20),
              ExpertHomeAnalyticsView(
                expertDashboard: expertDashboard,
              ),
              YMargin(20),
              ExpertScheduledCallsView()
            ],
          ],
        ),
      ),
    );
  }
}