import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/core/providers/call_provider.dart';
import 'package:earnwise_app/core/utils/helpers.dart';
import 'package:earnwise_app/core/utils/spacer.dart';
import 'package:earnwise_app/presentation/styles/palette.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:earnwise_app/presentation/widgets/custom_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiffy/jiffy.dart';

class PendingCallsView extends ConsumerStatefulWidget {
  const PendingCallsView({super.key, this.isExpertView = false});

  final bool? isExpertView;

  @override
  ConsumerState<PendingCallsView> createState() => _PendingCallsViewState();
}

class _PendingCallsViewState extends ConsumerState<PendingCallsView> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(widget.isExpertView ?? false) {
        ref.read(callNotifier).getExpertCallHistory(
          status: "pending"
        );
      } else {
        ref.read(callNotifier).getUserCallHistory(
          status: "pending"
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
    var isLoadingCallHistory = widget.isExpertView ?? false ? callProvider.isLoadingExpertCallHistory : callProvider.isLoadingUserCallHistory;
    var brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;

    final cardColor = isDarkMode ? Palette.darkFillColor : Palette.lightBackground;
    final cardShadow = isDarkMode ? Colors.black.withOpacity(0.2) : Colors.black.withOpacity(0.06);
    final secondaryTextColor = isDarkMode ? Palette.textGreyscale700Dark : Palette.textGreyscale700Light;
    final chipBg = isDarkMode ? const Color(0x33F59E0B) : const Color(0x1AF59E0B);
    final chipTextColor = isDarkMode ? const Color(0xFFFBBF24) : const Color(0xFFD97706);

    if(isLoadingCallHistory && callHistory.isEmpty) {
      return Center(
        child: CustomProgressIndicator(),
      );
    } else if (callHistory.isEmpty) {
      return Center(
        child: Text("No pending calls"),
      );
    }

    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent
      ),
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: config.sw(20), vertical: config.sh(20)),
        itemBuilder: (c, i) {
          var call = callHistory[i];
          var scheduledDateTime = DateTime.parse(call.scheduledAt!).toLocal();
          var expert = call.expert;
          var user = call.user;
        
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
                childrenPadding: EdgeInsets.fromLTRB(config.sw(16), 0, config.sw(16), config.sh(16)),
                initiallyExpanded: true,
                dense: true,            
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
                          widget.isExpertView ?? false ? "Approval Required" : "Pending",
                          style: TextStyles.smallSemiBold.copyWith(color: chipTextColor),
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
                        "Description:",
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
                      
                      
                      if(widget.isExpertView ?? false) ...[
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: isDarkMode ? Colors.red.shade300 : Colors.red.shade400),
                              foregroundColor: isDarkMode ? Colors.red.shade200 : Colors.red.shade600,
                              backgroundColor: isDarkMode ? Colors.red.withOpacity(0.12) : Colors.red.withOpacity(0.08),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              padding: EdgeInsets.symmetric(vertical: config.sh(12)),
                            ),
                            label: Text(
                              "Reject",
                              style: TextStyles.mediumSemiBold.copyWith(
                                color: isDarkMode ? Colors.red.shade200 : Colors.red.shade600,
                              ),
                            ),
                            icon: Icon(Icons.close, size: 18),
                          ),
                        ),
                        XMargin(12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              callProvider.acceptCall(
                                callId: call.id ?? "",
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Palette.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              padding: EdgeInsets.symmetric(vertical: config.sh(12)),
                            ),
                            label: Text(
                              "Accept",
                              style: TextStyles.mediumSemiBold.copyWith(color: Colors.white),
                            ),
                            icon: const Icon(Icons.check_circle, size: 18),
                          ),
                        ),
                      ] else ...[
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: isDarkMode ? Palette.borderDark : Palette.borderLight),
                              foregroundColor: isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              padding: EdgeInsets.symmetric(vertical: config.sh(12)),
                            ),
                            child: Text(
                              "Cancel",
                              style: TextStyles.mediumSemiBold,
                            ),
                          ),
                        ),
                      ],
                      
                    ],
                  ),
                ],
              ),
            );
          }, 
          separatorBuilder: (c, i) => YMargin(10), 
          itemCount: callHistory.length
        )
    );
  }
}