import 'package:flutter/material.dart';

class NetworkImageSafe extends StatelessWidget {
  const NetworkImageSafe({super.key, required this.url, this.fit = BoxFit.cover});

  final String url;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      fit: fit,
      errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.broken_image_outlined)),
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return const Center(child: CircularProgressIndicator(strokeWidth: 2));
      },
    );
  }
}
