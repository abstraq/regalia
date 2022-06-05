import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:go_router/go_router.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:regalia/core/presentation/shadows.dart";
import "package:regalia/features/navigation/domain/navigation_item.dart";
import "package:regalia/routing/router.dart";

class NavigationListTile extends ConsumerWidget {
  final NavigationItem _item;

  const NavigationListTile(this._item, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = ref.watch(routerProvider).location;
    return _item.when(
      channel: (broadcaster, _) {
        return Row(
          children: [
            location == "/channels/${broadcaster.id}"
                ? const Icon(Icons.chevron_right_rounded, size: 16)
                : const SizedBox(width: 16),
            GestureDetector(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [AppShadows.darkElevation02],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(broadcaster.profileImageUrl, width: 48, height: 48),
                ),
              ),
              onTap: () {
                HapticFeedback.mediumImpact();
                context.go("/channels/${broadcaster.id}");
              },
            ),
          ],
        );
      },
    );
  }
}
