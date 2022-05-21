import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../authentication/application/credential_service.dart";
import "../../helix/presentation/client_user_drawer_footer.dart";

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      drawerEdgeDragWidth: MediaQuery.of(context).size.width,
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    /// Followed Channel List
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      width: MediaQuery.of(context).size.width * 0.20,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(15, 255, 255, 255),
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),
                            // Pinned Items
                            child: Wrap(
                              direction: Axis.vertical,
                              runAlignment: WrapAlignment.center,
                              spacing: 5,
                              children: const [
                                CircleAvatar(
                                  radius: 24,
                                ),
                                CircleAvatar(radius: 24),
                              ],
                            ),
                          ),
                          Expanded(
                            child: ReorderableListView.builder(
                              shrinkWrap: true,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              itemCount: 10,
                              itemBuilder: (context, index) {
                                return Container(
                                  key: ValueKey(index),
                                  margin: const EdgeInsets.all(4),
                                  child: CircleAvatar(
                                    radius: 24,
                                    backgroundColor: Colors.red,
                                    backgroundImage: NetworkImage("https://picsum.photos/200?$index"),
                                  ),
                                );
                              },
                              onReorder: (oldIndex, newIndex) {
                                print("$oldIndex -> $newIndex");
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// Chat Tab List
                    Expanded(
                      child: Container(
                          padding: const EdgeInsets.fromLTRB(5, 15, 15, 5),
                          child: Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                              color: Color.fromARGB(15, 255, 255, 255),
                            ),
                          )),
                    ),
                  ],
                ),
              ),
              const ClientUserDrawerFooter()
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.logout),
        onPressed: () {
          ref.read(credentialServiceProvider.notifier).logout();
        },
      ),
    );
  }
}
