import 'package:flutter_test/flutter_test.dart';
import 'package:novel_vault_tracker/data/datasources/in_memory_novel_data_source.dart';
import 'package:novel_vault_tracker/data/repositories/novel_repository_impl.dart';
import 'package:novel_vault_tracker/domain/entities/novel.dart';
import 'package:novel_vault_tracker/presentation/viewmodels/novel_ui_state.dart';
import 'package:novel_vault_tracker/presentation/viewmodels/novel_viewmodel.dart';

void main() {
  late NovelViewModel viewModel;

  setUp(() {
    viewModel = NovelViewModel(
      repository: NovelRepositoryImpl(dataSource: InMemoryNovelDataSource()),
    );
  });

  tearDown(() {
    viewModel.dispose();
  });

  test('loading an empty repository displays the empty state', () async {
    await viewModel.loadNovels();

    expect(viewModel.state, isA<NovelEmptyState>());
  });

  test('adding a valid novel refreshes the loaded state', () async {
    const novel = Novel(
      id: 'new',
      titleEnglish: 'New Novel',
      titleOriginal: '新しい小説',
      author: 'Test Author',
      status: 'Reading',
      currentChapter: 1,
      ratingValue: 4,
      imagePlaceholder: 'NN',
    );

    await viewModel.addNovel(novel);

    final state = viewModel.state as NovelLoadedState;
    expect(state.allNovels.single.id, novel.id);
    expect(state.filteredNovels.single.id, novel.id);
  });

  test('invalid novel data is exposed as an error state', () async {
    const novel = Novel(
      id: 'invalid',
      titleEnglish: 'Invalid Rating',
      titleOriginal: '無効な評価',
      author: 'Test Author',
      status: 'Reading',
      currentChapter: 1,
      ratingValue: double.nan,
      imagePlaceholder: 'IR',
    );

    await viewModel.addNovel(novel);

    expect(viewModel.state, isA<NovelErrorState>());
  });

  test(
    'search matches title, original title, and author without case sensitivity',
    () async {
      final titleMatch = _novel(
        id: 'title-match',
        title: 'The Silver Novel',
        originalTitle: '銀の小説',
        author: 'Writer One',
      );
      final authorMatch = _novel(
        id: 'author-match',
        title: 'A Different Story',
        originalTitle: '別の物語',
        author: 'Writer Two',
      );
      await viewModel.addNovel(titleMatch);
      await viewModel.addNovel(authorMatch);

      viewModel.updateSearchQuery('  WRITER TWO  ');

      final state = viewModel.state as NovelLoadedState;
      expect(state.filteredNovels.map((novel) => novel.id), ['author-match']);
      expect(state.allNovels, hasLength(2));
    },
  );

  test('status filter applies and reset restores the complete list', () async {
    await viewModel.addNovel(
      _novel(id: 'reading', title: 'Reading Novel', status: 'Reading'),
    );
    await viewModel.addNovel(
      _novel(id: 'completed', title: 'Completed Novel', status: 'Completed'),
    );

    viewModel.selectCategory('Status');
    viewModel.selectSubFilter('Completed');
    viewModel.applyFilter();

    var state = viewModel.state as NovelLoadedState;
    expect(state.filteredNovels.map((novel) => novel.id), ['completed']);

    viewModel.resetFilters();

    state = viewModel.state as NovelLoadedState;
    expect(state.filteredNovels, hasLength(2));
    expect(state.activeFilter, 'All');
  });

  test('bookmark can be toggled on and off', () async {
    await viewModel.addNovel(_novel(id: 'bookmark'));
    var novel = (viewModel.state as NovelLoadedState).allNovels.single;

    await viewModel.toggleBookmark(novel);
    var state = viewModel.state as NovelLoadedState;
    expect(state.allNovels.single.isSaved, isTrue);
    expect(state.activityLogs.first, contains('Bookmark'));

    novel = state.allNovels.single;
    await viewModel.toggleBookmark(novel);
    state = viewModel.state as NovelLoadedState;
    expect(state.allNovels.single.isSaved, isFalse);
    expect(state.activityLogs.first, contains('Unbookmark'));
  });

  test(
    'updated novel is retained and deleting the last novel shows empty state',
    () async {
      final original = _novel(id: 'edit-delete', title: 'Original Title');
      await viewModel.addNovel(original);
      final updated = original.copyWith(titleEnglish: 'Updated Title');

      await viewModel.updateNovel(updated);

      var state = viewModel.state as NovelLoadedState;
      expect(state.allNovels.single.titleEnglish, 'Updated Title');

      await viewModel.deleteNovel(updated);

      expect(viewModel.state, isA<NovelEmptyState>());
    },
  );
}

Novel _novel({
  required String id,
  String title = 'Test Novel',
  String originalTitle = '試験小説',
  String author = 'Test Author',
  String status = 'Reading',
}) {
  return Novel(
    id: id,
    titleEnglish: title,
    titleOriginal: originalTitle,
    author: author,
    status: status,
    currentChapter: 10,
    ratingValue: 4.5,
    imagePlaceholder: 'TN',
  );
}
