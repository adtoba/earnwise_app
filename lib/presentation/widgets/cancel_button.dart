import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:flutter/material.dart';

class CancelButton extends StatelessWidget {
  const CancelButton({super.key, required this.onPressed, this.text = "Cancel"});

  final VoidCallback onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    var isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return OutlinedButton.icon(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: isDarkMode ? Colors.red.shade300 : Colors.red.shade400),
        foregroundColor: isDarkMode ? Colors.red.shade200 : Colors.red.shade600,
        backgroundColor: isDarkMode ? Colors.red.withOpacity(0.12) : Colors.red.withOpacity(0.08),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: EdgeInsets.symmetric(vertical: config.sh(12)),
      ),
      label: Text(
        text,
        style: TextStyles.mediumSemiBold.copyWith(
          color: isDarkMode ? Colors.red.shade200 : Colors.red.shade600,
        ),
      ),
      icon: Icon(Icons.close, size: 18),
    );
  }
}
