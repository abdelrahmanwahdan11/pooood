import 'package:flutter/material.dart';

class AppAvatar extends StatelessWidget {
  const AppAvatar({super.key, required this.imageUrl, this.onTap, this.radius = 22});

  final String imageUrl;
  final double radius;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: radius,
        backgroundColor: Colors.white.withOpacity(0.4),
        backgroundImage: NetworkImage(imageUrl),
      ),
    );
  }
}
