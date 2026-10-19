import "package:flutter/material.dart";

class TrianglesShellScope extends InheritedWidget {
  final bool isSmall;

  const TrianglesShellScope({
    this.isSmall = false,
    required super.child,
    super.key,
  });

  static TrianglesShellScope? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TrianglesShellScope>();
  }

  @override
  bool updateShouldNotify(TrianglesShellScope oldWidget) =>
      isSmall != oldWidget.isSmall;
}

abstract class TrianglesUiHelper {
  static const double drawerWidth = 280;
  static const double breakpointWidth = 500;
  static const double minContentWidth = 600;

  static bool isSmall(BoxConstraints constraints,
          {double breakpoint = breakpointWidth}) =>
      constraints.maxWidth <= breakpoint;

  static Widget shell({
    required Widget drawer,
    required Widget child,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final small = isSmall(constraints);

        return TrianglesShellScope(
          isSmall: small,
          child: small
              ? child
              : Scaffold(
                  body: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        width: drawerWidth,
                        child: Material(
                          color:
                              Theme.of(context).drawerTheme.backgroundColor ??
                                  Theme.of(context)
                                      .navigationDrawerTheme
                                      .backgroundColor ??
                                  Theme.of(context).colorScheme.surface,
                          child: SafeArea(
                            bottom: false,
                            child: drawer,
                          ),
                        ),
                      ),
                      VerticalDivider(
                        width: 1,
                        thickness: 1,
                        color: Theme.of(context).dividerColor,
                      ),
                      Expanded(
                        child: SafeArea(
                          left: false,
                          top: false,
                          bottom: false,
                          child: _horizontallyScrollable(child),
                        ),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }

  static Widget _horizontallyScrollable(Widget child) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= minContentWidth) {
          return child;
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: minContentWidth,
            height: constraints.maxHeight,
            child: child,
          ),
        );
      },
    );
  }

  static Widget pageScaffold({
    PreferredSizeWidget? appBar,
    Widget? drawer,
    Widget? endDrawer,
    Widget? body,
    Widget Function(BuildContext context, BoxConstraints constraints)?
        bodyBuilder,
    bool showDrawer = true,
    bool showAppBar = true,
  }) {
    assert(body != null || bodyBuilder != null,
        "Either body or bodyBuilder must be provided");

    Widget buildBody(BuildContext context, BoxConstraints constraints) {
      if (body != null) {
        return body;
      }
      return bodyBuilder!(context, constraints);
    }

    if (!showAppBar && !showDrawer) {
      if (endDrawer != null) {
        return Scaffold(
          endDrawer: endDrawer,
          body: body ??
              LayoutBuilder(
                builder: (context, constraints) =>
                    buildBody(context, constraints),
              ),
        );
      }
      return body ??
          LayoutBuilder(
            builder: (context, constraints) => buildBody(context, constraints),
          );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final shellScope = TrianglesShellScope.of(context);
        final small = shellScope?.isSmall ?? isSmall(constraints);
        final effectiveDrawer = showDrawer ? drawer : null;
        final effectiveAppBar = showAppBar ? appBar : null;

        if (shellScope != null) {
          return Scaffold(
            appBar: effectiveAppBar,
            drawer: (small && effectiveDrawer != null)
                ? Drawer(
                    width: drawerWidth,
                    child: SafeArea(
                      bottom: false,
                      child: effectiveDrawer,
                    ),
                  )
                : null,
            endDrawer: endDrawer,
            body: body ??
                LayoutBuilder(
                  builder: (context, innerConstraints) =>
                      buildBody(context, innerConstraints),
                ),
          );
        }

        if (small || effectiveDrawer == null) {
          return Scaffold(
            appBar: effectiveAppBar,
            drawer: effectiveDrawer != null
                ? Drawer(
                    width: drawerWidth,
                    child: SafeArea(
                      bottom: false,
                      child: effectiveDrawer,
                    ),
                  )
                : null,
            endDrawer: endDrawer,
            body: body ??
                LayoutBuilder(
                  builder: (context, innerConstraints) =>
                      buildBody(context, innerConstraints),
                ),
          );
        }

        final theme = Theme.of(context);
        final sidebarBg = theme.drawerTheme.backgroundColor ??
            theme.navigationDrawerTheme.backgroundColor ??
            theme.colorScheme.surface;

        return Scaffold(
          body: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: drawerWidth,
                child: Material(
                  color: sidebarBg,
                  child: SafeArea(
                    bottom: false,
                    child: effectiveDrawer,
                  ),
                ),
              ),
              VerticalDivider(
                width: 1,
                thickness: 1,
                color: theme.dividerColor,
              ),
              Expanded(
                child: Scaffold(
                  appBar: effectiveAppBar,
                  endDrawer: endDrawer,
                  body: body ??
                      LayoutBuilder(
                        builder: (context, innerConstraints) =>
                            buildBody(context, innerConstraints),
                      ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
