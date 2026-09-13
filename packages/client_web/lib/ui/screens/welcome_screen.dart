import "package:jaspr/dom.dart";
import "package:jaspr/jaspr.dart";
import "package:client_web/ui/layout.dart";

class WelcomeScreen extends StatelessComponent {
  const WelcomeScreen({super.key});

  @override
  Component build(BuildContext context) {
    return const AppLayout(
      title: "Welcome",
      child: _WelcomeContent(),
    );
  }
}

class _WelcomeContent extends StatelessComponent {
  const _WelcomeContent();

  Component _sampleCard(String filename) {
    return div(classes: "sample-card", [
      img(
        src: "assets/samples/$filename",
        alt: "Sample $filename",
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
            Component.text("Our triangles wallpaper project!"),
          ]),
          p(classes: "lead text-secondary", [
            Component.text(
              "You can generate many variations of images with different colours and textures. "
              "Check out some of the samples below to get an idea.",
            ),
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
                      [Component.text("Get Generating")]),
                  p(classes: "mb-0 text-secondary", [
                    Component.text(
                      "To begin, select a pattern from the types menu on the left and get generating. "
                      "Make changes by refreshing the palette or changing pattern types, textures, and blend modes.",
                    ),
                  ]),
                ]),
              ]),
            ]),
        const p(classes: "text-muted fs-5", [Component.text("Enjoy!")]),
      ],
    );
  }
}
