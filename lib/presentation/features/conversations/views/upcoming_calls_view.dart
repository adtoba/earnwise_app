import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/core/providers/call_provider.dart';
import 'package:earnwise_app/core/utils/helpers.dart';
import 'package:earnwise_app/core/utils/spacer.dart';
import 'package:earnwise_app/presentation/styles/palette.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:earnwise_app/presentation/widgets/accept_button.dart';
import 'package:earnwise_app/presentation/widgets/cancel_button.dart';
import 'package:earnwise_app/presentation/widgets/custom_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpcomingCallsView extends ConsumerStatefulWidget {
  const UpcomingCallsView({super.key, this.isExpertView});

  final bool? isExpertView;

  @override
  ConsumerState<UpcomingCallsView> createState() => _UpcomingCallsViewState();
}

class _UpcomingCallsViewState extends ConsumerState<UpcomingCallsView> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(widget.isExpertView ?? false) {
        ref.read(callNotifier).getExpertCallHistory(
          status: "accepted"
        );
      } else {
        ref.read(callNotifier).getUserCallHistory(
          status: "accepted"
        );
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var callProvider = ref.watch(callNotifier);
    var userCallHistory = callProvider.userCallHistory;
    var expertCallHistory = callProvider.expertCallHistory;
    var callHistory = widget.isExpertView ?? false ? expertCallHistory : userCallHistory;
    var isLoadingUserCallHistory = callProvider.isLoadingUserCallHistory;
    var isLoadingExpertCallHistory = callProvider.isLoadingExpertCallHistory;
    var isLoadingHistory = widget.isExpertView ?? false ? isLoadingExpertCallHistory : isLoadingUserCallHistory;
    
    var brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;

    final cardColor = isDarkMode ? Palette.darkFillColor : Palette.lightBackground;
    final cardShadow = isDarkMode ? Colors.black.withOpacity(0.2) : Colors.black.withOpacity(0.06);
    final secondaryTextColor = isDarkMode ? Palette.textGreyscale700Dark : Palette.textGreyscale700Light;
    final chipBg = isDarkMode ? Palette.surfaceButtonDark : Palette.surfaceButtonLight;

    if(isLoadingHistory && callHistory.isEmpty) {
      return Center(
        child: CustomProgressIndicator(),
      );
    } else if (callHistory.isEmpty) {
      return Center(
        child: Text("No upcoming calls"),
      );
    }

    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent
      ),
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: config.sw(20), vertical: config.sh(20)),
        itemBuilder: (c, i) {
          if (i == 0) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: chipBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Palette.primary.withOpacity(0.2)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, size: 18, color: Palette.primary),
                  XMargin(10),
                  Expanded(
                    child: Text(
                      "You can join a call 5 minutes before the scheduled time and during the scheduled time.",
                      style: TextStyles.smallRegular.copyWith(color: secondaryTextColor),
                    ),
                  ),
                ],
              ),
            );
          }

          var call = callHistory[i - 1];
          var expert = call.expert;
          var user = call.user;
          var scheduledDateTime = DateTime.parse(call.scheduledAt!).toLocal();
          final now = DateTime.now();
          final joinableFrom = scheduledDateTime.subtract(const Duration(minutes: 5));
          final joinableUntil = scheduledDateTime.add(Duration(minutes: call.durationMins ?? 0));
          bool isJoinable = !now.isBefore(joinableFrom) && !now.isAfter(joinableUntil);
      
          return Container(
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: cardShadow,
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ExpansionTile(
              tilePadding: EdgeInsets.symmetric(horizontal: config.sw(16), vertical: config.sh(8)),
              initiallyExpanded: true,
              childrenPadding: EdgeInsets.fromLTRB(config.sw(16), 0, config.sw(16), config.sh(16)),
              leading: Container(
                height: config.sw(44),
                width: config.sw(44),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      widget.isExpertView ?? false ? user?.profilePicture ?? "" : expert?.user?.profilePicture ?? "",
                    ),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              expandedAlignment: Alignment.centerLeft,
              title: Text(
                widget.isExpertView ?? false ? "${user?.firstName ?? ""} ${user?.lastName ?? ""}" : "${expert?.user?.firstName ?? ""} ${expert?.user?.lastName ?? ""}",
                style: TextStyles.largeBold.copyWith(
                  color: isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight,
                ),
              ),
              subtitle: Text(
                formatSmartTime(scheduledDateTime),
                style: TextStyles.smallRegular.copyWith(color: secondaryTextColor),
              ),
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: chipBg,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "Upcoming",
                        style: TextStyles.smallSemiBold.copyWith(color: Palette.primary),
                      ),
                    ),
                    XMargin(10),
                    Icon(Icons.timer_outlined, size: 16, color: secondaryTextColor),
                    XMargin(6),
                    Text(
                      "${call.durationMins} mins",
                      style: TextStyles.smallRegular.copyWith(color: secondaryTextColor),
                    ),
                  ],
                ),
                YMargin(12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Subject:",
                      style: TextStyles.smallSemiBold.copyWith(
                        color: isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight,
                      ),
                    ),
                    XMargin(8),
                    Expanded(
                      child: Text(
                        call.subject ?? "",
                        style: TextStyles.smallMedium.copyWith(color: secondaryTextColor),
                      ),
                    ),
                  ],
                ),
                YMargin(8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Note:",
                      style: TextStyles.smallSemiBold.copyWith(
                        color: isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight,
                      ),
                    ),
                    XMargin(8),
                    Expanded(
                      child: Text(
                        call.description ?? "",
                        style: TextStyles.smallMedium.copyWith(color: secondaryTextColor),
                      ),
                    ),
                  ],
                ),
                YMargin(16),
                Row(
                  children: [
                    Expanded(
                      child: CancelButton(
                        text: "Cancel",
                        onPressed: () {},
                      )
                    ),
                    XMargin(12),
                    Expanded(
                      child: AcceptButton(
                        onPressed: isJoinable ?() {
                          callProvider.generateCallToken(
                            callId: call.id ?? "",
                            isUser: widget.isExpertView == true ? false : true,
                            expertId: expert?.id ?? "",
                            scheduledAt: call.scheduledAt ?? "",
                            durationMins: call.durationMins ?? 0,
                            isExpert: widget.isExpertView ?? false,
                            userName: "${user?.firstName ?? ""} ${user?.lastName ?? ""}",
                            userId: expert?.user?.id ?? "",
                            expertName: "${expert?.user?.firstName ?? ""} ${expert?.user?.lastName ?? ""}",
                            expertAvatarUrl: expert?.user?.profilePicture ?? "",
                          );
                        } : null,
                        text: "Join"
                      )
                      
                    ),
                  ],
                ),
                
              ],
            ),
          );
        }, 
        separatorBuilder: (c, i) => i == 0 ? YMargin(12) : YMargin(10), 
        itemCount: callHistory.length + 1
      ),
    );
  }
}
