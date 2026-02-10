import 'package:earnwise_app/main.dart';
import 'package:flutter/material.dart';

void push(Widget screen) {
  navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) {
    return screen;
  }));
}

void pushAndReplace(Widget screen) {
  navigatorKey.currentState!.pushReplacement(MaterialPageRoute(builder: (context) {
    return screen;
  }));
}

void pushAndRemoveUntil(Widget screen) {
  navigatorKey.currentState!.pushAndRemoveUntil(MaterialPageRoute(builder: (ctx) {
    return screen;
  }), (route) => false);
}

void pop() {
  navigatorKey.currentState!.pop();
}