import "package:jaspr/dom.dart";
import "package:jaspr/jaspr.dart";
import "package:client_common/client_common.dart";
import "package:client_web/ui/layout.dart";

class AboutScreen extends StatelessComponent {
  const AboutScreen({super.key});

  @override
  Component build(BuildContext context) {
    return const AppLayout(
      title: AppStrings.navAbout,
      child: _AboutContent(),
    );
  }
}

class _AboutContent extends StatelessComponent {
  const _AboutContent();

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
      classes: "p-4 p-md-5 overflow-auto",
      attributes: const {"style": "max-width: 800px; margin: 0 auto;"},
      [
        div(classes: "card p-4 p-md-5 shadow-sm border-0 bg-opacity-50", [
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
            _link(AppStrings.aboutLoremPicsumLink, AppStrings.aboutLoremPicsumUrl),
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
        ]),
      ],
    );
  }
}
