import 'dart:async';

import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/core/providers/expert_provider.dart';
import 'package:earnwise_app/core/utils/navigator.dart';
import 'package:earnwise_app/core/utils/spacer.dart';
import 'package:earnwise_app/presentation/features/explore/widgets/expert_list_item.dart';
import 'package:earnwise_app/presentation/features/home/screens/expert_profile_screen.dart';
import 'package:earnwise_app/presentation/styles/palette.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:earnwise_app/presentation/widgets/search_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchExpertsScreen extends ConsumerStatefulWidget {
  const SearchExpertsScreen({super.key});

  @override
  ConsumerState<SearchExpertsScreen> createState() => _SearchExpertsScreenState();
}

class _SearchExpertsScreenState extends ConsumerState<SearchExpertsScreen> {

  final FocusNode _searchFocusNode = FocusNode();
  Timer? _searchDebounce;

  bool _isSearching = false;
  String _activeFilter = "All";

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(() {
      if (_searchFocusNode.hasFocus) {
        setState(() {
          _isSearching = true;
        });
      } else {
        setState(() {
          _isSearching = false;
        });
      }
    });
    _searchFocusNode.requestFocus();
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    _searchDebounce?.cancel();
    super.dispose();
  }
  
  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 350), () {
      if(value.isNotEmpty) {
        ref.read(expertNotifier).searchExperts(value);
      } else {
        ref.read(expertNotifier).setSearchedExperts([]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var expertProvider = ref.watch(expertNotifier);
    var brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;
    final secondaryTextColor = isDarkMode ? Palette.textGreyscale700Dark : Palette.textGreyscale700Light;
    final cardColor = isDarkMode ? Palette.darkFillColor : Palette.lightFillColor;
    final borderColor = isDarkMode ? Palette.borderDark : Palette.borderLight;

    return Scaffold(
      appBar: AppBar(
        title: SearchTextField(
          prefix: Icon(Icons.search),
          hint: "Search by name, title or category",
          focusNode: _searchFocusNode,
          onChanged: _onSearchChanged,
        ),
        actions: [
          if(_isSearching) ...[
            TextButton(
              onPressed: () {
                setState(() {
                  _isSearching = false;
                });
                _searchFocusNode.unfocus();
              },
              child: Text("Cancel", style: TextStyles.smallRegular)
            )
          ],
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: config.sw(20), vertical: config.sh(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Find the right expert",
                  style: TextStyles.largeSemiBold.copyWith(
                    color: isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight,
                  ),
                ),
                YMargin(4),
                Text(
                  "Search by name, professional title, or category.",
                  style: TextStyles.smallRegular.copyWith(color: secondaryTextColor),
                ),
                YMargin(12),
                Wrap(
                  spacing: config.sw(8),
                  runSpacing: config.sh(8),
                  children: [
                    _FilterChip(
                      label: "All",
                      isSelected: _activeFilter == "All",
                      onTap: () => setState(() => _activeFilter = "All"),
                      cardColor: cardColor,
                      borderColor: borderColor,
                      isDarkMode: isDarkMode,
                    ),
                    _FilterChip(
                      label: "Name",
                      isSelected: _activeFilter == "Name",
                      onTap: () => setState(() => _activeFilter = "Name"),
                      cardColor: cardColor,
                      borderColor: borderColor,
                      isDarkMode: isDarkMode,
                    ),
                    _FilterChip(
                      label: "Title",
                      isSelected: _activeFilter == "Title",
                      onTap: () => setState(() => _activeFilter = "Title"),
                      cardColor: cardColor,
                      borderColor: borderColor,
                      isDarkMode: isDarkMode,
                    ),
                    _FilterChip(
                      label: "Category",
                      isSelected: _activeFilter == "Category",
                      onTap: () => setState(() => _activeFilter = "Category"),
                      cardColor: cardColor,
                      borderColor: borderColor,
                      isDarkMode: isDarkMode,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: expertProvider.searchedExperts.isEmpty
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: config.sw(24)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.search, size: 40, color: secondaryTextColor),
                          YMargin(10),
                          Text(
                            "No experts found",
                            style: TextStyles.mediumSemiBold.copyWith(
                              color: isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight,
                            ),
                          ),
                          YMargin(6),
                          Text(
                            "Try a different name, title, or category.",
                            textAlign: TextAlign.center,
                            style: TextStyles.smallRegular.copyWith(color: secondaryTextColor),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: config.sw(20), vertical: config.sh(8)),
                    itemCount: expertProvider.searchedExperts.length,
                    itemBuilder: (context, index) {
                      var expert = expertProvider.searchedExperts[index];
                      return ExpertListItem(
                        name: "${expert.user?.firstName ?? ""} ${expert.user?.lastName ?? ""}",
                        rating: expert.rating ?? 0,
                        consultations: expert.totalConsultations ?? 0,
                        location: expert.user?.country ?? "",
                        state: expert.user?.state ?? "",
                        rate: "${expert.rates?.text ?? 0} / text",
                        description: expert.bio ?? "",
                        imageUrl: expert.user?.profilePicture ?? "",
                        onTap: () {
                          push(ExpertProfileScreen(expert: expert));
                        },
                      );
                    },
                    separatorBuilder: (context, index) => YMargin(14),
                  ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.cardColor,
    required this.borderColor,
    required this.isDarkMode,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color cardColor;
  final Color borderColor;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    final textColor = isSelected
        ? Colors.white
        : isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: config.sw(14), vertical: config.sh(8)),
        decoration: BoxDecoration(
          color: isSelected ? Palette.primary : cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor),
        ),
        child: Text(
          label,
          style: TextStyles.smallSemiBold.copyWith(color: textColor),
        ),
      ),
    );
  }
}