import "package:jaspr/dom.dart";
import "package:jaspr/jaspr.dart";
import "package:client_common/client_common.dart";
import "package:client_web/ui/layout.dart";

class WelcomeScreen extends StatelessComponent {
  final bool useLayout;
  final TrianglesRoutePaths paths;

  WelcomeScreen({
    this.useLayout = true,
    TrianglesRoutePaths? paths,
    String? basePath,
    super.key,
  }) : paths = paths ??
            (basePath != null && basePath.isNotEmpty
                ? TrianglesRoutePaths.withPrefix(basePath)
                : const TrianglesRoutePaths());

  @override
  Component build(BuildContext context) {
    if (!useLayout) {
      return const WelcomeView();
    }
    return AppLayout(
      title: AppStrings.navWelcome,
      paths: paths,
      child: const WelcomeView(),
    );
  }
}

/// Pure embeddable view for Welcome in web.
class WelcomeView extends StatelessComponent {
  final String assetPathPrefix;

  const WelcomeView({
    this.assetPathPrefix = "assets/samples/",
    super.key,
  });

  Component _sampleCard(String filename) {
    return div(classes: "sample-card", [
      img(
        src: "$assetPathPrefix$filename",
        alt: "${AppStrings.sampleImagePrefix} $filename",
        loading: MediaLoading.lazy,
      ),
    ]);
  }

  @override
  Component build(BuildContext context) {
    return div(
      classes: "p-4 p-md-5 overflow-auto",
      attributes: const {"style": "max-width: 960px; margin: 0 auto;"},
      [
        const div(classes: "mb-4", [
          h3(classes: "display-6 fw-bold mb-3 text-primary", [
            Component.text(AppStrings.welcomeHeadline),
          ]),
          p(classes: "lead text-secondary", [
            Component.text(AppStrings.welcomeSubtitle),
          ]),
        ]),
        div(classes: "sample-grid", [
          _sampleCard("19.jpeg"),
          _sampleCard("33.jpeg"),
          _sampleCard("29.jpeg"),
          _sampleCard("32.jpeg"),
          _sampleCard("14.jpeg"),
          _sampleCard("34.jpeg"),
        ]),
        const div(
            classes:
                "card border-0 bg-opacity-10 bg-primary p-4 my-4 rounded-3",
            [
              div(classes: "d-flex gap-3 align-items-center", [
                i(classes: "bi bi-stars text-primary fs-2", []),
                div([
                  h5(
                      classes: "mb-1 fw-bold",
                      [Component.text(AppStrings.welcomeGetGeneratingTitle)]),
                  p(classes: "mb-0 text-secondary", [
                    Component.text(AppStrings.welcomeInstructions),
                  ]),
                ]),
              ]),
            ]),
        const p(classes: "text-muted fs-5", [Component.text(AppStrings.welcomeEnjoy)]),
      ],
    );
  }
}
