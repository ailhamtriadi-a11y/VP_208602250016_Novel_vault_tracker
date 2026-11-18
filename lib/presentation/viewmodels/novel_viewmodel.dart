import 'package:flutter/foundation.dart';

import '../../core/error/failure.dart';
import '../../domain/entities/novel.dart';
import '../../domain/repositories/novel_repository.dart';
import '../../domain/services/novel_service.dart';
import 'novel_ui_state.dart';

class NovelViewModel extends ChangeNotifier {
  final NovelRepository repository;
  final NovelService service;

  NovelUiState _state = const NovelInitialState();
  NovelUiState get state => _state;

  bool _isDisposed = false;
  final List<String> _activityLogs = [
    '📖 System: Novel Vault Tracker siap digunakan.',
  ];

  NovelViewModel({NovelRepository? repository, NovelService? service})
    : assert(repository != null || service != null),
      repository = repository ?? service!.repository,
      service = service ?? NovelService(repository!);

  void _emit(NovelUiState newState) {
    if (_isDisposed) return;
    _state = newState;
    notifyListeners();
  }

  Future<void> loadNovels() async {
    _emit(const NovelLoadingState());
    try {
      final novels = await service.getSortedNovels();
      if (_isDisposed) return;

      if (novels.isEmpty) {
        _emit(const NovelEmptyState());
        return;
      }

      _emit(
        NovelLoadedState(
          allNovels: novels,
          filteredNovels: novels,
          activityLogs: List.unmodifiable(_activityLogs),
        ),
      );
    } on Failure catch (failure) {
      if (_isDisposed) return;
      _emit(NovelErrorState(failure.message));
    } catch (_) {
      if (_isDisposed) return;
      _emit(
        const NovelErrorState('Gagal memuat daftar novel. Silakan coba lagi.'),
      );
    }
  }

  Future<void> addNovel(Novel novel) async {
    try {
      await service.addNovel(novel);
      if (_isDisposed) return;

      _activityLogs.insert(0, '➕ Tambah: [${novel.titleEnglish}]');
      await _refreshPreservingFilters();
    } on Failure catch (failure) {
      if (_isDisposed) return;
      _emit(NovelErrorState(failure.message));
    } on Exception catch (exception) {
      if (_isDisposed) return;
      _emit(NovelErrorState(
        exception.toString().replaceFirst('Exception: ', ''),
      ));
    } catch (_) {
      if (_isDisposed) return;
      _emit(const NovelErrorState('Gagal menambahkan log novel baru.'));
    }
  }

  Future<void> updateNovel(Novel novel) async {
    try {
      await service.updateNovel(novel);
      if (_isDisposed) return;

      _activityLogs.insert(0, '✏️ Edit: [${novel.titleEnglish}]');
      await _refreshPreservingFilters();
    } on Failure catch (failure) {
      if (_isDisposed) return;
      _emit(NovelErrorState(failure.message));
    } on Exception catch (exception) {
      if (_isDisposed) return;
      _emit(NovelErrorState(
        exception.toString().replaceFirst('Exception: ', ''),
      ));
    } catch (_) {
      if (_isDisposed) return;
      _emit(const NovelErrorState('Gagal memperbarui log novel.'));
    }
  }

  Future<void> deleteNovel(Novel novel) async {
    try {
      await service.deleteNovel(novel.id);
      if (_isDisposed) return;

      _activityLogs.insert(0, '❌ Hapus: [${novel.titleEnglish}]');
      await _refreshPreservingFilters();
    } on Failure catch (failure) {
      if (_isDisposed) return;
      _emit(NovelErrorState(failure.message));
    } on Exception catch (exception) {
      if (_isDisposed) return;
      _emit(NovelErrorState(
        exception.toString().replaceFirst('Exception: ', ''),
      ));
    } catch (_) {
      if (_isDisposed) return;
      _emit(const NovelErrorState('Gagal menghapus log novel.'));
    }
  }

  Future<void> toggleBookmark(Novel novel) async {
    try {
      await service.toggleBookmark(novel.id);
      if (_isDisposed) return;

      final nextStatus = !novel.isSaved;
      _activityLogs.insert(
        0,
        nextStatus
            ? '🔖 Bookmark: [${novel.titleEnglish}]'
            : '🗑️ Unbookmark: [${novel.titleEnglish}]',
      );
      await _refreshPreservingFilters();
    } on Failure catch (failure) {
      if (_isDisposed) return;
      _emit(NovelErrorState(failure.message));
    } on Exception catch (exception) {
      if (_isDisposed) return;
      _emit(NovelErrorState(
        exception.toString().replaceFirst('Exception: ', ''),
      ));
    } catch (_) {
      if (_isDisposed) return;
      _emit(const NovelErrorState('Gagal mengubah status bookmark.'));
    }
  }

  void updateSearchQuery(String query) {
    final current = _state;
    if (current is! NovelLoadedState) return;

    final updated = current.copyWith(searchQuery: query);
    _emit(updated.copyWith(filteredNovels: _applyFilterLogic(updated)));
  }

  void toggleFilterVisibility() {
    final current = _state;
    if (current is! NovelLoadedState) return;

    _emit(current.copyWith(isFilterVisible: !current.isFilterVisible));
  }

  void selectCategory(String category) {
    final current = _state;
    if (current is! NovelLoadedState) return;

    _emit(
      current.copyWith(selectedCategory: category, selectedSubFilter: 'All'),
    );
  }

  void selectSubFilter(String subFilter) {
    final current = _state;
    if (current is! NovelLoadedState) return;

    _emit(current.copyWith(selectedSubFilter: subFilter));
  }

  void applyFilter() {
    final current = _state;
    if (current is! NovelLoadedState) return;

    final updated = current.copyWith(activeFilter: current.selectedSubFilter);
    _emit(updated.copyWith(filteredNovels: _applyFilterLogic(updated)));
  }

  void resetFilters() {
    final current = _state;
    if (current is! NovelLoadedState) return;

    final updated = current.copyWith(
      searchQuery: '',
      selectedCategory: 'All',
      selectedSubFilter: 'All',
      activeFilter: 'All',
    );
    _emit(updated.copyWith(filteredNovels: _applyFilterLogic(updated)));
  }

  Future<void> _refreshPreservingFilters() async {
    final novels = await service.getSortedNovels();
    if (_isDisposed) return;

    if (novels.isEmpty) {
      _emit(const NovelEmptyState());
      return;
    }

    final previous = _state;
    if (previous is NovelLoadedState) {
      final updated = previous.copyWith(
        allNovels: novels,
        activityLogs: List.unmodifiable(_activityLogs),
      );
      _emit(updated.copyWith(filteredNovels: _applyFilterLogic(updated)));
    } else {
      _emit(
        NovelLoadedState(
          allNovels: novels,
          filteredNovels: novels,
          activityLogs: List.unmodifiable(_activityLogs),
        ),
      );
    }
  }

  List<Novel> _applyFilterLogic(NovelLoadedState state) {
    final query = state.searchQuery.trim().toLowerCase();

    return state.allNovels.where((novel) {
      final matchesQuery =
          query.isEmpty ||
          novel.titleEnglish.toLowerCase().contains(query) ||
          novel.titleOriginal.toLowerCase().contains(query) ||
          novel.author.toLowerCase().contains(query);

      if (!matchesQuery) return false;
      if (state.activeFilter == 'All') return true;

      if (state.activeFilter.contains('Stars')) {
        final rawNumber = state.activeFilter.split(' ')[0].replaceAll('+', '');
        final targetRating = double.tryParse(rawNumber) ?? 0.0;
        return state.activeFilter.contains('+')
            ? novel.ratingValue >= targetRating
            : novel.ratingValue == targetRating;
      }

      return novel.status == state.activeFilter;
    }).toList();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
