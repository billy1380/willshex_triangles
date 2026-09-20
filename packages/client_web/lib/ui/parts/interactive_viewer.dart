import "dart:async";
import "dart:js_interop";
import "dart:js_interop_unsafe";
import "package:client_common/client_common.dart";
import "package:jaspr/dom.dart";
import "package:jaspr/jaspr.dart";
import "package:web/web.dart" as web;

/// Helper extension to safely read coordinates and attributes from web events.
///
/// In modern browsers (especially on Retina / high-DPI displays or when zoomed),
/// coordinates like `clientX` and `clientY` are returned as floating point numbers (doubles).
/// However, Dart's `package:web` WebIDL bindings historically typed `clientX` as `int`,
/// causing Dart Dev Compiler (DDC) to throw:
/// `TypeError: <float>: type 'double' is not a subtype of type 'int'`.
/// Using `dart:js_interop_unsafe` allows reading them directly as `toDartDouble`.
extension SafeEventCoordinates on web.Event {
  double get safeClientX {
    try {
      final jsObj = this as JSObject;
      final val = jsObj.getProperty<JSNumber?>("clientX".toJS);
      if (val != null) return val.toDartDouble;
    } catch (_) {}
    return 0.0;
  }

  double get safeClientY {
    try {
      final jsObj = this as JSObject;
      final val = jsObj.getProperty<JSNumber?>("clientY".toJS);
      if (val != null) return val.toDartDouble;
    } catch (_) {}
    return 0.0;
  }

  double get safeDeltaY {
    try {
      final jsObj = this as JSObject;
      final val = jsObj.getProperty<JSNumber?>("deltaY".toJS);
      if (val != null) return val.toDartDouble;
    } catch (_) {}
    return 0.0;
  }

  int get safeButton {
    try {
      final jsObj = this as JSObject;
      final val = jsObj.getProperty<JSNumber?>("button".toJS);
      if (val != null) return val.toDartDouble.round();
    } catch (_) {}
    return 0;
  }

  int? get safePointerId {
    try {
      final jsObj = this as JSObject;
      final val = jsObj.getProperty<JSNumber?>("pointerId".toJS);
      if (val != null) return val.toDartDouble.round();
    } catch (_) {}
    return null;
  }
}

/// An interactive pan and zoom viewport component for Jaspr web.
///
/// Features:
/// - Robust drag-panning across mouse, touch, and stylus input.
/// - Window-level tracking fallback ensuring drags never drop outside bounds.
/// - Pointer capture support with automatic graceful fallback.
/// - Direct DOM transform updates for 60fps responsiveness.
/// - Zoom in/out, reset, double-click reset, and mouse wheel zoom.
class InteractiveViewer extends StatefulComponent {
  final Component child;
  final double minScale;
  final double maxScale;
  final double initialScale;
  final bool showControls;

  const InteractiveViewer({
    required this.child,
    this.minScale = 0.1,
    this.maxScale = 20.0,
    this.initialScale = 1.0,
    this.showControls = true,
    super.key,
  });

  @override
  State<InteractiveViewer> createState() => _InteractiveViewerState();
}

class _InteractiveViewerState extends State<InteractiveViewer> {
  late double _scale = component.initialScale;
  double _panX = 0.0;
  double _panY = 0.0;

  bool _isDragging = false;
  double _lastPointerX = 0.0;
  double _lastPointerY = 0.0;
  int? _capturedPointerId;
  web.Element? _capturedTarget;

  // Window subscriptions for active drag tracking
  StreamSubscription<web.PointerEvent>? _winPointerMoveSub;
  StreamSubscription<web.PointerEvent>? _winPointerUpSub;
  StreamSubscription<web.PointerEvent>? _winPointerCancelSub;
  StreamSubscription<web.MouseEvent>? _winMouseMoveSub;
  StreamSubscription<web.MouseEvent>? _winMouseUpSub;

  @override
  void dispose() {
    _cleanupSubs();
    super.dispose();
  }

  void _cleanupSubs() {
    _winPointerMoveSub?.cancel();
    _winPointerMoveSub = null;
    _winPointerUpSub?.cancel();
    _winPointerUpSub = null;
    _winPointerCancelSub?.cancel();
    _winPointerCancelSub = null;
    _winMouseMoveSub?.cancel();
    _winMouseMoveSub = null;
    _winMouseUpSub?.cancel();
    _winMouseUpSub = null;
  }

  void _applyTransform() {
    final el = web.document.getElementById("interactive-viewer-content")
        as web.HTMLElement?;
    if (el != null) {
      el.style.transform =
          "translate(${_panX.toStringAsFixed(1)}px, ${_panY.toStringAsFixed(1)}px) scale(${_scale.toStringAsFixed(3)})";
    }
  }

  void _zoom(double factor, {double? focusX, double? focusY}) {
    final oldScale = _scale;
    final newScale =
        (oldScale * factor).clamp(component.minScale, component.maxScale);
    if (newScale == oldScale) return;

    final actualFactor = newScale / oldScale;
    final fx = focusX ?? 0.0;
    final fy = focusY ?? 0.0;

    _scale = newScale;
    _panX = fx - (fx - _panX) * actualFactor;
    _panY = fy - (fy - _panY) * actualFactor;
    _applyTransform();
    setState(() {});
  }

  void _reset() {
    _scale = component.initialScale;
    _panX = 0.0;
    _panY = 0.0;
    _applyTransform();
    setState(() {});
  }

  void _startDrag(
    double clientX,
    double clientY, {
    int? pointerId,
    web.Element? target,
  }) {
    _isDragging = true;
    _lastPointerX = clientX;
    _lastPointerY = clientY;
    _capturedPointerId = pointerId;
    _capturedTarget = target;

    // Pointer capture attempt
    if (pointerId != null && target != null) {
      try {
        target.setPointerCapture(pointerId);
      } catch (_) {}
    }

    _cleanupSubs();

    // Listen on web.window to track movement everywhere across the screen
    try {
      _winPointerMoveSub =
          web.EventStreamProvider<web.PointerEvent>("pointermove")
              .forTarget(web.window)
              .listen((e) {
        if (!_isDragging) return;
        _onMove(e.safeClientX, e.safeClientY);
      });

      _winPointerUpSub = web.EventStreamProvider<web.PointerEvent>("pointerup")
          .forTarget(web.window)
          .listen((e) {
        _endDrag(e.safePointerId);
      });

      _winPointerCancelSub =
          web.EventStreamProvider<web.PointerEvent>("pointercancel")
              .forTarget(web.window)
              .listen((e) {
        _endDrag(e.safePointerId);
      });
    } catch (_) {}

    // Fallback: mousemove and mouseup listeners on window
    try {
      _winMouseMoveSub = web.EventStreamProvider<web.MouseEvent>("mousemove")
          .forTarget(web.window)
          .listen((e) {
        if (!_isDragging) return;
        _onMove(e.safeClientX, e.safeClientY);
      });

      _winMouseUpSub = web.EventStreamProvider<web.MouseEvent>("mouseup")
          .forTarget(web.window)
          .listen((e) {
        _endDrag(null);
      });
    } catch (_) {}

    setState(() {});
  }

  void _onMove(double clientX, double clientY) {
    if (!_isDragging) return;

    final dx = clientX - _lastPointerX;
    final dy = clientY - _lastPointerY;
    if (dx == 0 && dy == 0) return;

    _lastPointerX = clientX;
    _lastPointerY = clientY;

    _panX += dx;
    _panY += dy;

    _applyTransform();
    setState(() {});
  }

  void _endDrag(int? pointerId) {
    if (!_isDragging) return;
    _isDragging = false;

    if (_capturedPointerId != null && _capturedTarget != null) {
      try {
        _capturedTarget!.releasePointerCapture(_capturedPointerId!);
      } catch (_) {}
    }

    _capturedPointerId = null;
    _capturedTarget = null;
    _cleanupSubs();
    setState(() {});
  }

  void _handlePointerDown(web.Event event) {
    if (event.safeButton != 0) return;
    event.preventDefault();
    final target = (event.currentTarget as web.Element?) ??
        (event.target as web.Element?) ??
        web.document.getElementById("interactive-viewer-viewport");
    _startDrag(
      event.safeClientX,
      event.safeClientY,
      pointerId: event.safePointerId,
      target: target,
    );
  }

  void _handleMouseDown(web.Event event) {
    if (!_isDragging) {
      if (event.safeButton != 0) return;
      event.preventDefault();
      _startDrag(
        event.safeClientX,
        event.safeClientY,
      );
    }
  }

  void _handleWheel(web.Event event) {
    event.preventDefault();

    final delta = event.safeDeltaY;
    if (delta == 0) return;
    final factor = delta < 0 ? 1.15 : (1.0 / 1.15);

    final rect = (event.currentTarget as web.Element?)?.getBoundingClientRect();
    double? focusX;
    double? focusY;
    if (rect != null) {
      focusX = event.safeClientX -
          (rect.left.toDouble() + rect.width.toDouble() / 2);
      focusY = event.safeClientY -
          (rect.top.toDouble() + rect.height.toDouble() / 2);
    }
    _zoom(factor, focusX: focusX, focusY: focusY);
  }

  @override
  Component build(BuildContext context) {
    final scalePercent = (_scale * 100).round();

    return div(
      id: "interactive-viewer-viewport",
      classes:
          "interactive-viewer-viewport ${_isDragging ? 'is-dragging' : ''}",
      events: {
        "pointerdown": (e) => _handlePointerDown(e),
        "pointermove": (e) {
          if (_isDragging) {
            e.preventDefault();
            _onMove(e.safeClientX, e.safeClientY);
          }
        },
        "pointerup": (e) => _endDrag(e.safePointerId),
        "pointercancel": (e) => _endDrag(e.safePointerId),
        "mousedown": (e) => _handleMouseDown(e),
        "mousemove": (e) {
          if (_isDragging) {
            _onMove(e.safeClientX, e.safeClientY);
          }
        },
        "mouseup": (e) => _endDrag(null),
        "dragstart": (e) => e.preventDefault(),
        "lostpointercapture": (e) => _endDrag(null),
        "wheel": (e) => _handleWheel(e),
        "dblclick": (e) => _reset(),
      },
      [
        div(
          id: "interactive-viewer-content",
          classes: "interactive-viewer-content",
          attributes: {
            "style":
                "transform: translate(${_panX.toStringAsFixed(1)}px, ${_panY.toStringAsFixed(1)}px) scale(${_scale.toStringAsFixed(3)}); transform-origin: center center;",
          },
          [component.child],
        ),
        if (component.showControls)
          div(
            classes: "interactive-viewer-controls",
            events: {
              "pointerdown": (e) => e.stopPropagation(),
              "mousedown": (e) => e.stopPropagation(),
              "dblclick": (e) => e.stopPropagation(),
            },
            [
              button(
                classes: "interactive-viewer-btn",
                attributes: const {
                  "title": AppStrings.zoomOut,
                  "aria-label": AppStrings.zoomOut,
                },
                events: {"click": (e) => _zoom(0.8)},
                const [i(classes: "bi bi-dash", [])],
              ),
              span(
                classes: "interactive-viewer-scale-text",
                attributes: const {
                  "title": AppStrings.resetZoomAndPosition,
                  "aria-label": AppStrings.resetZoomAndPosition,
                },
                events: {"click": (e) => _reset()},
                [Component.text("$scalePercent%")],
              ),
              button(
                classes: "interactive-viewer-btn",
                attributes: const {
                  "title": AppStrings.zoomIn,
                  "aria-label": AppStrings.zoomIn,
                },
                events: {"click": (e) => _zoom(1.25)},
                const [i(classes: "bi bi-plus", [])],
              ),
              button(
                classes: "interactive-viewer-btn",
                attributes: const {
                  "title": AppStrings.resetZoomAndPosition,
                  "aria-label": AppStrings.resetZoomAndPosition,
                },
                events: {"click": (e) => _reset()},
                const [i(classes: "bi bi-arrows-angle-contract", [])],
              ),
            ],
          ),
      ],
    );
  }
}
