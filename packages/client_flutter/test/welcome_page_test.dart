import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:client_common/client_common.dart";
import "package:client_flutter/pages/welcome_page.dart";

void main() {
  testWidgets("WelcomeView renders combined home and about information",
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: WelcomeView(),
        ),
      ),
    );

    // Verify SelectionArea exists so text is selectable
    expect(find.byType(SelectionArea), findsOneWidget);

    // Verify Home content
    expect(find.text(AppStrings.welcomeHeadline), findsOneWidget);
    expect(find.text(AppStrings.welcomeSubtitle), findsOneWidget);
    expect(find.text(AppStrings.welcomeGetGeneratingTitle), findsOneWidget);
    expect(find.text(AppStrings.welcomeInstructions), findsOneWidget);
    expect(find.text(AppStrings.welcomeEnjoy), findsOneWidget);

    // Verify About / Information content
    expect(find.text(AppStrings.aboutProjectTitle), findsOneWidget);
    expect(find.text(AppStrings.aboutProjectDescription), findsOneWidget);
    expect(find.text(AppStrings.aboutSoftwareTitle), findsOneWidget);
    expect(find.text(AppStrings.aboutSoftwareDescription), findsOneWidget);
    expect(find.text(AppStrings.aboutFlutterLink), findsOneWidget);
    expect(find.text(AppStrings.aboutJasprLink), findsOneWidget);
    expect(find.text(AppStrings.aboutRomainGuyLink), findsOneWidget);
    expect(find.text(AppStrings.aboutImagesTitle), findsOneWidget);
    expect(find.text(AppStrings.aboutImagesDescription), findsOneWidget);
    expect(find.text(AppStrings.aboutLoremPicsumLink), findsOneWidget);
    expect(find.text(AppStrings.aboutSubtlePatternsLink), findsOneWidget);
    expect(find.text(AppStrings.aboutLegalTitle), findsOneWidget);
    expect(find.text(AppStrings.aboutLegalDescription), findsOneWidget);
  });
}
