import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/core/providers/call_provider.dart';
import 'package:earnwise_app/core/utils/helpers.dart';
import 'package:earnwise_app/core/utils/spacer.dart';
import 'package:earnwise_app/presentation/styles/palette.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:earnwise_app/presentation/widgets/custom_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PastCallsView extends ConsumerStatefulWidget {
  const PastCallsView({super.key, this.isExpertView = false});

  final bool? isExpertView;

  @override
  ConsumerState<PastCallsView> createState() => _PastCallsViewState();
}

class _PastCallsViewState extends ConsumerState<PastCallsView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(widget.isExpertView ?? false) {
        ref.read(callNotifier).getExpertCallHistory(
          status: "past"
        );
      } else {
        ref.read(callNotifier).getUserCallHistory(
          status: "past"
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
        child: Text("No past calls"),
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
          var expert = call.expert;
          var user = call.user;
          var scheduledDateTime = DateTime.parse(call.scheduledAt!).toLocal();
          
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
              leading: Container(
                height: config.sw(44),
                width: config.sw(44),
                decoration: BoxDecoration(
                  color: Palette.primary.withOpacity(isDarkMode ? 0.18 : 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.call_end, color: Palette.primary),
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
                        call.status ?? "",
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
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.download_rounded, size: 18),
                    label: Text(
                      "Download Recording",
                      style: TextStyles.mediumSemiBold.copyWith(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Palette.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: EdgeInsets.symmetric(vertical: config.sh(12)),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        separatorBuilder: (c, i) => YMargin(10),
        itemCount: callHistory.length,
      ),
    );
  }
}