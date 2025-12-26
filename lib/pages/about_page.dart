import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:url_launcher/url_launcher_string.dart";
import "package:willshex_triangles/parts/app_drawer.dart";

class AboutPage extends StatelessWidget {
  static const String routePath = "/about";

  static Widget builder(BuildContext context, GoRouterState state) {
    return const AboutPage._();
  }

  const AboutPage._();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text("About"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("About",
                    style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 16),
                Text("Project", style: Theme.of(context).textTheme.titleLarge),
                const Text(
                    "Triangles is written and maintained by WillShex Limited for fun and because we like triangles (in case you have not noticed)."),
                const SizedBox(height: 16),
                Text("Software", style: Theme.of(context).textTheme.titleLarge),
                const Text(
                    "Triangles is built with Flutter and made possible by many open source libraries:"),
                _buildLink(context, "Flutter", "https://flutter.dev/"),
                _buildLink(context, "Romain Guy's blend modes",
                    "http://www.curious-creature.org/2006/09/20/new-blendings-modes-for-java2d/", isDead: true),,
                const SizedBox(height: 16),
                Text("Images", style: Theme.of(context).textTheme.titleLarge),
                const Text("Sample images and backgrounds are provided by:"),
                _buildLink(
                  context,
                  "Lorem Picsum",
                  "https://picsum.photos/",
                ),
                _buildLink(context, "Subtle Patterns",
                    "https://www.toptal.com/designers/subtlepatterns/"),
                const SizedBox(height: 16),
                Text("Legal", style: Theme.of(context).textTheme.titleLarge),
                const Text(
                    "You can use any of the images you generate/download for free for all commercial and non-commercial projects. We would love to hear from you about how you are using the images and for what projects. If you feel like giving us a mention we would really appreciate that too."),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  /// isDead is true if the link is dead
  ///
  Widget _buildLink(
    BuildContext context,
    String text,
    String url, {
    bool isDead = false,
  }) {
    return InkWell(
      onTap: () => isDead ? null : launchUrlString(url),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Text(
          text,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}
