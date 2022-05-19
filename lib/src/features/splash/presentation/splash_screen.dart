import "package:flutter/material.dart";

import "../../../common_widgets/regalia_logo.dart";

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: RegaliaLogo());
  }
}
