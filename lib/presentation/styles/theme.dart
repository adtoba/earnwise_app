import 'package:earnwise_app/presentation/styles/palette.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
    brightness: Brightness.light,
    fontFamily: TextStyles.fontFamily,
    primaryColor: Palette.primary,
    scaffoldBackgroundColor: Palette.lightBackground,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Palette.lightBackground,
      selectedItemColor: Palette.primary,
      unselectedItemColor: Color(0xff9E9E9E),
      selectedLabelStyle: TextStyles.mediumMedium.copyWith(
        color: Palette.primary,
      ),
      unselectedLabelStyle: TextStyles.mediumMedium.copyWith(
        color: Color(0xff9E9E9E),
      ),
      showSelectedLabels: true,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      selectedIconTheme: IconThemeData(
        color: Palette.primary,
      ),
      unselectedIconTheme: IconThemeData(
        color: Color(0xff9E9E9E),
      ),
    ),
    appBarTheme: AppBarTheme(
      scrolledUnderElevation: 0,
      backgroundColor: Palette.lightBackground,
      iconTheme: IconThemeData(color: Palette.darkBackground),
      titleTextStyle: TextStyle(
        fontFamily: TextStyles.fontFamily,
        color: Palette.textGeneralLight, 
        fontSize: 16, 
        fontWeight: FontWeight.bold
      ),
      elevation: 0,
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: Palette.secondary,
      selectionColor: Palette.secondary,
      selectionHandleColor: Palette.secondary,
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Palette.textGeneralLight),
      bodyMedium: TextStyle(color: Palette.textGeneralLight),
      bodySmall: TextStyle(color: Palette.textGeneralLight),
      titleLarge: TextStyle(color: Palette.textGeneralLight),
      titleMedium: TextStyle(color: Palette.textGeneralLight),
      titleSmall: TextStyle(color: Palette.textGeneralLight),
      labelLarge: TextStyle(color: Palette.textGeneralLight),
      labelMedium: TextStyle(color: Palette.textGeneralLight),
      labelSmall: TextStyle(color: Palette.textGeneralLight),
      headlineLarge: TextStyle(color: Palette.textGeneralLight),
      headlineMedium: TextStyle(color: Palette.textGeneralLight),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        textStyle: TextStyle(
          fontFamily: TextStyles.fontFamily,
          color: Palette.textGeneralLight,
          fontSize: 16,
          fontWeight: FontWeight.bold
        ),
        backgroundColor: Palette.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(1000),
        ),
      ),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: Palette.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(1000),
      ),
    )
  );

  static ThemeData get dark => ThemeData(
    brightness: Brightness.dark,
    fontFamily: TextStyles.fontFamily,
    primaryColor: Palette.primary,
    scaffoldBackgroundColor: Palette.darkBackground,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Palette.darkBackground,
      selectedItemColor: Palette.primary,
      unselectedItemColor: Color(0xff9E9E9E),
      selectedLabelStyle: TextStyles.mediumMedium.copyWith(
        color: Palette.primary,
      ),
      unselectedLabelStyle: TextStyles.mediumMedium.copyWith(
        color: Color(0xff9E9E9E),
      ),
      showSelectedLabels: true,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      selectedIconTheme: IconThemeData(
        color: Palette.primary,
      ),
      unselectedIconTheme: IconThemeData(
        color: Color(0xff9E9E9E),
      ),
    ),
    appBarTheme: AppBarTheme(
      scrolledUnderElevation: 0,
      backgroundColor: Palette.darkBackground,
      iconTheme: IconThemeData(color: Palette.textGeneralDark),
      titleTextStyle: TextStyle(
        fontFamily: TextStyles.fontFamily,
        color: Palette.textGeneralDark, 
        fontSize: 16, 
        fontWeight: FontWeight.bold
      ),
      elevation: 0,
      centerTitle: true

    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: Palette.secondary,
      selectionColor: Palette.secondary,
      selectionHandleColor: Palette.secondary,
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Palette.textGeneralDark),
      bodyMedium: TextStyle(color: Palette.textGeneralDark),
      bodySmall: TextStyle(color: Palette.textGeneralDark),
      titleLarge: TextStyle(color: Palette.textGeneralDark),
      titleMedium: TextStyle(color: Palette.textGeneralDark),
      titleSmall: TextStyle(color: Palette.textGeneralDark),
      labelLarge: TextStyle(color: Palette.textGeneralDark),
      labelMedium: TextStyle(color: Palette.textGeneralDark),
      labelSmall: TextStyle(color: Palette.textGeneralDark),
      headlineLarge: TextStyle(color: Palette.textGeneralDark),
      headlineMedium: TextStyle(color: Palette.textGeneralDark),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        textStyle: TextStyle(
          fontFamily: TextStyles.fontFamily,
          color: Palette.textGeneralDark,
          fontSize: 16,
          fontWeight: FontWeight.bold
        ),
        backgroundColor: Palette.darkBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(1000),
        ),
      ),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: Palette.darkBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(1000),
      ),
    )
  );
}