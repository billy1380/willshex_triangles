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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("About", style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 16),
            Text("Project", style: Theme.of(context).textTheme.titleLarge),
            const Text(
                "Triangles is written and maintained by SPACEHOPPER STUDIOS LTD for fun and because we like triangles (in case you have not noticed)."),
            const SizedBox(height: 16),
            Text("Software", style: Theme.of(context).textTheme.titleLarge),
            const Text(
                "Triangles is possible because of tons of software we did not actually write."),
            _buildLink(context, "GWT", "http://www.gwtproject.org/"),
            _buildLink(context, "Bootstrap", "http://getbootstrap.com/"),
            _buildLink(
                context, "COLOUR Lovers", "http://www.colourlovers.com/api"),
            _buildLink(context, "Romain Guy's blend modes",
                "http://www.curious-creature.org/2006/09/20/new-blendings-modes-for-java2d/"),
            const SizedBox(height: 16),
            Text("Images", style: Theme.of(context).textTheme.titleLarge),
            const Text(
                "We have used some images on the site and here is where they came from."),
            _buildLink(
              context,
              "PlaceIMG",
              "http://placeimg.com/",
              isDead: true,
            ),
            _buildLink(
                context, "Subtle background", "http://subtlepatterns.com/"),
            const SizedBox(height: 16),
            Text("Roadmap", style: Theme.of(context).textTheme.titleLarge),
            const Text("• Add settings e.g. triangle size..."),
            const Text(
                "• Make generated cavases downloadable via app-engine service"),
            const Text(
                "• Integrate more colour services - Update: for some reason random queries on Kuler started to return the same colour palette, so I switched to using COLOURLovers, not sure if there are any others out there."),
            const SizedBox(height: 16),
            Text("Legal", style: Theme.of(context).textTheme.titleLarge),
            const Text(
                "You can use any of the images you generate/download for free for all commercial and non-commercial projects. We would also love to hear from you about how you are using the images and for what projects. Finally if you feel like giving us a mention we would really appreciate that too."),
            const SizedBox(height: 8),
            const Text(
                "SPACEHOPPER STUDIOS Logo is property of SPACEHOPPER STUDIOS LTD."),
            const SizedBox(height: 16),
            Text("Social", style: Theme.of(context).textTheme.titleLarge),
            const Text(
                "If you like this follow us on Google+ and Twitter - we have a Facebook page too."),
          ],
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
