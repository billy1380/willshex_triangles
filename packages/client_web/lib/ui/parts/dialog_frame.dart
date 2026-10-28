import "package:jaspr/dom.dart";
import "package:jaspr/jaspr.dart";

/// The frame the dialogs share: a title, a body and text buttons, with no
/// borders or divider lines between them. Clicking outside closes it.
class DialogFrame extends StatelessComponent {
  final String title;
  final List<Component> children;
  final List<Component> actions;
  final VoidCallback onClose;

  /// Extra classes for the dialog, e.g. to change its width.
  final String? dialogClasses;

  const DialogFrame({
    required this.title,
    required this.children,
    required this.actions,
    required this.onClose,
    this.dialogClasses,
    super.key,
  });

  static Component textButton(
    String text,
    VoidCallback onClick, {
    bool disabled = false,
  }) {
    return button(
      type: ButtonType.button,
      classes: "btn btn-link text-decoration-none",
      disabled: disabled,
      events: {"click": (e) => onClick()},
      [Component.text(text)],
    );
  }

  @override
  Component build(BuildContext context) {
    return div([
      div(
        classes: "modal d-block",
        attributes: const {"role": "dialog", "aria-modal": "true"},
        events: {"click": (e) => onClose()},
        [
          div(
            classes:
                "modal-dialog modal-dialog-centered modal-dialog-scrollable icon-picker-dialog ${dialogClasses ?? ''}",
            events: {"click": (e) => e.stopPropagation()},
            [
              div(classes: "modal-content", [
                div(classes: "icon-picker-title", [Component.text(title)]),
                div(classes: "modal-body icon-picker-body px-2", children),
                div(classes: "icon-picker-actions", actions),
              ]),
            ],
          ),
        ],
      ),
      const div(classes: "modal-backdrop show", []),
    ]);
  }
}
