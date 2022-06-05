import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:regalia/features/navigation/application/navigation_service.dart";
import "package:regalia/features/navigation/domain/navigation_item.dart";
import "package:regalia/features/navigation/presentation/navigation_list_tile.dart";

class NavigationListView extends ConsumerWidget {
  const NavigationListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigationService = ref.watch(navigationServiceProvider);
    return navigationService.when(
      data: _drawNavigationList,
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => const Center(child: Text("Error")),
    );
  }

  Widget _drawNavigationList(final List<NavigationItem> items) {
    return ListView.separated(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return NavigationListTile(item);
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: 16);
      },
    );
  }
}
