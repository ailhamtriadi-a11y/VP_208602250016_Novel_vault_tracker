import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/novel.dart';
import '../viewmodels/novel_viewmodel.dart';
import '../viewmodels/novel_ui_state.dart';
import '../widgets/control_panel_widget.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/novel_card_widget.dart';
import 'add_edit_log_screen.dart';
import 'novel_detail_screen.dart';

class PrimaryScreen extends StatelessWidget {
  const PrimaryScreen({super.key});

  Future<void> _openAddScreen(BuildContext context) async {
    final vm = context.read<NovelViewModel>();
    final result = await Navigator.push<Novel>(
      context,
      MaterialPageRoute(builder: (_) => const AddEditLogScreen()),
    );
    if (result != null) {
      await vm.addNovel(result);
    }
  }

  Future<void> _openEditScreen(BuildContext context, Novel novel) async {
    final vm = context.read<NovelViewModel>();
    final result = await Navigator.push<Novel>(
      context,
      MaterialPageRoute(builder: (_) => AddEditLogScreen(novelToEdit: novel)),
    );
    if (result != null) {
      await vm.updateNovel(result);
    }
  }

  Widget _buildNovelList(BuildContext context, NovelLoadedState state) {
    final vm = context.read<NovelViewModel>();
    if (state.filteredNovels.isEmpty) {
      return EmptyStateWidget(onReset: vm.resetFilters);
    }

    return ListView.builder(
      key: const PageStorageKey('novel_list'),
      padding: const EdgeInsets.only(bottom: 24),
      itemCount: state.filteredNovels.length,
      itemBuilder: (context, index) {
        final novel = state.filteredNovels[index];
        return NovelCardWidget(
          novel: novel,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => NovelDetailScreen(novel: novel)),
          ),
          onEdit: () => _openEditScreen(context, novel),
          onSave: () => vm.toggleBookmark(novel),
          onDelete: () => vm.deleteNovel(novel),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<NovelViewModel>();
    final state = vm.state;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Novel Vault Tracker'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Tambah Log Novel',
            onPressed: () => _openAddScreen(context),
          ),
        ],
      ),
      floatingActionButton: MediaQuery.of(context).size.width >= 600
          ? null
          : FloatingActionButton.extended(
              onPressed: () => _openAddScreen(context),
              icon: const Icon(Icons.add),
              label: const Text('Tambah Log'),
            ),
      body: SafeArea(
        child: switch (state) {
          NovelInitialState() || NovelLoadingState() => const Center(
              child: CircularProgressIndicator(),
            ),
          NovelErrorState(:final message) => Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 56,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: vm.loadNovels,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            ),
          NovelEmptyState(:final message) => EmptyStateWidget(
              title: 'Daftar Novel Kosong',
              subtitle: message,
              buttonLabel: 'Tambah Novel Pertama',
              onReset: () => _openAddScreen(context),
            ),
          NovelLoadedState() => LayoutBuilder(
              builder: (context, constraints) {
                final controlPanel = ControlPanelWidget(
                  searchQuery: state.searchQuery,
                  onSearchChanged: vm.updateSearchQuery,
                  isFilterVisible: state.isFilterVisible,
                  onToggleFilter: vm.toggleFilterVisibility,
                  selectedCategory: state.selectedCategory,
                  selectedSubFilter: state.selectedSubFilter,
                  onCategorySelected: vm.selectCategory,
                  onSubFilterSelected: vm.selectSubFilter,
                  onApplyFilter: vm.applyFilter,
                  onClearFilter: vm.resetFilters,
                  newsUpdates: state.activityLogs,
                  activeFilter: state.activeFilter,
                );

                final isTablet = constraints.maxWidth >= 600;
                if (isTablet) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 280,
                          child: SingleChildScrollView(child: controlPanel),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tracked Novels (${state.filteredNovels.length})',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Expanded(child: _buildNovelList(context, state)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: controlPanel,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: _buildNovelList(context, state),
                      ),
                    ),
                  ],
                );
              },
            ),
        },
      ),
    );
  }
}