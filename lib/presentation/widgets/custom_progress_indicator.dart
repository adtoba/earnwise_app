import 'package:earnwise_app/core/constants/constants.dart';
import 'package:flutter/material.dart';

class CustomProgressIndicator extends StatelessWidget {
  const CustomProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    var brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;

    return SizedBox(
      width: config.sw(25),
      height: config.sh(25),
      child: CircularProgressIndicator(
        color: isDarkMode ? Colors.white : Colors.black,
      ),
    );
  }
}