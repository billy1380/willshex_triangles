import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:client_common/client_common.dart";
import "package:client_flutter/parts/app_drawer.dart";

class WelcomePage extends StatelessWidget {
  static const String routePath = "/welcome";

  static Widget builder(BuildContext context, GoRouterState state) {
    return const WelcomePage._();
  }

  const WelcomePage._();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text(AppStrings.navWelcome),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppStrings.welcomeHeadline,
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 16),
                const Text(AppStrings.welcomeSubtitle),
                const SizedBox(height: 24),
                Center(
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      _buildSample(context, "samples/19.jpeg"),
                      _buildSample(context, "samples/33.jpeg"),
                      _buildSample(context, "samples/29.jpeg"),
                      _buildSample(context, "samples/32.jpeg"),
                      _buildSample(context, "samples/14.jpeg"),
                      _buildSample(context, "samples/34.jpeg"),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Text(AppStrings.welcomeInstructions),
                const SizedBox(height: 16),
                const Text(AppStrings.welcomeEnjoy),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSample(BuildContext context, String imagePath) {
    return Container(
      width: 200,
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        "assets/$imagePath",
        fit: BoxFit.cover,
      ),
    );
  }
}
