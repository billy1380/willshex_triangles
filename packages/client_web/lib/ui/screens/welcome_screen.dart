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
/// Seamlessly integrates intro headline, sample showcase, quick-start guide,
/// and project credits/legal information.
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
        const AboutView(),
        const p(
            classes: "text-primary fw-semibold fs-5 mt-4",
            [Component.text(AppStrings.welcomeEnjoy)]),
      ],
    );
  }
}

/// Pure embeddable view for About and Project Information in web.
class AboutView extends StatelessComponent {
  const AboutView({super.key});

  Component _link(String title, String href, {bool isDead = false}) {
    return div(classes: "mb-2", [
      if (isDead)
        span(classes: "text-primary fw-medium me-2", [
          Component.text(title),
        ])
      else
        a(
          href: href,
          target: Target.blank,
          classes: "text-primary text-decoration-none fw-medium me-2",
          [
            Component.text(title),
            const i(classes: "bi bi-box-arrow-up-right small ms-1", []),
          ],
        ),
    ]);
  }

  @override
  Component build(BuildContext context) {
    return div(
      classes: "mt-5",
      [
        const section(classes: "mb-4", [
          h4(classes: "fw-bold text-primary mb-2", [
            Component.text(AppStrings.aboutProjectTitle),
          ]),
          p(classes: "text-secondary", [
            Component.text(AppStrings.aboutProjectDescription),
          ]),
        ]),
        const hr(),
        section(classes: "my-4", [
          const h4(classes: "fw-bold text-primary mb-2", [
            Component.text(AppStrings.aboutSoftwareTitle),
          ]),
          const p(classes: "text-secondary mb-3", [
            Component.text(AppStrings.aboutSoftwareDescription),
          ]),
          _link(AppStrings.aboutJasprLink, AppStrings.aboutJasprUrl),
          _link(AppStrings.aboutFlutterLink, AppStrings.aboutFlutterUrl),
          _link(
            AppStrings.aboutRomainGuyLink,
            AppStrings.aboutRomainGuyUrl,
            isDead: true,
          ),
        ]),
        const hr(),
        section(classes: "my-4", [
          const h4(classes: "fw-bold text-primary mb-2", [
            Component.text(AppStrings.aboutImagesTitle),
          ]),
          const p(classes: "text-secondary mb-3", [
            Component.text(AppStrings.aboutImagesDescription),
          ]),
          _link(
              AppStrings.aboutLoremPicsumLink, AppStrings.aboutLoremPicsumUrl),
          _link(
            AppStrings.aboutSubtlePatternsLink,
            AppStrings.aboutSubtlePatternsUrl,
          ),
        ]),
        const hr(),
        const section(classes: "mt-4", [
          h4(classes: "fw-bold text-primary mb-2", [
            Component.text(AppStrings.aboutLegalTitle),
          ]),
          p(classes: "text-secondary mb-0", [
            Component.text(AppStrings.aboutLegalDescription),
          ]),
        ]),
      ],
    );
  }
}
