import 'package:earnwise_app/core/providers/auth_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final settingsNotifier = ChangeNotifierProvider((ref) => SettingsProvider(ref));

class SettingsProvider extends ChangeNotifier {

  late final Ref ref;

  SettingsProvider(Ref r) {
    ref = r;
  }

  void goToNotifications() {

  }

  void goToPrivacyAndSecurity() {

  }

  void goToHelpAndSupport() {

  }

  void goToTermsAndConditions() {

  }

  void goToPrivacyPolicy() {

  }

  void goToAbout() {

  }

  void goToLogout() {
    ref.read(authNotifier).logout();
  }
}