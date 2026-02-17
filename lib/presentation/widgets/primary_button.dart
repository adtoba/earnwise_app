import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/presentation/styles/palette.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:earnwise_app/presentation/widgets/custom_progress_indicator.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({super.key, required this.text, required this.onPressed, this.isLoading = false});

  final String text;
  final VoidCallback onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: double.infinity,
      height: config.sh(45),
      onPressed: isLoading ? () {} : onPressed,
      color: Palette.primary,
      disabledColor: Palette.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40)
      ),
      child: isLoading 
        ? SizedBox(
            width: config.sw(25),
            height: config.sh(25),
            child: CustomProgressIndicator(),
          ) 
        : Text(
            text, 
            style: TextStyles.largeSemiBold.copyWith(
              color: Colors.white
            )
          ),
    );
  }
}