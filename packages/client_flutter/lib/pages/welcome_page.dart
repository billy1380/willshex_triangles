import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:client_common/client_common.dart";
import "package:client_flutter/parts/app_drawer.dart";

/// Pure content view for Welcome, decoupled from Scaffold, AppBar, and AppDrawer.
/// Can be embedded inside any existing Scaffold, tab, container, or dialog.
class WelcomeView extends StatelessWidget {
  final String? assetPackage;

  const WelcomeView({this.assetPackage, super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.welcomeHeadline,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              const Text(AppStrings.welcomeSubtitle),
              const SizedBox(height: 24),
              Center(
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    _buildSample(context, "samples/19.jpeg"),
                    _buildSample(context, "samples/33.jpeg"),
                    _buildSample(context, "samples/29.jpeg"),
                    _buildSample(context, "samples/32.jpeg"),
                    _buildSample(context, "samples/14.jpeg"),
                    _buildSample(context, "samples/34.jpeg"),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(AppStrings.welcomeInstructions),
              const SizedBox(height: 16),
              const Text(AppStrings.welcomeEnjoy),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSample(BuildContext context, String imagePath) {
    return Container(
      width: 200,
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        "assets/$imagePath",
        package: assetPackage,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            "assets/$imagePath",
            package: assetPackage == null ? "client_flutter" : null,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}

/// Full page wrapper for WelcomePage.
/// When embedded into a host app that provides its own navigation shell or AppBar,
/// [showDrawer] and [showAppBar] can be set to false.
class WelcomePage extends StatelessWidget {
  static const String routePath = "/welcome";

  final bool showDrawer;
  final bool showAppBar;
  final TrianglesRoutePaths paths;
  final String? assetPackage;

  WelcomePage({
    this.showDrawer = true,
    this.showAppBar = true,
    this.assetPackage,
    TrianglesRoutePaths? paths,
    String? basePath,
    super.key,
  }) : paths = paths ??
            (basePath != null && basePath.isNotEmpty
                ? TrianglesRoutePaths.withPrefix(basePath)
                : const TrianglesRoutePaths());

  static Widget builder(BuildContext context, GoRouterState state) {
    return WelcomePage();
  }

  @override
  Widget build(BuildContext context) {
    final body = WelcomeView(assetPackage: assetPackage);
    if (!showAppBar && !showDrawer) {
      return body;
    }

    return Scaffold(
      drawer: showDrawer ? AppDrawer(paths: paths) : null,
      appBar: showAppBar
          ? AppBar(
              title: const Text(AppStrings.navWelcome),
            )
          : null,
      body: body,
    );
  }
}
