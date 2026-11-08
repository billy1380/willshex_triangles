import "package:test/test.dart";
import "package:triangles_common/triangles_common.dart";
import "package:willshex_draw/willshex_draw.dart" as ws;
import "package:willshex_embedding/willshex_embedding.dart";

T control<T extends DialogControl>(DialogRequest request, String id) =>
    request.controls.firstWhere((c) => c.id == id) as T;

bool has(DialogRequest request, String id) =>
    request.controls.any((c) => c.id == id);

ws.Palette palette() => ws.Palette("Sunset")
  ..addColors([
    ws.Color.rgbaColor(1, 0, 0, 1),
    ws.Color.rgbaColor(0, 1, 0, 1),
    ws.Color.rgbaColor(0, 0, 1, 1),
  ]);

DialogChange slider(String id, double v) =>
    DialogChange(id, DialogChangeKind.value, value: v);

void main() {
  group("PaletteForm", () {
    late PaletteForm form;

    tearDown(() => form.close());

    test("a new palette starts with two colours and the last selected", () {
      form = PaletteForm();
      final request = form.request();

      expect(request.title, "Create Custom Palette");
      expect(control<DialogSwatches>(request, "colours").colours, hasLength(2));
      expect(control<DialogSwatches>(request, "colours").selected, 1);
      expect(control<DialogField>(request, "name").initialValue, isNotEmpty);
    });

    test("an existing palette is edited under its own name and colours", () {
      form = PaletteForm(initialPalette: palette());
      final request = form.request();

      expect(request.title, "Edit Palette");
      expect(control<DialogField>(request, "name").initialValue, "Sunset");
      expect(
        control<DialogSwatches>(request, "colours").colours,
        [0xFFFF0000, 0xFF00FF00, 0xFF0000FF],
      );
      expect(control<DialogSwatches>(request, "colours").selected, 0);
    });

    test("the selected colour can be edited with its three channels", () {
      form = PaletteForm(initialPalette: palette());
      final request = form.request();

      expect(control<DialogPreview>(request, "preview").colour, 0xFFFF0000);
      expect(control<DialogSlider>(request, "red").value, 255);
      expect(control<DialogSlider>(request, "green").value, 0);
      expect(control<DialogSlider>(request, "blue").value, 0);
      expect(control<DialogSlider>(request, "red").max, 255);
    });

    test("selecting a swatch shows that colour's channels", () {
      form = PaletteForm(initialPalette: palette());

      final next = form.request().onChanged!(
        const DialogChange("colours", DialogChangeKind.select, index: 2),
      )!;

      expect(control<DialogSwatches>(next, "colours").selected, 2);
      expect(control<DialogSlider>(next, "blue").value, 255);
      expect(control<DialogSlider>(next, "red").value, 0);
    });

    test("moving a slider changes the selected colour only", () {
      form = PaletteForm(initialPalette: palette());

      final next = form.request().onChanged!(slider("green", 128))!;

      expect(
        control<DialogSwatches>(next, "colours").colours,
        [0xFFFF8000, 0xFF00FF00, 0xFF0000FF],
      );
      expect(control<DialogSlider>(next, "green").value, 128);
      expect(control<DialogPreview>(next, "preview").colour, 0xFFFF8000);
    });

    test("adding appends a colour and selects it", () {
      form = PaletteForm(initialPalette: palette());

      final next = form.request().onChanged!(
        const DialogChange("colours", DialogChangeKind.add),
      )!;

      expect(control<DialogSwatches>(next, "colours").colours, hasLength(4));
      expect(control<DialogSwatches>(next, "colours").selected, 3);
    });

    test("removing drops a colour", () {
      form = PaletteForm(initialPalette: palette());

      final next = form.request().onChanged!(
        const DialogChange("colours", DialogChangeKind.remove, index: 0),
      )!;

      expect(control<DialogSwatches>(next, "colours").colours,
          [0xFF00FF00, 0xFF0000FF]);
    });

    test("with every colour removed there is nothing to select or edit", () {
      form = PaletteForm(initialPalette: palette());
      DialogRequest request = form.request();

      for (var i = 0; i < 3; i++) {
        request = request.onChanged!(
          const DialogChange("colours", DialogChangeKind.remove, index: 0),
        )!;
      }

      expect(has(request, "red"), isFalse);
      expect(
          control<DialogText>(request, "hint").text, "Select a colour to edit");
      expect(request.actions.last.id, "select");
      expect(request.actions.last.isEnabled, isFalse);
    });

    test("typing a name does not redraw, and the name is kept", () {
      form = PaletteForm(initialPalette: palette());

      final next = form.request().onChanged!(
        const DialogChange("name", DialogChangeKind.value, value: "Dusk"),
      );

      expect(next, isNull);
      expect(form.build().name, "Dusk");
    });

    test("building takes the name that was handed back", () {
      form = PaletteForm(initialPalette: palette());

      expect(form.build(name: "Dawn").name, "Dawn");
      expect(form.build(name: "").name, "Dawn", reason: "empty keeps it");
    });

    test("it can be cancelled or selected, and selecting is the default", () {
      form = PaletteForm();
      final request = form.request();

      expect(request.cancelAction, isNotNull);
      expect(request.actions.last.variant, ActionVariant.primary);
    });

    test("channels of a colour become ARGB", () {
      expect(PaletteForm.argbOf(ws.Color.rgbaColor(1, 0.5, 0, 1)), 0xFFFF8000);
      expect(PaletteForm.argbOf(ws.Color.rgbaColor(0, 0, 0, 0)), 0x00000000);
    });
  });

  group("PaletteForm.ask", () {
    final List<void Function()> answerers = [];

    setUp(() => TrianglesDialogs.local.supportsDialogs = true);

    tearDown(() {
      for (final a in answerers) {
        TrianglesDialogs.local.removeListener(a);
      }
      answerers.clear();
      TrianglesDialogs.local.supportsDialogs = false;
    });

    void answer(void Function(PendingDialog pending) respond) {
      void answerer() {
        final pending = TrianglesDialogs.local.state.dialog;

        if (pending != null && !pending.isCompleted) respond(pending);
      }

      answerers.add(answerer);
      TrianglesDialogs.local.addListener(answerer);
    }

    test("selecting answers the palette that was made", () async {
      answer((pending) {
        pending.change(
          const DialogChange("colours", DialogChangeKind.add),
        );
        pending.complete(const DialogResult("select", {"name": "Mine"}));
      });

      final made = await PaletteForm.ask(initialPalette: palette());

      expect(made?.name, "Mine");
      expect(made?.colors, hasLength(4));
    });

    test("cancelling answers nothing", () async {
      answer((pending) => pending.complete(const DialogResult("cancel")));

      expect(await PaletteForm.ask(), isNull);
    });
  });

  group("TrianglesDialogs", () {
    tearDown(() {
      TrianglesDialogs.hostSession = null;
      TrianglesDialogs.local.supportsDialogs = false;
    });

    test("asks the host when it draws dialogs, else its own host", () async {
      final host = EmbeddingController()..supportsDialogs = true;
      TrianglesDialogs.hostSession = host.createPageSession();
      TrianglesDialogs.local.supportsDialogs = true;

      final hosted = TrianglesDialogs.ask(DialogRequest.confirm(title: "A"));
      expect(host.state.dialog, isNotNull);
      expect(TrianglesDialogs.local.state.dialog, isNull);
      host.state.dialog!.complete();
      await hosted;

      host.supportsDialogs = false;
      final own = TrianglesDialogs.ask(DialogRequest.confirm(title: "B"));
      expect(TrianglesDialogs.local.state.dialog, isNotNull);
      TrianglesDialogs.local.state.dialog!.complete();
      await own;
    });

    test("answers nothing when nothing can draw it", () async {
      expect(
        await TrianglesDialogs.ask(DialogRequest.confirm(title: "A")),
        isNull,
      );
    });
  });
}
