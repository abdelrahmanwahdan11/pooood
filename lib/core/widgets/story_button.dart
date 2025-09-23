import 'package:flutter/material.dart';

import '../theme/colors.dart';

class StoryButton extends StatelessWidget {
  const StoryButton({
    super.key,
    required this.onPressed,
    this.size = 44,
    this.icon = Icons.play_arrow_rounded,
  });

  final VoidCallback onPressed;
  final double size;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: AppColors.neonAccent),
          shape: BoxShape.circle,
          boxShadow: const [
            BoxShadow(
              color: AppColors.glassShadow,
              blurRadius: 16,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(icon, color: Colors.white),
        ),
      ),
    );
  }
}
