import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:willshex_triangles/parts/app_drawer.dart';

class ColourLoversPage extends StatefulWidget {
  static const String routePath = "/colourlovers";

  static Widget builder(BuildContext context, GoRouterState state) {
    return const ColourLoversPage._();
  }

  const ColourLoversPage._();

  @override
  State<ColourLoversPage> createState() => _ColourLoversPageState();
}

class _ColourLoversPageState extends State<ColourLoversPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("ColourLovers page"),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "ColourLovers page body",
            ),
          ],
        ),
      ),
    );
  }
}
