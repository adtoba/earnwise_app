import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/core/providers/call_provider.dart';
import 'package:earnwise_app/core/utils/helpers.dart';
import 'package:earnwise_app/core/utils/navigator.dart';
import 'package:earnwise_app/core/utils/spacer.dart';
import 'package:earnwise_app/domain/models/call_model.dart';
import 'package:earnwise_app/presentation/features/conversations/screens/view_upcoming_calls_screen.dart';
import 'package:earnwise_app/presentation/styles/palette.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:earnwise_app/presentation/widgets/custom_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiffy/jiffy.dart';

class ExpertScheduledCallsView extends ConsumerStatefulWidget {
  const ExpertScheduledCallsView({super.key});

  @override
  ConsumerState<ExpertScheduledCallsView> createState() => _ExpertScheduledCallsViewState();
}

class _ExpertScheduledCallsViewState extends ConsumerState<ExpertScheduledCallsView> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(callNotifier).getExpertCallHistory(
        status: "accepted"
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var callProvider = ref.watch(callNotifier);
    var expertCallHistory = callProvider.expertHomeCallHistory;
    var isLoadingExpertCallHistory = callProvider.isLoadingExpertCallHistory;
    var brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;

    final cardColor = isDarkMode ? Palette.darkFillColor : Palette.lightBackground;
    final borderColor = isDarkMode ? Palette.borderDark : Palette.borderLight;
    final secondaryTextColor = isDarkMode ? Palette.textGreyscale700Dark : Palette.textGreyscale700Light;

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
              GestureDetector(
                onTap: () {
                  push(ViewUpcomingCallsScreen());
                },
                child: Text(
                  "See All",
                  style: TextStyles.mediumSemiBold.copyWith(color: secondaryTextColor),
                ),
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
            child: isLoadingExpertCallHistory && expertCallHistory.isEmpty 
            
            ? Center(child: CustomProgressIndicator()) : 
            
            expertCallHistory.isEmpty 
              ? Center(child: Text("No upcoming calls")) 
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (c, i) {
                    return _ScheduledCallRow(
                      call: expertCallHistory[i],
                      isDarkMode: isDarkMode,
                    );
                  }, 
                  separatorBuilder: (c, i) => Divider(
                    height: config.sh(20),
                    color: borderColor,
                  ), 
                  itemCount: expertCallHistory.take(5).length
                )
          ),
          YMargin(10),
        ],
      ),
    );
  }
}

class _ScheduledCallRow extends StatelessWidget {
  const _ScheduledCallRow({
    required this.call,
    required this.isDarkMode,
  });

  final CallModel call;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    var user = call.user;
    var scheduledDateTime = DateTime.parse(call.scheduledAt!).toLocal();
    final now = DateTime.now();
    final joinableFrom = scheduledDateTime.subtract(const Duration(minutes: 2));
    final joinableUntil = scheduledDateTime.add(Duration(minutes: call.durationMins ?? 0));
    bool isJoinable = !now.isBefore(joinableFrom) && !now.isAfter(joinableUntil);
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
                "${user?.firstName ?? ""} ${user?.lastName ?? ""}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.mediumSemiBold.copyWith(color: valueColor),
              ),
              YMargin(4),
              Text(
                formatSmartTime(scheduledDateTime),
                style: TextStyles.smallRegular.copyWith(color: labelColor),
              ),
            ],
          ),
        ),
        if (isJoinable)...[
          TextButton(
            child: Text(
              "Join Call",
              style: TextStyles.smallSemiBold.copyWith(color: Palette.primary),
            ),
            onPressed: () {},
          ),
        ] else ...[
          Container(
            padding: EdgeInsets.symmetric(horizontal: config.sw(10), vertical: config.sh(6)),
            decoration: BoxDecoration(
              color: Palette.surfaceButtonLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(Icons.timer_outlined, size: 16, color: Palette.primary),
                XMargin(4),
                Text(
                  "${call.durationMins} mins",
                  style: TextStyles.smallSemiBold.copyWith(color: Palette.primary),
                ),
              ],
            ),
          ),
        ]
      ],
    );
  }
}
