import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/core/providers/profile_provider.dart';
import 'package:earnwise_app/core/utils/navigator.dart';
import 'package:earnwise_app/core/utils/spacer.dart';
import 'package:earnwise_app/presentation/features/home/screens/search_experts_screen.dart';
import 'package:earnwise_app/presentation/features/home/views/expert_feeds_view.dart';
import 'package:earnwise_app/presentation/features/home/views/suggested_experts_view.dart';
import 'package:earnwise_app/presentation/features/profile/screens/profile_screen.dart';
import 'package:earnwise_app/presentation/styles/palette.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:earnwise_app/presentation/widgets/search_textfield.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(() {
      if (_searchFocusNode.hasFocus) {
        _searchFocusNode.unfocus();
        push(const SearchExpertsScreen());
      }
    });
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var profile = ref.watch(profileNotifier).profile;
    var brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        titleSpacing: config.sw(8),
        leadingWidth: config.sw(56),
        leading: Padding(
          padding: EdgeInsets.only(left: config.sw(16)),
          child: InkWell(
            onTap: () => push(ProfileScreen()),
            child: CircleAvatar(
              radius: config.sw(18),
              backgroundImage: NetworkImage(profile?.user?.profilePicture ?? ""),
              backgroundColor: Palette.primary.withOpacity(0.12),
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome',
              style: TextStyles.smallRegular.copyWith(
                fontFamily: TextStyles.fontFamily,
                color: isDarkMode ? Palette.textGreyscale700Dark : Palette.textGreyscale700Light,
              ),
            ),
            YMargin(5),
            Text(
              "${profile?.user?.firstName ?? ""} ${profile?.user?.lastName ?? ""}",
              style: TextStyles.mediumBold.copyWith(
                fontFamily: TextStyles.fontFamily,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: EdgeInsets.symmetric(vertical: config.sh(8)),
            padding: EdgeInsets.symmetric(horizontal: config.sw(10), vertical: config.sh(6)),
            decoration: BoxDecoration(
              color: isDarkMode ? Palette.darkFillColor : Palette.lightFillColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(Icons.trending_up, size: 16, color: Palette.primary),
                XMargin(6),
                Text(
                  "Home",
                  style: TextStyles.xSmallMedium.copyWith(
                    color: isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight,
                  ),
                ),
              ],
            ),
          ),
          XMargin(8),
          IconButton(
            icon: Icon(FontAwesomeIcons.bell),
            onPressed: () {
              
            }
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            YMargin(10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: config.sw(16)),
              child: SearchTextField(
                hint: "Search Experts",
                prefix: Icon(Icons.search),
                focusNode: _searchFocusNode,
              ),
            ),    
            YMargin(10),        
            SuggestedExpertsView(),
            YMargin(20),
            Divider(
              color: isDarkMode ? Palette.borderDark : Palette.borderLight,
              height: config.sh(10),
            ),
            ExpertFeedsView()
          ],
        ),
      ),
    );
  }
}