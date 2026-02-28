import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/presentation/styles/palette.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:flutter/material.dart';

class AcceptButton extends StatelessWidget {
  const AcceptButton({super.key, required this.onPressed, this.text = "Accept"});

  final VoidCallback? onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    var isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Palette.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: EdgeInsets.symmetric(vertical: config.sh(12)),
      ),
      label: Text(
        text,
        style: TextStyles.mediumSemiBold.copyWith(color: Colors.white),
      ),
      icon: const Icon(Icons.check_circle, size: 18),
    );
  }
}
