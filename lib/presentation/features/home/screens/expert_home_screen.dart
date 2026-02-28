import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/core/providers/call_provider.dart';
import 'package:earnwise_app/core/providers/expert_provider.dart';
import 'package:earnwise_app/core/utils/navigator.dart';
import 'package:earnwise_app/core/utils/spacer.dart';
import 'package:earnwise_app/presentation/features/conversations/screens/view_pending_calls_screen.dart';
import 'package:earnwise_app/presentation/features/home/views/expert_home_analytics_view.dart';
import 'package:earnwise_app/presentation/features/home/views/expert_home_wallet_view.dart';
import 'package:earnwise_app/presentation/features/home/views/expert_scheduled_calls.dart';
import 'package:earnwise_app/presentation/styles/palette.dart';
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
      ref.read(callNotifier).getExpertCallHistory(status: "pending");
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var expertDashboard = ref.watch(expertNotifier).expertDashboard;
    var isExpertDashboardLoading = ref.watch(expertNotifier).isExpertDashboardLoading;
    var pendingCalls = ref.watch(callNotifier).pendingExpertCallHistory;
    var brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;
    final pendingCount = pendingCalls.length;
    final pendingBg = isDarkMode ? const Color(0x33F59E0B) : const Color(0x1AF59E0B);
    final pendingText = isDarkMode ? const Color(0xFFFBBF24) : const Color(0xFFD97706);

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
              if (pendingCount > 0) ...[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: config.sw(20)),
                  child: GestureDetector(
                    onTap: () {
                      push(ViewPendingCallsScreen());
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: config.sw(14), vertical: config.sh(12)),
                      decoration: BoxDecoration(
                        color: pendingBg,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isDarkMode ? Palette.borderDark : Palette.borderLight,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.warning_amber_rounded, color: pendingText, size: 20),
                          XMargin(10),
                          Expanded(
                            child: Text(
                              "You have $pendingCount pending call request${pendingCount == 1 ? "" : "s"}.",
                              style: TextStyles.smallSemiBold.copyWith(color: pendingText),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                YMargin(16),
              ],
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