import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({super.key, required this.text, required this.onPressed, required this.isLoading, required this.color, required this.prefixIcon});

  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final Color color;
  final String prefixIcon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: config.sh(50),
      child: ElevatedButton.icon(
        onPressed: onPressed, 
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        label: Text(text, style: TextStyles.mediumSemiBold.copyWith(color: Colors.black)),
        icon: Image.asset(
          prefixIcon,
          width: config.sw(20),
          height: config.sh(20),
        ),
      ),
    );
  }
}