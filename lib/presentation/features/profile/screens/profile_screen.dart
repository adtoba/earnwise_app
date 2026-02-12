import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/core/utils/spacer.dart';
import 'package:earnwise_app/presentation/styles/palette.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:earnwise_app/presentation/widgets/primary_button.dart';
import 'package:earnwise_app/presentation/widgets/search_textfield.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _firstNameController = TextEditingController(text: "Alex");
  final _lastNameController = TextEditingController(text: "Johnson");
  final _emailController = TextEditingController(text: "alex.johnson@email.com");
  final _phoneController = TextEditingController(text: "+1 415 555 0199");
  final _countryController = TextEditingController(text: "United States");
  final _stateController = TextEditingController(text: "California");
  final _cityController = TextEditingController(text: "San Francisco");
  final _streetController = TextEditingController(text: "123 Main St");
  final _zipController = TextEditingController(text: "94103");
  String? _gender;
  final List<String> _genders = ["Male", "Female", "Other"];

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _countryController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    _streetController.dispose();
    _zipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;


    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Profile",
          style: TextStyles.largeBold.copyWith(
            color: isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: config.sw(20), vertical: config.sh(12)),
        children: [
          Center(
            child: Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: config.sw(42),
                      backgroundImage: const NetworkImage(
                        "https://img.freepik.com/free-photo/portrait-confident-young-businessman-with-his-arms-crossed_23-2148176206.jpg?semt=ais_hybrid&w=740&q=80",
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Palette.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                YMargin(8),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "Change photo",
                    style: TextStyles.smallSemiBold.copyWith(color: Palette.primary),
                  ),
                ),
              ],
            ),
          ),
          YMargin(12),
          _SectionHeader(
            title: "Personal Information",
            isDarkMode: isDarkMode,
          ),
          _EditableField(
            label: "First name",
            controller: _firstNameController,
            isDarkMode: isDarkMode,
          ),
          _EditableField(
            label: "Last name",
            controller: _lastNameController,
            isDarkMode: isDarkMode,
          ),
          _DropdownField(
            label: "Gender",
            value: _gender,
            items: _genders,
            isDarkMode: isDarkMode,
            onChanged: (value) {
              setState(() {
                _gender = value;
              });
            },
          ),
          YMargin(12),
          _EditableField(
            label: "Email",
            controller: _emailController,
            isDarkMode: isDarkMode,
          ),
          _EditableField(
            label: "Phone number",
            controller: _phoneController,
            isDarkMode: isDarkMode,
            showDivider: false,
          ),
          YMargin(12),
          Divider(
            height: config.sh(12),
            color: isDarkMode ? Palette.borderDark : Palette.borderLight,
          ),
          YMargin(12),
          _SectionHeader(
            title: "Location",
            isDarkMode: isDarkMode,
          ),
          _EditableField(
            label: "Country",
            controller: _countryController,
            isDarkMode: isDarkMode,
          ),
          _EditableField(
            label: "State",
            controller: _stateController,
            isDarkMode: isDarkMode,
          ),
          _EditableField(
            label: "City",
            controller: _cityController,
            isDarkMode: isDarkMode,
          ),
          _EditableField(
            label: "Street",
            controller: _streetController,
            isDarkMode: isDarkMode,
          ),
          _EditableField(
            label: "Zip code",
            controller: _zipController,
            isDarkMode: isDarkMode,
            showDivider: false,
          ),
        ],
      ),
      persistentFooterButtons: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: config.sw(20), vertical: config.sh(12)),
          child: PrimaryButton(
            text: "Save Changes",
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}

class _EditableField extends StatelessWidget {
  const _EditableField({
    required this.label,
    required this.controller,
    required this.isDarkMode,
    this.showDivider = true,
  });

  final String label;
  final TextEditingController controller;
  final bool isDarkMode;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final secondaryTextColor = isDarkMode ? Palette.textGreyscale700Dark : Palette.textGreyscale700Light;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyles.smallRegular.copyWith(color: secondaryTextColor),
        ),
        YMargin(6),
        SearchTextField(
          controller: controller,
          hint: label,
        ),
        if (showDivider) YMargin(10),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.isDarkMode,
  });

  final String title;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: config.sh(20)),
      child: Text(
        title,
        style: TextStyles.largeSemiBold.copyWith(
          color: isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight,
        ),
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  const _DropdownField({
    required this.label,
    required this.value,
    required this.items,
    required this.isDarkMode,
    required this.onChanged,
  });

  final String label;
  final String? value;
  final List<String> items;
  final bool isDarkMode;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final secondaryTextColor = isDarkMode ? Palette.textGreyscale700Dark : Palette.textGreyscale700Light;
    final fillColor = isDarkMode ? Palette.darkFillColor : Palette.lightFillColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyles.smallRegular.copyWith(color: secondaryTextColor),
        ),
        YMargin(6),
        Theme(
          data: Theme.of(context).copyWith(
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: fillColor,
              contentPadding: EdgeInsets.symmetric(horizontal: config.sw(12), vertical: config.sh(10)),
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
            ),
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            decoration: const InputDecoration(),
            items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
            onChanged: onChanged,
          ),
        ),
        YMargin(10),
      ],
    );
  }
}