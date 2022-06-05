import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:regalia/core/presentation/colors.dart";
import "package:regalia/core/presentation/shadows.dart";
import "package:regalia/features/navigation/presentation/navigation_list_view.dart";

class NavigationDrawer extends ConsumerWidget {
  final List<Widget> _children;

  const NavigationDrawer({super.key, List<Widget> children = const []}) : _children = children;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: SafeArea(
        child: Row(
          children: [
            const Expanded(child: NavigationListView()),
            Expanded(
              flex: 3,
              child: Container(
                margin: const EdgeInsets.only(top: 8, bottom: 8, right: 8),
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: AppColors.darkDark1,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  boxShadow: [AppShadows.darkElevation01],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _children,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
