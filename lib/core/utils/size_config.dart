// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/widgets.dart'
    show
        BuildContext,
        MediaQuery,
        MediaQueryData,
        EdgeInsets,
        RenderBox,
        Offset;

/// Base design dimensions (typically iPhone 14 Pro or similar standard device)
/// These are used as reference points for scaling
class _DesignDimensions {
  static const double designWidth = 393.0; // Standard mobile width
  static const double designHeight = 852.0; // Standard mobile height
}

class _TpDimension {
  MediaQueryData? _queryData;

  _TpDimension(BuildContext context) {
    _queryData = MediaQuery.of(context);
  }

  double get topInset {
    return _queryData!.padding.top;
  }

  double get bottomInset {
    return _queryData!.padding.bottom;
  }

  /// Actual screen width (not shortest side)
  double get width {
    return _queryData!.size.width;
  }

  /// Actual screen height (not longest side)
  double get height {
    return _queryData!.size.height;
  }

  /// Get width scale factor based on design width
  double get widthScale {
    return width / _DesignDimensions.designWidth;
  }

  /// Get height scale factor based on design height
  double get heightScale {
    return height / _DesignDimensions.designHeight;
  }

  /// Get a balanced scale factor (average of width and height scales)
  /// This prevents extreme scaling on very wide or very tall screens
  double get balancedScale {
    return (widthScale + heightScale) / 2;
  }

  /// Set height as percentage of screen height
  /// [percentage] should be between 0-100
  double setHeight(double percentage) {
    if (percentage == 0) return 0;
    return height * (percentage.clamp(0.0, 100.0) / 100);
  }

  /// Set width as percentage of screen width
  /// [percentage] should be between 0-100
  double setWidth(double percentage) {
    if (percentage == 0) return 0;
    return width * (percentage.clamp(0.0, 100.0) / 100);
  }
}

class _TpFontSizer {
  MediaQueryData? _queryData;
  _TpDimension? _dimension;

  _TpFontSizer(BuildContext context, _TpDimension dimension) {
    _queryData = MediaQuery.of(context);
    _dimension = dimension;
  }

  /// Calculate font size based on screen size and design reference
  /// This ensures fonts scale proportionally across different screen sizes
  double _calculateBaseFontSize(double fontSize) {
    // Use balanced scale for more consistent scaling
    final scale = _dimension!.balancedScale;

    // Apply scale to font size with min/max constraints
    final scaledSize = fontSize * scale;
    
    // Clamp to reasonable bounds (min 8sp, max 200sp)
    return scaledSize.clamp(8.0, 200.0);
  }

  /// Get text scale factor from system accessibility settings
  double get textScaleFactor {
    // Prevent system small text sizes from shrinking app typography too far.
    return _queryData!.textScaleFactor.clamp(1.0, 2.0);
  }

  /// Calculate responsive font size in scaled pixels (sp)
  /// [fontSize] is the base font size in logical pixels
  /// Returns a size that scales with screen size and respects accessibility
  double sp(double fontSize) {
    final baseSize = _calculateBaseFontSize(fontSize);
    // Apply system text scale factor for accessibility
    return baseSize * textScaleFactor;
  }
}

class SizeConfig {
  factory SizeConfig() {
    if (_instance == null) {
      throw Exception(
          'SizeConfig not initialized. Call SizeConfig.init(context) first.');
    }
    return _instance!;
  }
  SizeConfig._();

  static SizeConfig? _instance;
  static _TpFontSizer? fontSizer;
  static _TpDimension? sizer;

  /// Initialize SizeConfig with BuildContext
  /// Should be called in the root widget's build method
  /// This allows the config to update when MediaQuery changes
  static void init(BuildContext context) {
    _instance ??= SizeConfig._();
    sizer = _TpDimension(context);
    fontSizer = _TpFontSizer(context, sizer!);
  }

  /// Update SizeConfig with new context (useful for orientation changes)
  static void update(BuildContext context) {
    sizer = _TpDimension(context);
    fontSizer = _TpFontSizer(context, sizer!);
  }

  /// Get responsive font size in scaled pixels (sp)
  /// [fontSize] is the base font size (e.g., 16 for body text, 24 for headings)
  /// Automatically scales based on screen size and respects accessibility settings
  double sp(double fontSize) {
    return fontSizer!.sp(fontSize);
  }

  /// Get responsive height in logical pixels
  /// [pixels] is the desired height in logical pixels (scales based on screen size)
  /// This scales proportionally using a balanced scale factor
  /// Example: sh(160) returns a height that scales with screen size
  double sh(double pixels) {
    return pixels * sizer!.balancedScale;
  }

  /// Get responsive width in logical pixels
  /// [pixels] is the desired width in logical pixels (scales based on screen size)
  /// This scales proportionally using a balanced scale factor
  /// Example: sw(160) returns a width that scales with screen size
  double sw(double pixels) {
    return pixels * sizer!.balancedScale;
  }

  /// Get height as percentage of screen height
  /// [percentage] should be between 0-100 (e.g., 50 for 50% of screen height)
  double shPercent(double percentage) {
    return sizer!.setHeight(percentage);
  }

  /// Get width as percentage of screen width
  /// [percentage] should be between 0-100 (e.g., 50 for 50% of screen width)
  double swPercent(double percentage) {
    return sizer!.setWidth(percentage);
  }

  /// Get width scale factor (useful for custom scaling)
  double get widthScale => sizer!.widthScale;

  /// Get height scale factor (useful for custom scaling)
  double get heightScale => sizer!.heightScale;

  /// Get balanced scale factor (average of width and height scales)
  double get balancedScale => sizer!.balancedScale;

  /// Get actual screen width
  double get screenWidth => sizer!.width;

  /// Get actual screen height
  double get screenHeight => sizer!.height;

  /// Get top safe area inset
  double get topInset => sizer!.topInset;

  /// Get bottom safe area inset
  double get bottomInset => sizer!.bottomInset;
}

class _TpInsets {
  _TpDimension? sizer;

  _TpInsets(BuildContext context) {
    sizer = _TpDimension(context);
  }

  EdgeInsets get zero {
    return EdgeInsets.zero;
  }

  EdgeInsets all(double inset) {
    return EdgeInsets.all(sizer!.setWidth(inset));
  }

  EdgeInsets only({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) {
    return EdgeInsets.only(
      top: sizer!.setHeight(top),
      left: sizer!.setWidth(left),
      bottom: sizer!.setHeight(bottom),
      right: sizer!.setWidth(right),
    );
  }

  EdgeInsets fromLTRB(
    double left,
    double top,
    double right,
    double bottom,
  ) {
    return EdgeInsets.fromLTRB(
      sizer!.setWidth(left),
      sizer!.setHeight(top),
      sizer!.setWidth(right),
      sizer!.setHeight(bottom),
    );
  }

  EdgeInsets symmetric({
    double vertical = 0,
    double horizontal = 0,
  }) {
    return EdgeInsets.symmetric(
      vertical: sizer!.setHeight(vertical),
      horizontal: sizer!.setWidth(horizontal),
    );
  }
}

class TpScaleUtil {
  final BuildContext context;

  TpScaleUtil(this.context);

  _TpDimension get sizer => _TpDimension(context);
  _TpFontSizer get fontSizer {
    final dimension = _TpDimension(context);
    return _TpFontSizer(context, dimension);
  }
  _TpInsets get insets => _TpInsets(context);
}

Offset getPos(BuildContext context) {
  final RenderBox box = context.findRenderObject() as RenderBox;
  return box.localToGlobal(Offset.zero);
}