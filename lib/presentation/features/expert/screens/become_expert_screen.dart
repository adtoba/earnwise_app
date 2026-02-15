import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/core/utils/navigator.dart';
import 'package:earnwise_app/core/utils/spacer.dart';
import 'package:earnwise_app/presentation/features/expert/screens/expert_set_availability_screen.dart';
import 'package:earnwise_app/presentation/features/expert/screens/set_rates_screen.dart';
import 'package:earnwise_app/presentation/styles/palette.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:earnwise_app/presentation/widgets/primary_button.dart';
import 'package:earnwise_app/presentation/widgets/search_textfield.dart';
import 'package:flutter/material.dart';

class BecomeExpertScreen extends StatefulWidget {
  const BecomeExpertScreen({super.key});

  @override
  State<BecomeExpertScreen> createState() => _BecomeExpertScreenState();
}

class _BecomeExpertScreenState extends State<BecomeExpertScreen> {
  String? _gender;
  String? _country;
  String? _state;
  String? _city;
  final List<String> _days = const ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
  late final Map<String, _SimpleAvailability> _availability;
  final List<String> _selectedCategories = [];
  final List<String> _availableCategories = [
    "Accounting",
    "Tax Planning",
    "Investing",
    "Career Coaching",
    "Marketing",
    "Business Strategy",
    "UX Design",
    "Software Engineering",
    "Real Estate",
    "Personal Finance",
  ];

  final List<String> _genders = ["Male", "Female", "Other"];
  final List<String> _countries = ["Nigeria", "Ghana", "United States", "United Kingdom"];
  final List<String> _states = ["Lagos", "Abuja", "Rivers", "Kano"];
  final List<String> _cities = ["Ikeja", "Lekki", "Yaba", "Surulere"];

  @override
  void initState() {
    super.initState();
    _availability = {
      for (final day in _days) day: _SimpleAvailability(),
    };
  }

  @override
  void dispose() {
    for (final availability in _availability.values) {
      availability.dispose();
    }
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
          "Set Expert Details",
          style: TextStyles.largeBold.copyWith(
            color: isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: config.sw(20), vertical: config.sh(16)),
        children: [
          // _SectionBlock(
          //   title: "Profile",
          //   borderColor: sectionBorderColor,
          //   child: Column(
          //     children: [
          //       Row(
          //         children: [
          //           CircleAvatar(
          //             radius: config.sw(32),
          //             backgroundColor: Palette.primary.withOpacity(0.15),
          //             child: const Icon(Icons.camera_alt, color: Palette.primary),
          //           ),
          //           XMargin(12),
          //           Expanded(
          //             child: Text(
          //               "Upload a clear profile photo",
          //               style: TextStyles.smallRegular.copyWith(color: secondaryTextColor),
          //             ),
          //           ),
          //           TextButton(
          //             onPressed: () {},
          //             child: Text(
          //               "Upload",
          //               style: TextStyles.smallSemiBold.copyWith(color: Palette.primary),
          //             ),
          //           ),
          //         ],
          //       ),
          //       YMargin(16),
          //       _LabeledField(label: "First name", child: _textField(hint: "John")),
          //       YMargin(12),
          //       _LabeledField(label: "Last name", child: _textField(hint: "Doe")),
          //       YMargin(12),
          //       _LabeledField(
          //         label: "Gender",
          //         child: _dropdownField(
          //           context: context,
          //           value: _gender,
          //           hint: "Select gender",
          //           items: _genders,
          //           onChanged: (value) => setState(() => _gender = value),
          //         ),
          //       ),
          //       YMargin(20),
          //       _LabeledField(
          //         label: "Date of birth",
          //         child: _textField(hint: "DD / MM / YYYY"),
          //       ),
          //     ],
          //   ),
          // ),
          // YMargin(16),
          // _SectionBlock(
          //   title: "Contact & Location",
          //   borderColor: sectionBorderColor,
          //   child: Column(
          //     children: [
          //       _LabeledField(label: "Phone number", child: _textField(hint: "+234 801 234 5678")),
          //       YMargin(12),
          //       _LabeledField(
          //         label: "Country",
          //         child: _dropdownField(
          //           context: context,
          //           value: _country,
          //           hint: "Select country",
          //           items: _countries,
          //           onChanged: (value) => setState(() => _country = value),
          //         ),
          //       ),
          //       YMargin(12),
          //       _LabeledField(
          //         label: "State",
          //         child: _dropdownField(
          //           context: context,
          //           value: _state,
          //           hint: "Select state",
          //           items: _states,
          //           onChanged: (value) => setState(() => _state = value),
          //         ),
          //       ),
          //       YMargin(12),
          //       _LabeledField(
          //         label: "City",
          //         child: _dropdownField(
          //           context: context,
          //           value: _city,
          //           hint: "Select city",
          //           items: _cities,
          //           onChanged: (value) => setState(() => _city = value),
          //         ),
          //       ),
          //       YMargin(12),
          //       _LabeledField(label: "Zip code", child: _textField(hint: "100001")),
          //     ],
          //   ),
          // ),
          // YMargin(16),
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
                                  builder: (_) => _CategorySelectionScreen(
                                    categories: _availableCategories,
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
          // YMargin(16),
          // _SectionBlock(
          //   title: "Availability",
          //   borderColor: sectionBorderColor,
          //   child: Column(
          //     children: [
          //       for (int i = 0; i < _days.length; i++) ...[
          //         _AvailabilityRow(
          //           day: _days[i],
          //           availability: _availability[_days[i]]!,
          //           onChanged: (value) {
          //             setState(() {
          //               _availability[_days[i]]!.isEnabled = value;
          //             });
          //           },
          //         ),
          //         if (i != _days.length - 1) YMargin(12),
          //       ],
          //     ],
          //   ),
          // ),
          YMargin(16),
          _SectionBlock(
            title: "Rates",
            borderColor: sectionBorderColor,
            child: Column(
              children: [
                RateRowInline(
                  title: "Text/Audio response",
                  subtitle: "(Min. \$10 per response)",
                  hint: "\$10 / response",
                  isDarkMode: isDarkMode,
                  showDivider: true,
                ),
                RateRowInline(
                  title: "Video response",
                  subtitle: "(Min. \$20 per response)",
                  hint: "\$20 / response",
                  isDarkMode: isDarkMode,
                  showDivider: true,
                ),
                RateRowInline(
                  title: "Video call",
                  subtitle: "(Min. \$1 per minute)",
                  hint: "\$1 / minute",
                  isDarkMode: isDarkMode,
                  showDivider: false,
                ),
              ],
            ),
          ),
          YMargin(20),
          // ElevatedButton(
          //   onPressed: () {},
          //   style: ElevatedButton.styleFrom(
          //     backgroundColor: Palette.primary,
          //     foregroundColor: Colors.white,
          //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          //     padding: EdgeInsets.symmetric(vertical: config.sh(14)),
          //   ),
          //   child: Text(
          //     "Submit for Review",
          //     style: TextStyles.mediumSemiBold.copyWith(color: Colors.white),
          //   ),
          // ),
          // YMargin(20),
        ],
      ),
      persistentFooterButtons: [
        Padding(
          padding: EdgeInsetsGeometry.symmetric(
            horizontal: config.sw(20),
          ),
          child: PrimaryButton(
            text: "Next", 
            onPressed: () {
              push(ExpertSetAvailabilityScreen());
            }
          ),
        )
      ],
    );
  }
}

class _AvailabilityRow extends StatelessWidget {
  const _AvailabilityRow({
    required this.day,
    required this.availability,
    required this.onChanged,
  });

  final String day;
  final _SimpleAvailability availability;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    var brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;
    final secondaryTextColor = isDarkMode ? Palette.textGreyscale700Dark : Palette.textGreyscale700Light;

    return Column(
      children: [
        Row(
          children: [
            Text(
              day,
              style: TextStyles.mediumSemiBold.copyWith(
                color: isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight,
              ),
            ),
            Spacer(),
            Switch.adaptive(
              value: availability.isEnabled,
              activeColor: Palette.primary,
              onChanged: onChanged,
            ),
          ],
        ),
        if (availability.isEnabled) ...[
          YMargin(8),
          Row(
            children: [
              Expanded(
                child: SearchTextField(
                  hint: "Start time",
                  controller: availability.startController,
                ),
              ),
              XMargin(10),
              Expanded(
                child: SearchTextField(
                  hint: "End time",
                  controller: availability.endController,
                ),
              ),
            ],
          ),
        ] else ...[
          YMargin(2),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Not available",
              style: TextStyles.smallRegular.copyWith(color: secondaryTextColor),
            ),
          ),
        ],
      ],
    );
  }
}

class _SimpleAvailability {
  _SimpleAvailability()
      : startController = TextEditingController(text: "9:00 AM"),
        endController = TextEditingController(text: "5:00 PM");

  bool isEnabled = true;
  final TextEditingController startController;
  final TextEditingController endController;

  void dispose() {
    startController.dispose();
    endController.dispose();
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

class _CategorySelectionScreen extends StatefulWidget {
  const _CategorySelectionScreen({
    required this.categories,
    required this.initialSelection,
  });

  final List<String> categories;
  final List<String> initialSelection;

  @override
  State<_CategorySelectionScreen> createState() => _CategorySelectionScreenState();
}

class _CategorySelectionScreenState extends State<_CategorySelectionScreen> {
  late Set<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialSelection.toSet();
  }

  @override
  Widget build(BuildContext context) {
    var brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;

    final borderColor = isDarkMode ? Palette.borderDark : Palette.borderLight;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Categories"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(_selected.toList());
            },
            child: Text(
              "Done",
              style: TextStyles.smallSemiBold.copyWith(color: Palette.primary),
            ),
          ),
        ],
      ),
      body: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: config.sw(20), vertical: config.sh(16)),
        itemBuilder: (context, index) {
          final category = widget.categories[index];
          final isSelected = _selected.contains(category);
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor),
            ),
            child: CheckboxListTile(
              value: isSelected,
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(
                category,
                style: TextStyles.mediumSemiBold,
              ),
              onChanged: (value) {
                setState(() {
                  if (value == true) {
                    _selected.add(category);
                  } else {
                    _selected.remove(category);
                  }
                });
              },
            ),
          );
        },
        separatorBuilder: (_, __) => YMargin(10),
        itemCount: widget.categories.length,
      ),
    );
  }
}