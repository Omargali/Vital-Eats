import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class WelcomeImage extends StatelessWidget {
  const WelcomeImage({super.key});

  @override
  Widget build(BuildContext context) {
    const size = 286.0;
    
    // ignore: lines_longer_than_80_chars
    return Assets.images.welcome.image(height: size, cacheHeight: size.toInt());
  }
}
