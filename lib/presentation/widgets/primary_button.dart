import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/presentation/styles/palette.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({super.key, required this.text, required this.onPressed});

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: double.infinity,
      height: config.sh(45),
      onPressed: onPressed,
      color: Palette.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40)
      ),
      child: Text(
        text, 
        style: TextStyles.largeSemiBold.copyWith(
          color: Colors.white
        )
      ),
    );
  }
}