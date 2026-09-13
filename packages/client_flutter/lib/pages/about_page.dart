import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:url_launcher/url_launcher_string.dart";
import "package:client_common/client_common.dart";
import "package:client_flutter/parts/app_drawer.dart";

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
        title: const Text(AppStrings.navAbout),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppStrings.aboutProjectTitle,
                    style: Theme.of(context).textTheme.titleLarge),
                const Text(AppStrings.aboutProjectDescription),
                const SizedBox(height: 16),
                Text(AppStrings.aboutSoftwareTitle,
                    style: Theme.of(context).textTheme.titleLarge),
                const Text(AppStrings.aboutSoftwareDescription),
                _buildLink(context, AppStrings.aboutFlutterLink,
                    AppStrings.aboutFlutterUrl),
                _buildLink(
                  context,
                  AppStrings.aboutRomainGuyLink,
                  AppStrings.aboutRomainGuyUrl,
                  isDead: true,
                ),
                const SizedBox(height: 16),
                Text(AppStrings.aboutImagesTitle,
                    style: Theme.of(context).textTheme.titleLarge),
                const Text(AppStrings.aboutImagesDescription),
                _buildLink(
                  context,
                  AppStrings.aboutLoremPicsumLink,
                  AppStrings.aboutLoremPicsumUrl,
                ),
                _buildLink(context, AppStrings.aboutSubtlePatternsLink,
                    AppStrings.aboutSubtlePatternsUrl),
                const SizedBox(height: 16),
                Text(AppStrings.aboutLegalTitle,
                    style: Theme.of(context).textTheme.titleLarge),
                const Text(AppStrings.aboutLegalDescription),
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
    if (isDead) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Text(
          text,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }
    return InkWell(
      onTap: () => launchUrlString(url),
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
