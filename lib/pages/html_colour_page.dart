import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:willshex_triangles/parts/app_drawer.dart";

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
        title: const Text("HTML Colour"),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              children: [
                // Toolbar Placeholder
                Container(
                  height: 50,
                  color: Colors.grey[200],
                  child:
                      const Center(child: Text("Palette Toolbar Placeholder")),
                ),
                Expanded(
                  child: Center(
                    child: Container(
                      width: 300,
                      height: 300,
                      color: Colors.white,
                      child: const Center(child: Text("Canvas Placeholder")),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Sidebar
          Container(
            width: 250,
            decoration: BoxDecoration(
              border: Border(left: BorderSide(color: Colors.grey[300]!)),
            ),
            child: const Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Manual Palette Input",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  child: Center(child: Text("Color Inputs Placeholder")),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
