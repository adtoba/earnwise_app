import 'package:earnwise_app/core/utils/size_config.dart';
import 'package:earnwise_app/presentation/styles/palette.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class SearchTextField extends StatefulWidget {
  const SearchTextField({
    Key? k,
    this.label,
    this.onChanged,
    this.onTap,
    this.focusNode,
    this.hasFocus = false,
    this.prefix,
    this.nextNode,
    this.validator,
    this.obscureText = false,
    this.enabled = true,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization,
    this.maxLines = 1,
    this.inputFormatters,
    this.suffix,
    this.hint,
    this.onEditingComplete,
    this.isSearchField = false,
    this.isPassword = false,
    this.isDense = false,
    this.controller,
    this.floatingLabelBehavior
  }) : super(key: k);

  final String? hint;
  final String? label;
  final Function()? onEditingComplete;
  final Function(String)? onChanged;
  final Function()? onTap;
  final TextEditingController? controller;
  final bool? hasFocus;
  final bool enabled;
  final int maxLines;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final FocusNode? nextNode;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final bool obscureText;
  final bool isDense;
  final bool isSearchField;
  final bool isPassword;
  final TextInputAction? textInputAction;
  final TextCapitalization? textCapitalization;
  final Widget? suffix;
  final Widget? prefix;
  final FloatingLabelBehavior? floatingLabelBehavior;

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {

  @override
  Widget build(BuildContext context) {
    final config = SizeConfig();
    var brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;

    return SizedBox(
      height: config.sh(56),
      child: TextFormField(
        controller: widget.controller,
        onChanged: widget.onChanged,
        onTap: widget.onTap,
        focusNode: widget.focusNode,
        obscureText: widget.obscureText,
        keyboardType: widget.keyboardType,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        inputFormatters: widget.inputFormatters,
        textCapitalization: widget.textCapitalization ?? TextCapitalization.none,
        enabled: widget.enabled,
        style: TextStyles.largeSemiBold,
        textInputAction: widget.textInputAction,
        maxLines: widget.maxLines,
        validator: widget.validator,
        onEditingComplete: widget.onEditingComplete,
        onFieldSubmitted: (String val) {
          FocusScope.of(context).requestFocus(widget.nextNode);
        },
        decoration: InputDecoration(
          hintText: widget.hint,
          labelText: widget.label,
          isDense: widget.isDense,
          suffixIcon: Padding(
            padding: EdgeInsets.only(left: widget.suffix != null ? config.sw(16) : 0, right: widget.suffix != null ? config.sw(16) : 0),
            child: widget.suffix,
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: widget.prefix != null ? config.sw(16) : 0, right: widget.prefix != null ? config.sw(16) : 0),
            child: widget.prefix,
          ),
          prefixIconConstraints: BoxConstraints(
            minWidth: config.sw(20),
            minHeight: config.sh(20),
            maxWidth: config.sw(80),
            maxHeight: config.sh(80),
          ),
          suffixIconConstraints: BoxConstraints(
            minWidth: config.sw(20),
            minHeight: config.sh(20),
            maxWidth: config.sw(56),
            maxHeight: config.sh(56),
          ),
          floatingLabelBehavior: widget.floatingLabelBehavior,
          suffixIconColor: isDarkMode ? const Color(0xffD9C6FF) : const Color(0xff9CA3AF),
          labelStyle: TextStyle(
            fontSize: config.sp(15),
          ),
          hintStyle: TextStyles.mediumRegular.copyWith(
            // color:Color(0xff9E9E9E),
          ),
          errorStyle: TextStyle(
            fontSize: config.sp(14),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16),
          filled: true,
          fillColor: isDarkMode ? Palette.darkFillColor : Palette.lightFillColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none
          ),
          focusColor: Palette.primary,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.red),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.red),
          ),
        ),
      ),
    );
  }

  OutlineInputBorder border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(1000),
    borderSide: BorderSide.none
  );
}