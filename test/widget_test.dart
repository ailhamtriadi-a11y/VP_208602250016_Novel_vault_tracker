// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:novel_vault_tracker/data/datasources/in_memory_novel_data_source.dart';
import 'package:novel_vault_tracker/data/repositories/novel_repository_impl.dart';
import 'package:novel_vault_tracker/main.dart';

void main() {
  testWidgets('Novel Vault Tracker opens', (WidgetTester tester) async {
    final repository = NovelRepositoryImpl(
      dataSource: InMemoryNovelDataSource(),
    );

    await tester.pumpWidget(MyApp(repository: repository));
    await tester.pump(const Duration(milliseconds: 60));

    expect(find.text('Novel Vault Tracker'), findsOneWidget);
  });
}
