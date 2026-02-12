import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/core/utils/spacer.dart';
import 'package:earnwise_app/presentation/styles/palette.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;

    final cardColor = isDarkMode ? Palette.darkFillColor : Palette.lightBackground;
    final borderColor = isDarkMode ? Palette.borderDark : Palette.borderLight;
    final secondaryTextColor = isDarkMode ? Palette.textGreyscale700Dark : Palette.textGreyscale700Light;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Become an Expert",
          style: TextStyles.largeBold.copyWith(
            color: isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: config.sw(20), vertical: config.sh(16)),
        children: [
          _SectionCard(
            title: "Profile",
            cardColor: cardColor,
            borderColor: borderColor,
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: config.sw(32),
                      backgroundColor: Palette.primary.withOpacity(0.15),
                      child: const Icon(Icons.camera_alt, color: Palette.primary),
                    ),
                    XMargin(12),
                    Expanded(
                      child: Text(
                        "Upload a clear profile photo",
                        style: TextStyles.smallRegular.copyWith(color: secondaryTextColor),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "Upload",
                        style: TextStyles.smallSemiBold.copyWith(color: Palette.primary),
                      ),
                    ),
                  ],
                ),
                YMargin(16),
                _LabeledField(label: "First name", child: _textField(hint: "John")),
                YMargin(12),
                _LabeledField(label: "Last name", child: _textField(hint: "Doe")),
                YMargin(12),
                _LabeledField(
                  label: "Gender",
                  child: _dropdownField(
                    value: _gender,
                    hint: "Select gender",
                    items: _genders,
                    onChanged: (value) => setState(() => _gender = value),
                  ),
                ),
                YMargin(12),
                _LabeledField(
                  label: "Date of birth",
                  child: _textField(hint: "DD / MM / YYYY"),
                ),
              ],
            ),
          ),
          YMargin(16),
          _SectionCard(
            title: "Contact & Location",
            cardColor: cardColor,
            borderColor: borderColor,
            child: Column(
              children: [
                _LabeledField(label: "Phone number", child: _textField(hint: "+234 801 234 5678")),
                YMargin(12),
                _LabeledField(
                  label: "Country",
                  child: _dropdownField(
                    value: _country,
                    hint: "Select country",
                    items: _countries,
                    onChanged: (value) => setState(() => _country = value),
                  ),
                ),
                YMargin(12),
                _LabeledField(
                  label: "State",
                  child: _dropdownField(
                    value: _state,
                    hint: "Select state",
                    items: _states,
                    onChanged: (value) => setState(() => _state = value),
                  ),
                ),
                YMargin(12),
                _LabeledField(
                  label: "City",
                  child: _dropdownField(
                    value: _city,
                    hint: "Select city",
                    items: _cities,
                    onChanged: (value) => setState(() => _city = value),
                  ),
                ),
                YMargin(12),
                _LabeledField(label: "Zip code", child: _textField(hint: "100001")),
              ],
            ),
          ),
          YMargin(16),
          _SectionCard(
            title: "Expertise",
            cardColor: cardColor,
            borderColor: borderColor,
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
          _SectionCard(
            title: "Frequently Asked Questions",
            cardColor: cardColor,
            borderColor: borderColor,
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
          YMargin(16),
          _SectionCard(
            title: "Availability",
            cardColor: cardColor,
            borderColor: borderColor,
            child: Column(
              children: [
                _LabeledField(label: "Working days", child: _textField(hint: "Mon - Fri")),
                YMargin(12),
                _LabeledField(label: "Working hours", child: _textField(hint: "9:00 AM - 5:00 PM")),
                YMargin(12),
                _LabeledField(label: "Time zone", child: _textField(hint: "GMT +1")),
              ],
            ),
          ),
          YMargin(16),
          _SectionCard(
            title: "Rates",
            cardColor: cardColor,
            borderColor: borderColor,
            child: Column(
              children: [
                _LabeledField(label: "Text/Audio response", child: _textField(hint: "\$30 / response")),
                YMargin(12),
                _LabeledField(label: "Video response", child: _textField(hint: "\$50 / response")),
                YMargin(12),
                _LabeledField(label: "Video call", child: _textField(hint: "\$80 / 30 mins")),
              ],
            ),
          ),
          YMargin(20),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Palette.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: EdgeInsets.symmetric(vertical: config.sh(14)),
            ),
            child: Text(
              "Submit for Review",
              style: TextStyles.mediumSemiBold.copyWith(color: Colors.white),
            ),
          ),
          YMargin(20),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.child,
    required this.cardColor,
    required this.borderColor,
  });

  final String title;
  final Widget child;
  final Color cardColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(config.sw(16)),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyles.largeSemiBold,
          ),
          YMargin(12),
          child,
        ],
      ),
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
  return TextField(
    minLines: maxLines,
    maxLines: maxLines,
    decoration: InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
}

Widget _dropdownField({
  required String? value,
  required String hint,
  required List<String> items,
  required ValueChanged<String?> onChanged,
}) {
  return DropdownButtonFormField<String>(
    value: value,
    decoration: InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
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