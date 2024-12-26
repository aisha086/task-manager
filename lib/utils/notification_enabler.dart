import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PushNotificationHandler extends ChangeNotifier {
  bool _isNotificationEnabled = true;

  bool get isNotificationEnabled => _isNotificationEnabled;

  PushNotifHandler() {
    _loadNotificationPreference(); // Load the saved notification state
  }

  void toggleNotification() async {
    _isNotificationEnabled = !_isNotificationEnabled;
    notifyListeners();
    await _saveNotificationPreference();
  }

  Future<void> _loadNotificationPreference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _isNotificationEnabled = prefs.getBool('notifications_enabled') ?? false;
    notifyListeners();
  }

  Future<void> _saveNotificationPreference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', _isNotificationEnabled);
  }
}
