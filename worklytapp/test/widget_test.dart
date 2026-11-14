import 'package:flutter_test/flutter_test.dart';
import 'package:worklyapp/main.dart';

void main() {
  testWidgets('Workly app displays its home screen', (tester) async {
    await tester.pumpWidget(const WorklyApp());

    expect(find.text('Workly'), findsOneWidget);
    expect(
      find.text(
        'Workly business logic initialized. UI will be added after the core flows are validated.',
      ),
      findsOneWidget,
    );
  });
}
