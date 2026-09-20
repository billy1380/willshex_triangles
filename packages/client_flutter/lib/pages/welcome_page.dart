import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:url_launcher/url_launcher_string.dart";
import "package:client_common/client_common.dart";
import "package:client_flutter/parts/app_drawer.dart";

/// Pure content view for Welcome, decoupled from Scaffold, AppBar, and AppDrawer.
/// Seamlessly combines introductory cards, sample gallery, and project/legal information.
class WelcomeView extends StatelessWidget {
  final String? assetPackage;

  const WelcomeView({this.assetPackage, super.key});

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.welcomeHeadline,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                const SizedBox(height: 12),
                Text(
                  AppStrings.welcomeSubtitle,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
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
                Card(
                  elevation: 0,
                  color: Theme.of(context)
                      .colorScheme
                      .primaryContainer
                      .withValues(alpha: 0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.auto_awesome,
                          size: 28,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppStrings.welcomeGetGeneratingTitle,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                AppStrings.welcomeInstructions,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const AboutView(),
                const SizedBox(height: 24),
                Text(
                  AppStrings.welcomeEnjoy,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
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

/// Pure embeddable view for Project Information, Credits, and Legal info.
class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.aboutProjectTitle,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          AppStrings.aboutProjectDescription,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Divider(),
        ),
        Text(
          AppStrings.aboutSoftwareTitle,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          AppStrings.aboutSoftwareDescription,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        _buildLink(
            context, AppStrings.aboutFlutterLink, AppStrings.aboutFlutterUrl),
        _buildLink(
            context, AppStrings.aboutJasprLink, AppStrings.aboutJasprUrl),
        _buildLink(
          context,
          AppStrings.aboutRomainGuyLink,
          AppStrings.aboutRomainGuyUrl,
          isDead: true,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Divider(),
        ),
        Text(
          AppStrings.aboutImagesTitle,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          AppStrings.aboutImagesDescription,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        _buildLink(context, AppStrings.aboutLoremPicsumLink,
            AppStrings.aboutLoremPicsumUrl),
        _buildLink(context, AppStrings.aboutSubtlePatternsLink,
            AppStrings.aboutSubtlePatternsUrl),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Divider(),
        ),
        Text(
          AppStrings.aboutLegalTitle,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          AppStrings.aboutLegalDescription,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
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
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: TextStyle(
                color: primary,
                decoration: TextDecoration.underline,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.open_in_new,
              size: 14,
              color: primary,
            ),
          ],
        ),
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
