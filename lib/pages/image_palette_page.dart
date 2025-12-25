import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:willshex_triangles/parts/app_drawer.dart";

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
        title: const Text("From Image"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("TTB Hexagons over image",
                style: Theme.of(context).textTheme.titleMedium),
          ),
          // Toolbar Placeholder
          Container(
            height: 50,
            color: Colors.grey[200],
            child: const Center(child: Text("Image Toolbar Placeholder")),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      color: Colors.white,
                    ),
                    child: const Center(child: Text("Canvas Placeholder")),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      color: Colors.grey[100],
                    ),
                    child: const Center(
                        child: Text("Image Placeholder\n(Upload/Drop)")),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
