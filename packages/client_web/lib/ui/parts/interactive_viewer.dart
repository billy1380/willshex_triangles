import "dart:async";
import "package:jaspr/dom.dart";
import "package:jaspr/jaspr.dart";
import "package:web/web.dart" as web;

/// An interactive pan and zoom viewport component for Jaspr web.
///
/// Supports:
/// - Mouse drag / touch drag panning across entire window
/// - Mouse wheel / trackpad zooming
/// - Double click to reset
/// - Floating zoom controls (+, -, reset, scale percentage)
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

  StreamSubscription<web.PointerEvent>? _pointerMoveSub;
  StreamSubscription<web.PointerEvent>? _pointerUpSub;
  StreamSubscription<web.PointerEvent>? _pointerCancelSub;

  StreamSubscription<web.MouseEvent>? _mouseMoveSub;
  StreamSubscription<web.MouseEvent>? _mouseUpSub;

  @override
  void dispose() {
    _cleanupSubs();
    super.dispose();
  }

  void _cleanupSubs() {
    _pointerMoveSub?.cancel();
    _pointerMoveSub = null;
    _pointerUpSub?.cancel();
    _pointerUpSub = null;
    _pointerCancelSub?.cancel();
    _pointerCancelSub = null;
    _mouseMoveSub?.cancel();
    _mouseMoveSub = null;
    _mouseUpSub?.cancel();
    _mouseUpSub = null;
  }

  void _zoom(double factor, {double? focusX, double? focusY}) {
    final oldScale = _scale;
    final newScale =
        (oldScale * factor).clamp(component.minScale, component.maxScale);
    if (newScale == oldScale) return;

    final actualFactor = newScale / oldScale;
    final fx = focusX ?? 0.0;
    final fy = focusY ?? 0.0;

    setState(() {
      _scale = newScale;
      _panX = fx - (fx - _panX) * actualFactor;
      _panY = fy - (fy - _panY) * actualFactor;
    });
  }

  void _reset() {
    setState(() {
      _scale = component.initialScale;
      _panX = 0.0;
      _panY = 0.0;
    });
  }

  void _startDragging(double startX, double startY, {required bool isPointer}) {
    _isDragging = true;
    _lastPointerX = startX;
    _lastPointerY = startY;

    _cleanupSubs();

    void onMove(double clientX, double clientY) {
      if (!_isDragging) return;
      final dx = clientX - _lastPointerX;
      final dy = clientY - _lastPointerY;
      _lastPointerX = clientX;
      _lastPointerY = clientY;

      setState(() {
        _panX += dx;
        _panY += dy;
      });
    }

    void onStopDrag(web.Event e) {
      if (_isDragging) {
        _isDragging = false;
        _cleanupSubs();
        setState(() {});
      }
    }

    if (isPointer) {
      _pointerMoveSub = web.EventStreamProvider<web.PointerEvent>("pointermove")
          .forTarget(web.window)
          .listen((e) {
        e.preventDefault();
        onMove(e.clientX.toDouble(), e.clientY.toDouble());
      });

      _pointerUpSub = web.EventStreamProvider<web.PointerEvent>("pointerup")
          .forTarget(web.window)
          .listen(onStopDrag);

      _pointerCancelSub =
          web.EventStreamProvider<web.PointerEvent>("pointercancel")
              .forTarget(web.window)
              .listen(onStopDrag);
    } else {
      _mouseMoveSub = web.EventStreamProvider<web.MouseEvent>("mousemove")
          .forTarget(web.window)
          .listen((e) {
        e.preventDefault();
        onMove(e.clientX.toDouble(), e.clientY.toDouble());
      });

      _mouseUpSub = web.EventStreamProvider<web.MouseEvent>("mouseup")
          .forTarget(web.window)
          .listen(onStopDrag);
    }

    setState(() {});
  }

  void _handlePointerDown(web.Event event) {
    if (event is web.PointerEvent) {
      if (event.button != 0) return;
      event.preventDefault();
      _startDragging(event.clientX.toDouble(), event.clientY.toDouble(),
          isPointer: true);
    }
  }

  void _handleMouseDown(web.Event event) {
    if (!_isDragging && event is web.MouseEvent) {
      if (event.button != 0) return;
      event.preventDefault();
      _startDragging(event.clientX.toDouble(), event.clientY.toDouble(),
          isPointer: false);
    }
  }

  void _handleWheel(web.Event event) {
    if (event is! web.WheelEvent) return;
    event.preventDefault();

    final delta = event.deltaY.toDouble();
    if (delta == 0) return;
    final factor = delta < 0 ? 1.15 : (1.0 / 1.15);

    final rect =
        (event.currentTarget as web.Element?)?.getBoundingClientRect();
    double? focusX;
    double? focusY;
    if (rect != null) {
      focusX = event.clientX.toDouble() -
          (rect.left.toDouble() + rect.width.toDouble() / 2);
      focusY = event.clientY.toDouble() -
          (rect.top.toDouble() + rect.height.toDouble() / 2);
    }
    _zoom(factor, focusX: focusX, focusY: focusY);
  }

  @override
  Component build(BuildContext context) {
    final scalePercent = (_scale * 100).round();

    return div(
      classes:
          "interactive-viewer-viewport ${_isDragging ? 'is-dragging' : ''}",
      events: {
        "pointerdown": _handlePointerDown,
        "mousedown": _handleMouseDown,
        "wheel": _handleWheel,
        "dblclick": (e) => _reset(),
      },
      [
        div(
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
              attributes: const {"title": "Zoom out (-20%)"},
              events: {"click": (e) => _zoom(0.8)},
              const [i(classes: "bi bi-dash", [])],
            ),
            span(
              classes: "interactive-viewer-scale-text",
              attributes: const {"title": "Click to reset zoom (100%)"},
              events: {"click": (e) => _reset()},
              [Component.text("$scalePercent%")],
            ),
            button(
              classes: "interactive-viewer-btn",
              attributes: const {"title": "Zoom in (+25%)"},
              events: {"click": (e) => _zoom(1.25)},
              const [i(classes: "bi bi-plus", [])],
            ),
            button(
              classes: "interactive-viewer-btn",
              attributes: const {"title": "Reset zoom and pan"},
              events: {"click": (e) => _reset()},
              const [i(classes: "bi bi-arrows-angle-contract", [])],
            ),
          ]),
      ],
    );
  }
}
