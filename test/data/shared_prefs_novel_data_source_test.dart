import 'package:flutter_test/flutter_test.dart';
import 'package:novel_vault_tracker/core/error/failure.dart';
import 'package:novel_vault_tracker/data/datasources/shared_prefs_novel_data_source.dart';
import 'package:novel_vault_tracker/data/models/novel_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('first read initializes the seed novels', () async {
    final preferences = await SharedPreferences.getInstance();
    final dataSource = SharedPrefsNovelDataSource(
      sharedPreferences: preferences,
    );

    final novels = await dataSource.getNovels();

    expect(novels, hasLength(5));
    expect(novels.first.titleEnglish, isNotEmpty);
  });

  test('saved novels remain available from a new data source instance', () async {
    final preferences = await SharedPreferences.getInstance();
    final firstDataSource = SharedPrefsNovelDataSource(
      sharedPreferences: preferences,
    );
    final novels = await firstDataSource.getNovels();
    final addedNovel = NovelModel(
      id: 'persisted',
      titleEnglish: 'Persisted Novel',
      titleOriginal: '保存された小説',
      author: 'Test Author',
      status: 'Reading',
      currentChapter: 12,
      ratingValue: 4.5,
      imagePlaceholder: 'PN',
    );

    await firstDataSource.saveNovels([...novels, addedNovel]);
    final reopenedDataSource = SharedPrefsNovelDataSource(
      sharedPreferences: preferences,
    );
    final reloaded = await reopenedDataSource.getNovels();

    expect(reloaded, contains(addedNovel));
  });

  test('an intentionally empty list stays empty after reopening', () async {
    final preferences = await SharedPreferences.getInstance();
    final firstDataSource = SharedPrefsNovelDataSource(
      sharedPreferences: preferences,
    );
    await firstDataSource.getNovels();
    await firstDataSource.saveNovels([]);
    final reopenedDataSource = SharedPrefsNovelDataSource(
      sharedPreferences: preferences,
    );

    expect(await reopenedDataSource.getNovels(), isEmpty);
  });

  test('malformed stored data returns a cache failure', () async {
    SharedPreferences.setMockInitialValues({
      'novel_vault_initialized_v1': true,
      'novel_vault_logs_v1': ['{}'],
    });
    final preferences = await SharedPreferences.getInstance();
    final dataSource = SharedPrefsNovelDataSource(
      sharedPreferences: preferences,
    );

    await expectLater(dataSource.getNovels(), throwsA(isA<CacheFailure>()));
  });
}
