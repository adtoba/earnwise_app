import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class OnesignalService {

  static void initialize() {
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

    OneSignal.initialize(dotenv.env['ONESIGNAL_APP_ID'] ?? "");

    OneSignal.Notifications.clearAll();
    

    OneSignal.User.pushSubscription.addObserver((state) {

    });

    
    OneSignal.Notifications.addPermissionObserver((state) {

    });

    OneSignal.Notifications.addClickListener((event) {
    });



    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      // /// Display Notification, preventDefault to not display
      // event.preventDefault();
      /// notification.display() to display after preventing default
      event.notification.display();
    });

  }
}