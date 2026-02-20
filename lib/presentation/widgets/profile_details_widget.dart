import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/core/providers/profile_provider.dart';
import 'package:earnwise_app/core/utils/navigator.dart';
import 'package:earnwise_app/core/utils/spacer.dart';
import 'package:earnwise_app/presentation/features/profile/screens/profile_screen.dart';
import 'package:earnwise_app/presentation/styles/palette.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileDetailsWidget extends ConsumerStatefulWidget {
  const ProfileDetailsWidget({super.key});

  @override
  ConsumerState<ProfileDetailsWidget> createState() => _ProfileDetailsWidgetState();
}

class _ProfileDetailsWidgetState extends ConsumerState<ProfileDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    var brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;
    var profile = ref.watch(profileNotifier).profile;

    final cardColor = isDarkMode ? Palette.darkFillColor : Palette.lightBackground;
    final borderColor = isDarkMode ? Palette.borderDark : Palette.borderLight;
    final secondaryTextColor = isDarkMode ? Palette.textGreyscale700Dark : Palette.textGreyscale700Light;
    
    return Container(
      padding: EdgeInsets.all(config.sw(14)),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: config.sw(28),
            backgroundImage: NetworkImage(
              profile?.user?.profilePicture ?? "https://img.freepik.com/free-photo/portrait-confident-young-businessman-with-his-arms-crossed_23-2148176206.jpg?semt=ais_hybrid&w=740&q=80",
            ),
          ),
          XMargin(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${profile?.user?.firstName} ${profile?.user?.lastName}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textScaler: TextScaler.noScaling,
                  style: TextStyles.largeSemiBold.copyWith(
                    color: isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight,
                  ),
                ),
                YMargin(4),
                Text(
                  profile?.user?.email ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textScaler: TextScaler.noScaling,
                  style: TextStyles.smallRegular.copyWith(color: secondaryTextColor),
                ),
              ],
            ),
          ),
          XMargin(10),
          OutlinedButton(
            onPressed: () {
              push(ProfileScreen());
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: borderColor),
              foregroundColor: isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: EdgeInsets.symmetric(horizontal: config.sw(12), vertical: config.sh(8)),
            ),
            child: Text(
              "View Profile",
              style: TextStyles.smallSemiBold,
            ),
          ),
        ],
      ),
    );
  }
}