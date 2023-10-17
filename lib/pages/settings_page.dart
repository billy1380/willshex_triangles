import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:willshex_triangles/parts/app_drawer.dart';

class SettingsPage extends StatefulWidget {
  static const String routePath = "/settings";

  static Widget builder(BuildContext context, GoRouterState state) {
    return const SettingsPage._();
  }

  const SettingsPage._();

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Settings page"),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Settings page body",
            ),
          ],
        ),
      ),
    );
  }
}
