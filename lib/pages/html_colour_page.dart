import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:willshex_triangles/parts/app_drawer.dart';

class HtmlColourPage extends StatefulWidget {
  static const String routePath = "/htmlcolour";

  static Widget builder(BuildContext context, GoRouterState state) {
    return const HtmlColourPage._();
  }

  const HtmlColourPage._();

  @override
  State<HtmlColourPage> createState() => _HtmlColourPageState();
}

class _HtmlColourPageState extends State<HtmlColourPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("HtmlColour page"),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "HtmlColour page body",
            ),
          ],
        ),
      ),
    );
  }
}
