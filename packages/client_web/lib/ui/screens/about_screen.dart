import "package:jaspr/dom.dart";
import "package:jaspr/jaspr.dart";
import "package:client_web/ui/layout.dart";

class AboutScreen extends StatelessComponent {
  const AboutScreen({super.key});

  @override
  Component build(BuildContext context) {
    return const AppLayout(
      title: "About",
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
              Component.text("Project"),
            ]),
            p(classes: "text-secondary", [
              Component.text(
                "Triangles is written and maintained by WillShex Limited for fun "
                "and because we like triangles (in case you have not noticed).",
              ),
            ]),
          ]),
          const hr(),
          section(classes: "my-4", [
            const h4(classes: "fw-bold text-primary mb-2", [
              Component.text("Software"),
            ]),
            const p(classes: "text-secondary mb-3", [
              Component.text(
                "Triangles is built with Dart, Jaspr, and Flutter, and made possible by open source libraries:",
              ),
            ]),
            _link("Jaspr (Web Framework)", "https://docs.jaspr.site/"),
            _link("Flutter", "https://flutter.dev/"),
            _link(
              "Romain Guy's blend modes",
              "http://www.curious-creature.org/2006/09/20/new-blendings-modes-for-java2d/",
              isDead: true,
            ),
          ]),
          const hr(),
          section(classes: "my-4", [
            const h4(classes: "fw-bold text-primary mb-2", [
              Component.text("Images"),
            ]),
            const p(classes: "text-secondary mb-3", [
              Component.text("Sample images and backgrounds are provided by:"),
            ]),
            _link("Lorem Picsum", "https://picsum.photos/"),
            _link(
              "Subtle Patterns",
              "https://www.toptal.com/designers/subtlepatterns/",
            ),
          ]),
          const hr(),
          const section(classes: "mt-4", [
            h4(classes: "fw-bold text-primary mb-2", [
              Component.text("Legal"),
            ]),
            p(classes: "text-secondary mb-0", [
              Component.text(
                "You can use any of the images you generate/download for free for all commercial "
                "and non-commercial projects. We would love to hear from you about how you are using the images "
                "and for what projects. If you feel like giving us a mention we would really appreciate that too.",
              ),
            ]),
          ]),
        ]),
      ],
    );
  }
}
