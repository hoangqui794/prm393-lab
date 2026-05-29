import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab5/main.dart';

void main() {
  setUpAll(() {
    HttpOverrides.global = MockHttpOverrides();
  });

  tearDownAll(() {
    HttpOverrides.global = null;
  });

  testWidgets('MovieApp rendering, searching, navigation and interactive test', (WidgetTester tester) async {
    // 1. App Launch & Display check
    await tester.pumpWidget(const MovieApp());
    await tester.pump();

    // Verify home screen is loaded
    expect(find.text('Movies'), findsOneWidget);
    expect(find.text('Dune: Part Two'), findsOneWidget);
    expect(find.text('Deadpool & Wolverine'), findsOneWidget);

    // 2. Search filtering verification
    // Enter "Action" in the search bar
    await tester.enterText(find.byType(TextField), 'Action');
    await tester.pump();

    // Verify search filtered out "Dune: Part Two" and kept "Deadpool & Wolverine"
    expect(find.text('Dune: Part Two'), findsNothing);
    expect(find.text('Deadpool & Wolverine'), findsOneWidget);

    // Clear search
    await tester.enterText(find.byType(TextField), '');
    await tester.pump();

    // Verify both are back
    expect(find.text('Dune: Part Two'), findsOneWidget);
    expect(find.text('Deadpool & Wolverine'), findsOneWidget);

    // 3. Navigation to Detail Screen
    // Tap on Dune Part Two
    await tester.tap(find.text('Dune: Part Two'));
    await tester.pumpAndSettle(); // Wait for navigation animation

    // Verify we are now on Detail Screen
    // AppBar should display movie title
    expect(find.text('Dune: Part Two'), findsAtLeast(1));
    // Verify genres chips are rendered
    expect(find.text('Sci-Fi'), findsOneWidget);
    expect(find.text('Adventure'), findsOneWidget);
    expect(find.text('Drama'), findsOneWidget);
    // Verify overview text is rendered
    expect(find.textContaining('Paul Atreides unites with Chani'), findsOneWidget);
    // Verify action buttons are rendered
    expect(find.text('Favorite'), findsOneWidget);
    expect(find.text('Rate'), findsOneWidget);
    expect(find.text('Share'), findsOneWidget);
    // Verify trailers section
    expect(find.text('Trailers'), findsOneWidget);
    expect(find.text('Official Trailer #1'), findsOneWidget);
    expect(find.text('IMAX Sneak Peek'), findsOneWidget);

    // 4. Interactive Toggles (Favorite)
    // Verify starting state of Favorite (we show snackbar when favorited)
    await tester.tap(find.text('Favorite'));
    await tester.pump(); // Start snackbar animation
    expect(find.text('Added "Dune: Part Two" to Favorites!'), findsOneWidget);

    await tester.tap(find.text('Favorite'));
    await tester.pump();
    expect(find.text('Removed "Dune: Part Two" from Favorites.'), findsOneWidget);

    // 5. Rate & Share Actions
    await tester.tap(find.text('Rate'));
    await tester.pump();
    expect(find.text('You rated "Dune: Part Two" 5 stars!'), findsOneWidget);

    await tester.tap(find.text('Share'));
    await tester.pump();
    expect(find.text('Sharing link for "Dune: Part Two"...'), findsOneWidget);

    // 6. Navigation Back
    // Tap on the back button in AppBar
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle(); // Wait for navigation back animation

    // Verify we are back on Home Screen
    expect(find.text('Movies'), findsOneWidget);
    expect(find.text('Dune: Part Two'), findsOneWidget);
  });
}

// --- Mock Http Client classes to avoid Network Image failures during testing ---

class MockHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return MockHttpClient();
  }
}

class MockHttpClient extends Fake implements HttpClient {
  @override
  Future<HttpClientRequest> getUrl(Uri url) async => MockHttpClientRequest();
}

class MockHttpClientRequest extends Fake implements HttpClientRequest {
  @override
  Future<HttpClientResponse> close() async => MockHttpClientResponse();
}

class MockHttpClientResponse extends Fake implements HttpClientResponse {
  @override
  int get statusCode => 200;

  @override
  int get contentLength => transparentImage.length;

  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return Stream<List<int>>.fromIterable([transparentImage]).listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }
}

// 1x1 transparent GIF bytes
final List<int> transparentImage = [
  0x47, 0x49, 0x46, 0x38, 0x39, 0x61, 0x01, 0x00, 0x01, 0x00, 0x80, 0x00,
  0x00, 0x00, 0x00, 0x00, 0xff, 0xff, 0xff, 0x21, 0xf9, 0x04, 0x01, 0x00,
  0x00, 0x00, 0x00, 0x2c, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x01, 0x00,
  0x00, 0x02, 0x02, 0x4c, 0x01, 0x00, 0x3b
];
