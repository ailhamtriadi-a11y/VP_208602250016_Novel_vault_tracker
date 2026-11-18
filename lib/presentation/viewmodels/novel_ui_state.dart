import 'package:equatable/equatable.dart';

import '../../domain/entities/novel.dart';

sealed class NovelUiState extends Equatable {
  const NovelUiState();

  @override
  List<Object?> get props => [];
}

final class NovelInitialState extends NovelUiState {
  const NovelInitialState();
}

final class NovelLoadingState extends NovelUiState {
  const NovelLoadingState();
}

final class NovelEmptyState extends NovelUiState {
  final String message;

  const NovelEmptyState({
    this.message = 'Belum ada log novel. Tambahkan novel pertamamu!',
  });

  @override
  List<Object?> get props => [message];
}

final class NovelLoadedState extends NovelUiState {
  final List<Novel> allNovels;
  final List<Novel> filteredNovels;
  final String searchQuery;
  final String selectedCategory;
  final String selectedSubFilter;
  final String activeFilter;
  final bool isFilterVisible;
  final List<String> activityLogs;

  const NovelLoadedState({
    required this.allNovels,
    required this.filteredNovels,
    this.searchQuery = '',
    this.selectedCategory = 'All',
    this.selectedSubFilter = 'All',
    this.activeFilter = 'All',
    this.isFilterVisible = false,
    this.activityLogs = const ['📖 System: Novel Vault Tracker siap digunakan.'],
  });

  NovelLoadedState copyWith({
    List<Novel>? allNovels,
    List<Novel>? filteredNovels,
    String? searchQuery,
    String? selectedCategory,
    String? selectedSubFilter,
    String? activeFilter,
    bool? isFilterVisible,
    List<String>? activityLogs,
  }) {
    return NovelLoadedState(
      allNovels: allNovels ?? this.allNovels,
      filteredNovels: filteredNovels ?? this.filteredNovels,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedSubFilter: selectedSubFilter ?? this.selectedSubFilter,
      activeFilter: activeFilter ?? this.activeFilter,
      isFilterVisible: isFilterVisible ?? this.isFilterVisible,
      activityLogs: activityLogs ?? this.activityLogs,
    );
  }

  @override
  List<Object?> get props => [
        allNovels,
        filteredNovels,
        searchQuery,
        selectedCategory,
        selectedSubFilter,
        activeFilter,
        isFilterVisible,
        activityLogs,
      ];
}

final class NovelErrorState extends NovelUiState {
  final String message;

  const NovelErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
