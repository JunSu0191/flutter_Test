import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shape_match_game/main.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that our score starts at 0.
    expect(find.text('Score: 0'), findsOneWidget);
    expect(find.text('Score: 1'), findsNothing);

    // Tap the 'Add Shape and Score' button and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our score has incremented.
    expect(find.text('Score: 0'), findsNothing);
    expect(find.textContaining('Score: '), findsOneWidget);
  });
}
