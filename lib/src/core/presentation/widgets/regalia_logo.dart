import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";

/// Widget for displaying the Regalia logo.
///
/// Returns the logo in the [color] if specified or a color that
/// is visible on the background.
class RegaliaLogo extends StatelessWidget {
  final Color? color;

  const RegaliaLogo({Key? key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      "assets/images/logo_default_monochrome.svg",
      color: color ?? Theme.of(context).colorScheme.onBackground,
      semanticsLabel: "Regalia Logo",
    );
  }
}
