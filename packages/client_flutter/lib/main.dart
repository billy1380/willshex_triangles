import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:willshex/willshex.dart";
import "package:client_flutter/app.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLogging();
  final prefs = await SharedPreferences.getInstance();

  runApp(App(prefs: prefs));
}
