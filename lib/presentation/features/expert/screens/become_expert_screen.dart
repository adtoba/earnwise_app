import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/core/providers/expert_provider.dart';
import 'package:earnwise_app/core/utils/input_validator.dart';
import 'package:earnwise_app/core/utils/navigator.dart';
import 'package:earnwise_app/core/utils/spacer.dart';
import 'package:earnwise_app/domain/dto/create_expert_profile_dto.dart';
import 'package:earnwise_app/domain/dto/update_expert_rate_dto.dart';
import 'package:earnwise_app/presentation/features/expert/screens/expert_set_availability_screen.dart';
import 'package:earnwise_app/presentation/features/expert/screens/set_rates_screen.dart';
import 'package:earnwise_app/presentation/features/settings/screens/expert_category_selection_screen.dart';
import 'package:earnwise_app/presentation/styles/palette.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:earnwise_app/presentation/widgets/primary_button.dart';
import 'package:earnwise_app/presentation/widgets/search_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BecomeExpertScreen extends ConsumerStatefulWidget {
  const BecomeExpertScreen({super.key});

  @override
  ConsumerState<BecomeExpertScreen> createState() => _BecomeExpertScreenState();
}

class _BecomeExpertScreenState extends ConsumerState<BecomeExpertScreen> {
  final List<String> _selectedCategories = [];
  final formKey = GlobalKey<FormState>();
  
  final professionalTitleController = TextEditingController();
  final bioController = TextEditingController();
  final question1Controller = TextEditingController();
  final question2Controller = TextEditingController();
  final question3Controller = TextEditingController();
  final textResponseRateController = TextEditingController();
  final videoResponseRateController = TextEditingController();
  final videoCallRateController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final expertProvider = ref.watch(expertNotifier);
    var brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;

    final secondaryTextColor = isDarkMode 
      ? Palette.textGreyscale700Dark 
      : Palette.textGreyscale700Light;
    final sectionBorderColor = isDarkMode 
      ? Palette.borderDark 
      : Palette.borderLight;

    

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
      body: Form(
        key: formKey,
        child: ListView(
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
                  _LabeledField(
                    label: "Professional title", 
                    child: _textField(
                      controller: professionalTitleController,
                      hint: "Business Consultant",
                      validator: InputValidator.validateField
                    )
                  ),
                  YMargin(12),
                  _LabeledField(
                    label: "Bio",
                    child: _textField(
                      controller: bioController,
                      hint: "Tell clients about your expertise", 
                      maxLines: 4,
                      validator: InputValidator.validateField
                    ),
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
                  _LabeledField(
                    label: "Question 1", 
                    child: _textField(
                      hint: "How do I get started?",
                      controller: question1Controller,
                      validator: InputValidator.validateField
                    )
                  ),
                  YMargin(12),
                  _LabeledField(
                    label: "Question 2", 
                    child: _textField(
                      hint: "What do you specialize in?",
                      controller: question2Controller,
                      validator: InputValidator.validateField
                    )
                  ),
                  YMargin(12),
                  _LabeledField(
                    label: "Question 3", 
                    child: _textField(
                      hint: "How do I contact you?",
                      controller: question3Controller,
                      validator: InputValidator.validateField
                    )
                  ),
                ],
              ),
            ),
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
                    controller: textResponseRateController,
                    validator: InputValidator.validateField,
                    showDivider: true,
                  ),
                  RateRowInline(
                    title: "Video response",
                    subtitle: "(Min. \$20 per response)",
                    hint: "\$20 / response",
                    isDarkMode: isDarkMode,
                    controller: videoResponseRateController,
                    validator: InputValidator.validateField,
                    showDivider: true,
                  ),
                  RateRowInline(
                    title: "Video call",
                    subtitle: "(Min. \$1 per minute)",
                    hint: "\$1 / minute",
                    isDarkMode: isDarkMode,
                    controller: videoCallRateController,
                    validator: InputValidator.validateField,
                    showDivider: false,
                  ),
                ],
              ),
            ),
            YMargin(20),
          ],
        ),
      ),
      persistentFooterButtons: [
        Padding(
          padding: EdgeInsetsGeometry.symmetric(
            horizontal: config.sw(20),
          ),
          child: PrimaryButton(
            text: "Next", 
            onPressed: () {
              if(formKey.currentState!.validate() && _selectedCategories.isNotEmpty) {
                expertProvider.createExpertProfileDto = CreateExpertProfileDto(
                  professionalTitle: professionalTitleController.text,
                  bio: bioController.text,
                  categories: _selectedCategories,
                  faq: [question1Controller.text, question2Controller.text, question3Controller.text],
                  rates: UpdateExpertRateDto(
                    textRate: double.parse(textResponseRateController.text),
                    videoRate: double.parse(videoResponseRateController.text),
                    callRate: double.parse(videoCallRateController.text),
                  ),
                );
                push(ExpertSetAvailabilityScreen(
                  isEditMode: false,
                ));
              }
             
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

Widget _textField({required String hint, int maxLines = 1, TextEditingController? controller, String? Function(String?)? validator}) {
  return SearchTextField(
    hint: hint,
    maxLines: maxLines,
    controller: controller,
    validator: validator,
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