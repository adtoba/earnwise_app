import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/core/providers/category_provider.dart';
import 'package:earnwise_app/core/utils/spacer.dart';
import 'package:earnwise_app/presentation/features/settings/screens/expert_category_selection_screen.dart';
import 'package:earnwise_app/presentation/styles/palette.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:earnwise_app/presentation/widgets/custom_progress_indicator.dart';
import 'package:earnwise_app/presentation/widgets/primary_button.dart';
import 'package:earnwise_app/presentation/widgets/search_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpertDetailsScreen extends StatefulWidget {
  const ExpertDetailsScreen({super.key});

  @override
  State<ExpertDetailsScreen> createState() => _ExpertDetailsScreenState();
}

class _ExpertDetailsScreenState extends State<ExpertDetailsScreen> {
  final List<String> _selectedCategories = [];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;

    final secondaryTextColor = isDarkMode ? Palette.textGreyscale700Dark : Palette.textGreyscale700Light;
    final sectionBorderColor = isDarkMode ? Palette.borderDark : Palette.borderLight;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Expert Details",
          style: TextStyles.largeBold.copyWith(
            color: isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: config.sw(20), vertical: config.sh(16)),
        children: [
          _SectionBlock(
            title: "Expertise",
            borderColor: sectionBorderColor,
            child: Column(
              children: [
                _LabeledField(
                  label: "Categories",
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Text(
                              "Selected categories",
                              style: TextStyles.smallRegular.copyWith(color: secondaryTextColor),
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              final selected = await Navigator.of(context).push<List<String>>(
                                MaterialPageRoute(
                                  builder: (_) => CategorySelectionScreen(
                                    initialSelection: _selectedCategories,
                                  ),
                                ),
                              );
                              if (selected == null) return;
                              setState(() {
                                _selectedCategories
                                  ..clear()
                                  ..addAll(selected);
                              });
                            },
                            icon: Icon(Icons.add_circle, color: Palette.primary),
                          ),
                        ],
                      ),
                      if (_selectedCategories.isNotEmpty) ...[
                        YMargin(10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _selectedCategories
                              .map(
                                (category) => Chip(
                                  label: Text(category),
                                  onDeleted: () {
                                    setState(() {
                                      _selectedCategories.remove(category);
                                    });
                                  },
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ],
                  ),
                ),
                YMargin(12),
                _LabeledField(label: "Professional title", child: _textField(hint: "Business Consultant")),
                YMargin(12),
                _LabeledField(
                  label: "Bio",
                  child: _textField(hint: "Tell clients about your expertise", maxLines: 4),
                ),
              ],
            ),
          ),
          YMargin(16),
          _SectionBlock(
            title: "Frequently Asked Questions",
            borderColor: sectionBorderColor,
            child: Column(
              children: [
                _LabeledField(label: "Question 1", child: _textField(hint: "How do I get started?")),
                YMargin(12),
                _LabeledField(label: "Question 2", child: _textField(hint: "What do you specialize in?")),
                YMargin(12),
                _LabeledField(label: "Question 3", child: _textField(hint: "How do I contact you?")),
              ],
            ),
          ),
        ],
      ),
      persistentFooterButtons: [
        Padding(
          padding: EdgeInsetsGeometry.symmetric(
            horizontal: config.sw(20),
          ),
          child: PrimaryButton(
            text: "Submit for Review", 
            onPressed: () {}
          ),
        )
      ],
    );
  }
}

class _SectionBlock extends StatelessWidget {
  const _SectionBlock({
    required this.title,
    required this.child,
    required this.borderColor,
  });

  final String title;
  final Widget child;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyles.largeSemiBold,
        ),
        YMargin(10),
        Container(
          padding: EdgeInsets.all(config.sw(14)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              child,
            ],
          ),
        ),
      ],
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({
    required this.label,
    required this.child,
  });

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyles.smallSemiBold,
        ),
        YMargin(6),
        child,
      ],
    );
  }
}

Widget _textField({required String hint, int maxLines = 1}) {
  return SearchTextField(
    hint: hint,
    maxLines: maxLines,
  );
}

Widget _dropdownField({
  required BuildContext context,
  required String? value,
  required String hint,
  required List<String> items,
  required ValueChanged<String?> onChanged,
}) {
  var brightness = Theme.of(context).brightness;
  bool isDarkMode = brightness == Brightness.dark;

  return DropdownButtonFormField<String>(
    value: value,
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: TextStyles.mediumRegular,
      filled: true,      
      fillColor: isDarkMode ? Palette.darkFillColor : Palette.lightFillColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Palette.primary),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: config.sw(16)),
    ),
    items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
    onChanged: onChanged,
  );
}