import 'package:flutter/material.dart';

class ControlPanelWidget extends StatefulWidget {
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final bool isFilterVisible;
  final VoidCallback onToggleFilter;
  final String selectedCategory;
  final String selectedSubFilter;
  final ValueChanged<String> onCategorySelected;
  final ValueChanged<String> onSubFilterSelected;
  final VoidCallback onApplyFilter;
  final VoidCallback onClearFilter;
  final List<String> newsUpdates;
  final String activeFilter;

  const ControlPanelWidget({
    super.key,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.isFilterVisible,
    required this.onToggleFilter,
    required this.selectedCategory,
    required this.selectedSubFilter,
    required this.onCategorySelected,
    required this.onSubFilterSelected,
    required this.onApplyFilter,
    required this.onClearFilter,
    required this.newsUpdates,
    required this.activeFilter,
  });

  @override
  State<ControlPanelWidget> createState() => _ControlPanelWidgetState();
}

class _ControlPanelWidgetState extends State<ControlPanelWidget> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.searchQuery);
  }

  @override
  void didUpdateWidget(covariant ControlPanelWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.searchQuery != _searchController.text) {
      _searchController.text = widget.searchQuery;
      _searchController.selection = TextSelection.fromPosition(
        TextPosition(offset: _searchController.text.length),
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subFilters = widget.selectedCategory == 'Status'
        ? ['Reading', 'Completed', 'Plan to Read', 'Dropped']
        : widget.selectedCategory == 'Rating'
            ? ['5 Stars', '4.5+ Stars', '4 Stars', '3+ Stars']
            : <String>[];

    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _searchController,
              onChanged: widget.onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Cari judul/penulis...',
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: widget.searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          widget.onSearchChanged('');
                        },
                      )
                    : IconButton(
                        icon: Icon(
                          widget.isFilterVisible
                              ? Icons.filter_list_off
                              : Icons.filter_list,
                          size: 20,
                        ),
                        onPressed: widget.onToggleFilter,
                      ),
                border: const OutlineInputBorder(),
                isDense: true,
              ),
            ),
            if (widget.isFilterVisible) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: ['Status', 'Rating'].map((cat) {
                  return ChoiceChip(
                    label: Text(cat, style: const TextStyle(fontSize: 11)),
                    selected: widget.selectedCategory == cat,
                    onSelected: (_) => widget.onCategorySelected(
                      widget.selectedCategory == cat ? 'All' : cat,
                    ),
                  );
                }).toList(),
              ),
              if (subFilters.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: subFilters.map((sub) {
                    return ChoiceChip(
                      label: Text(sub, style: const TextStyle(fontSize: 11)),
                      selected: widget.selectedSubFilter == sub,
                      onSelected: (_) => widget.onSubFilterSelected(sub),
                    );
                  }).toList(),
                ),
              ],
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: widget.onClearFilter,
                    child: const Text('Reset', style: TextStyle(fontSize: 12)),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: widget.onApplyFilter,
                    child: const Text('Terapkan', style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ],
            if (widget.newsUpdates.isNotEmpty) ...[
              const Divider(height: 16),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 120),
                child: Scrollbar(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.newsUpdates.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.campaign_outlined, size: 15),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                widget.newsUpdates[index],
                                style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}