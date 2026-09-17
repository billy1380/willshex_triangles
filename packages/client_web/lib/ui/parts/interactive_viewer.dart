import "dart:async";
import "package:client_common/client_common.dart";
import "package:jaspr/dom.dart";
import "package:jaspr/jaspr.dart";
import "package:web/web.dart" as web;

/// An interactive pan and zoom viewport component for Jaspr web.
///
/// Supports:
/// - Pointer drag (mouse/touch/stylus) with setPointerCapture
/// - Document-level move/up fallback listeners
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
  int? _capturedPointerId;
  web.Element? _capturedTarget;

  StreamSubscription<web.PointerEvent>? _docPointerMoveSub;
  StreamSubscription<web.PointerEvent>? _docPointerUpSub;
  StreamSubscription<web.MouseEvent>? _docMouseMoveSub;
  StreamSubscription<web.MouseEvent>? _docMouseUpSub;

  @override
  void dispose() {
    _cleanupSubs();
    super.dispose();
  }

  void _cleanupSubs() {
    _docPointerMoveSub?.cancel();
    _docPointerMoveSub = null;
    _docPointerUpSub?.cancel();
    _docPointerUpSub = null;
    _docMouseMoveSub?.cancel();
    _docMouseMoveSub = null;
    _docMouseUpSub?.cancel();
    _docMouseUpSub = null;
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

  void _startDrag(double clientX, double clientY,
      {int? pointerId, web.Element? target}) {
    _isDragging = true;
    _lastPointerX = clientX;
    _lastPointerY = clientY;
    _capturedPointerId = pointerId;
    _capturedTarget = target;

    if (pointerId != null && target != null) {
      try {
        target.setPointerCapture(pointerId);
      } catch (_) {}
    }

    _cleanupSubs();

    // Attach document-level listeners as a reliable fallback
    if (pointerId != null) {
      _docPointerMoveSub =
          web.EventStreamProvider<web.PointerEvent>("pointermove")
              .forTarget(web.document)
              .listen((e) {
        if (!_isDragging) return;
        e.preventDefault();
        _onMove(e.clientX.toDouble(), e.clientY.toDouble());
      });

      void stopPointer(web.PointerEvent e) {
        _endDrag(e.pointerId);
      }

      _docPointerUpSub = web.EventStreamProvider<web.PointerEvent>("pointerup")
          .forTarget(web.document)
          .listen(stopPointer);
    } else {
      _docMouseMoveSub = web.EventStreamProvider<web.MouseEvent>("mousemove")
          .forTarget(web.document)
          .listen((e) {
        if (!_isDragging) return;
        e.preventDefault();
        _onMove(e.clientX.toDouble(), e.clientY.toDouble());
      });

      _docMouseUpSub = web.EventStreamProvider<web.MouseEvent>("mouseup")
          .forTarget(web.document)
          .listen((e) {
        _endDrag(null);
      });
    }

    setState(() {});
  }

  void _onMove(double clientX, double clientY) {
    if (!_isDragging) return;
    final dx = clientX - _lastPointerX;
    final dy = clientY - _lastPointerY;
    if (dx == 0 && dy == 0) return;

    _lastPointerX = clientX;
    _lastPointerY = clientY;

    setState(() {
      _panX += dx;
      _panY += dy;
    });
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
    if (event is web.PointerEvent) {
      if (event.button != 0) return;
      event.preventDefault();
      final target = (event.currentTarget as web.Element?) ??
          (event.target as web.Element?) ??
          web.document.getElementById("interactive-viewer-viewport");
      _startDrag(
        event.clientX.toDouble(),
        event.clientY.toDouble(),
        pointerId: event.pointerId,
        target: target,
      );
    }
  }

  void _handlePointerMove(web.Event event) {
    if (!_isDragging) return;
    if (event is web.PointerEvent) {
      event.preventDefault();
      _onMove(event.clientX.toDouble(), event.clientY.toDouble());
    }
  }

  void _handlePointerUp(web.Event event) {
    if (event is web.PointerEvent) {
      _endDrag(event.pointerId);
    } else {
      _endDrag(null);
    }
  }

  void _handleMouseDown(web.Event event) {
    if (!_isDragging && event is web.MouseEvent) {
      if (event.button != 0) return;
      event.preventDefault();
      _startDrag(
        event.clientX.toDouble(),
        event.clientY.toDouble(),
      );
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
      id: "interactive-viewer-viewport",
      classes:
          "interactive-viewer-viewport ${_isDragging ? 'is-dragging' : ''}",
      events: {
        "pointerdown": _handlePointerDown,
        "pointermove": _handlePointerMove,
        "pointerup": _handlePointerUp,
        "pointercancel": _handlePointerUp,
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
