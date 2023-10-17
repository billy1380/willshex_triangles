import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:willshex_triangles/parts/app_drawer.dart';

class ImagePalettePage extends StatefulWidget {
  static const String routePath = "/imagepalette";

  static Widget builder(BuildContext context, GoRouterState state) {
    return const ImagePalettePage._();
  }

  const ImagePalettePage._();

  @override
  State<ImagePalettePage> createState() => _ImagePalettePageState();
}

class _ImagePalettePageState extends State<ImagePalettePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Image Palette page"),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Image Palette page body",
            ),
          ],
        ),
      ),
    );
  }
}
