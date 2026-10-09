import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/models/product_filter.dart';
import '../../providers/filter_providers.dart';
import '../../providers/product_providers.dart';
import '../l10n_extensions.dart';

/// Délai avant d'appliquer la recherche : on ne refiltre pas le catalogue
/// à chaque frappe.
const searchDebounce = Duration(milliseconds: 300);

class CatalogSearchField extends HookConsumerWidget {
  const CatalogSearchField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController(
      text: ref.read(filterProvider).searchQuery,
    );
    final text = useValueListenable(controller).text;

    useEffect(() {
      Timer? timer;
      void listener() {
        timer?.cancel();
        timer = Timer(searchDebounce, () {
          ref.read(filterProvider.notifier).setSearchQuery(controller.text);
        });
      }

      controller.addListener(listener);
      return () {
        timer?.cancel();
        controller.removeListener(listener);
      };
    }, [controller]);

    // Garde le champ synchronisé si les filtres sont réinitialisés ailleurs.
    ref.listen(filterProvider.select((f) => f.searchQuery), (_, next) {
      if (next.isEmpty && controller.text.isNotEmpty) controller.clear();
    });

    final l10n = context.l10n;
    return Semantics(
      label: l10n.searchLabel,
      textField: true,
      child: TextField(
        controller: controller,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: l10n.searchHint,
          prefixIcon: const Icon(Icons.search),
          isDense: true,
          suffixIcon: text.isEmpty
              ? null
              : IconButton(
                  tooltip: l10n.searchClear,
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    controller.clear();
                    ref.read(filterProvider.notifier).setSearchQuery('');
                  },
                ),
        ),
      ),
    );
  }
}

class CategoryChips extends ConsumerWidget {
  const CategoryChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider);
    final selected = ref.watch(filterProvider.select((f) => f.category));
    final notifier = ref.read(filterProvider.notifier);
    final l10n = context.l10n;

    return Semantics(
      container: true,
      label: l10n.categoryFilterLabel,
      child: SizedBox(
        height: 56,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            _Chip(
              label: l10n.categoryAll,
              selected: selected == null,
              onSelected: () => notifier.setCategory(null),
            ),
            for (final category in categories)
              _Chip(
                label: category.label(l10n),
                selected: selected == category,
                onSelected: () => notifier.setCategory(category),
              ),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onSelected(),
        labelStyle: selected
            ? TextStyle(color: Theme.of(context).colorScheme.onPrimary)
            : null,
      ),
    );
  }
}

class SortMenuButton extends ConsumerWidget {
  const SortMenuButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(filterProvider.select((f) => f.sortOption));
    final l10n = context.l10n;
    return PopupMenuButton<SortOption>(
      tooltip: l10n.sortLabel,
      icon: const Icon(Icons.sort),
      initialValue: current,
      onSelected: ref.read(filterProvider.notifier).setSortOption,
      itemBuilder: (context) => [
        for (final option in SortOption.values)
          CheckedPopupMenuItem(
            value: option,
            checked: option == current,
            child: Text(option.label(l10n)),
          ),
      ],
    );
  }
}
