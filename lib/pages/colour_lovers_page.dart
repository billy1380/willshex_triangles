import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:willshex_triangles/parts/app_drawer.dart";

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
        title: const Text("COLOURLovers Palette"),
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
                // Error Placeholder
                // if (error) ...
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
          // History Sidebar
          Container(
            width: 250,
            decoration: BoxDecoration(
              border: Border(left: BorderSide(color: Colors.grey[300]!)),
            ),
            child: const Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("History",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  child: Center(child: Text("Palette History View")),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
