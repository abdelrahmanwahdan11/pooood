import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class NetworkImageSafe extends StatelessWidget {
  const NetworkImageSafe({
    super.key,
    required this.url,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.borderRadius = 20,
  });

  final String url;
  final double? height;
  final double? width;
  final BoxFit fit;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image.network(
        url,
        height: height,
        width: width,
        fit: fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: Colors.white.withOpacity(0.1),
            height: height,
            width: width,
            alignment: Alignment.center,
            child: const CupertinoActivityIndicator(),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: height,
            width: width,
            color: Colors.white.withOpacity(0.14),
            alignment: Alignment.center,
            child: Icon(
              Icons.wifi_off_rounded,
              color: AppTheme.onSurface.withOpacity(0.45),
            ),
          );
        },
      ),
    );
  }
}
