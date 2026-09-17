import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:url_launcher/url_launcher_string.dart";
import "package:client_common/client_common.dart";
import "package:client_flutter/parts/app_drawer.dart";

/// Pure content view for About, decoupled from Scaffold, AppBar, and AppDrawer.
class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
    );
  }

  Widget _buildLink(
    BuildContext context,
    String text,
    String url, {
    bool isDead = false,
  }) {
    final primary = Theme.of(context).colorScheme.primary;
    if (isDead) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Text(
          text,
          style: TextStyle(
            color: primary,
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
            color: primary,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}

/// Full page wrapper for AboutPage.
class AboutPage extends StatelessWidget {
  static const String routePath = "/about";

  final bool showDrawer;
  final bool showAppBar;
  final TrianglesRoutePaths paths;

  AboutPage({
    this.showDrawer = true,
    this.showAppBar = true,
    TrianglesRoutePaths? paths,
    String? basePath,
    super.key,
  }) : paths = paths ??
            (basePath != null && basePath.isNotEmpty
                ? TrianglesRoutePaths.withPrefix(basePath)
                : const TrianglesRoutePaths());

  static Widget builder(BuildContext context, GoRouterState state) {
    return AboutPage();
  }

  @override
  Widget build(BuildContext context) {
    const body = AboutView();
    if (!showAppBar && !showDrawer) {
      return body;
    }

    return Scaffold(
      drawer: showDrawer ? AppDrawer(paths: paths) : null,
      appBar: showAppBar
          ? AppBar(
              title: const Text(AppStrings.navAbout),
            )
          : null,
      body: body,
    );
  }
}
