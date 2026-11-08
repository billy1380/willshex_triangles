import "package:willshex_embedding/willshex_embedding.dart";

/// Where Triangles asks its questions: in the host's dialog if it has one,
/// otherwise in its own.
///
/// Every dialog is a [DialogRequest] asked of a [PageSession]. A host that
/// embeds Triangles and draws dialogs draws it in the host's style. Without
/// one (Triangles on its own, or in a host that draws none), Triangles is its
/// own host: [local] is the controller its own client draws requests of.
abstract class TrianglesDialogs {
  TrianglesDialogs._();

  /// The controller of Triangles' own dialogs. The client mounts a dialog host
  /// on it, which is what makes [PageSession.canShowDialog] true there.
  static final EmbeddingController local = EmbeddingController();

  static final PageSession _localSession = local.createPageSession(
    namespace: "triangles_dialogs",
  );

  /// The session of the host that embeds Triangles, set while it is shown in
  /// one.
  static PageSession? hostSession;

  /// Asks [request]: the host draws it if it can, else Triangles does.
  ///
  /// Answers `null` if it was dismissed, or if nothing is there to draw it.
  static Future<DialogResult?> ask(DialogRequest request) {
    final PageSession? host = hostSession;

    if (host != null && !host.isDisposed && host.canShowDialog) {
      return host.showDialog(request);
    }

    return _localSession.showDialog(request);
  }
}
