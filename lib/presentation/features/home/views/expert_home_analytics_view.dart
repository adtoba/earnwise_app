import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/core/utils/spacer.dart';
import 'package:earnwise_app/domain/models/expert_dashboard_model.dart';
import 'package:earnwise_app/presentation/styles/palette.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:flutter/material.dart';

class ExpertHomeAnalyticsView extends StatelessWidget {
  const ExpertHomeAnalyticsView({super.key, this.expertDashboard});

  final ExpertDashboardModel? expertDashboard;

  @override
  Widget build(BuildContext context) {
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
          // Row(
          //   children: [
          //     Text(
          //       "Analytics",
          //       style: TextStyles.largeSemiBold.copyWith(
          //         color: isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight,
          //       ),
          //     ),
          //     Spacer(),
          //     Container(
          //       padding: EdgeInsets.symmetric(horizontal: config.sw(10), vertical: config.sh(6)),
          //       decoration: BoxDecoration(
          //         color: isDarkMode ? Palette.surfaceButtonDark : Palette.surfaceButtonLight,
          //         borderRadius: BorderRadius.circular(20),
          //         border: Border.all(color: borderColor),
          //       ),
          //       child: Row(
          //         children: [
          //           Text(
          //             "Last 30 days",
          //             style: TextStyles.smallSemiBold.copyWith(color: secondaryTextColor),
          //           ),
          //           XMargin(6),
          //           Icon(Icons.keyboard_arrow_down, size: 16, color: secondaryTextColor),
          //         ],
          //       ),
          //     ),
          //   ],
          // ),
          // YMargin(12),
          Container(
            padding: EdgeInsets.symmetric(horizontal: config.sw(16), vertical: config.sh(14)),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              children: [
                _AnalyticsRow(
                  label: "Total Earnings",
                  value: "\$${expertDashboard?.wallet?.totalEarnings ?? 0}",
                  isDarkMode: isDarkMode,
                ),
                Divider(height: config.sh(20), color: borderColor),
                _AnalyticsRow(
                  label: "Withdrawals",
                  value: "\$${expertDashboard?.wallet?.totalWithdrawals ?? 0}",
                  isDarkMode: isDarkMode,
                ),
                Divider(height: config.sh(20), color: borderColor),
                _AnalyticsRow(
                  label: "Total Consultations",
                  value: "${expertDashboard?.expertProfile?.totalConsultations ?? 0}",
                  isDarkMode: isDarkMode,
                ),
                Divider(height: config.sh(20), color: borderColor),
                _AnalyticsRow(
                  label: "Avg. Rating",
                  value: "${expertDashboard?.expertProfile?.rating?.toStringAsFixed(2) ?? 0}",
                  isDarkMode: isDarkMode,
                  trailing: Icon(Icons.star, size: 16, color: Colors.amber.shade600),
                ),
                Divider(height: config.sh(20), color: borderColor),
                _AnalyticsRow(
                  label: "Response Time",
                  value: "2h 15m",
                  isDarkMode: isDarkMode,
                ),
              ],
            ),
          ),
          YMargin(10),
        ],
      ),
    );
  }
}

class _AnalyticsRow extends StatelessWidget {
  const _AnalyticsRow({
    required this.label,
    required this.value,
    required this.isDarkMode,
    this.trailing,
  });

  final String label;
  final String value;
  final bool isDarkMode;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final valueColor = isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight;
    final labelColor = isDarkMode ? Palette.textGreyscale700Dark : Palette.textGreyscale700Light;

    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyles.smallRegular.copyWith(color: labelColor),
          ),
        ),
        if (trailing != null) ...[
          trailing!,
          XMargin(6),
        ],
        Text(
          value,
          style: TextStyles.largeSemiBold.copyWith(color: valueColor),
        ),
      ],
    );
  }
}