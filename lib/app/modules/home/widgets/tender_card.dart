/*
  هذا الملف يقدم بطاقة المزاد التفاعلية مع دعم السحب والحبكة البصرية والحركات.
  يمكن توسعته لإضافة مزايا مثل تقييم البائع أو مؤشرات ثقة إضافية.
*/
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../../core/utils/helpers.dart';
import '../../../data/models/item_model.dart';

class TenderCard extends StatelessWidget {
  final ItemModel item;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavorite;
  final VoidCallback onBid;
  final VoidCallback onRemove;
  final String countdown;

  const TenderCard({
    super.key,
    required this.item,
    required this.isFavorite,
    required this.onTap,
    required this.onFavorite,
    required this.onBid,
    required this.onRemove,
    required this.countdown,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.horizontal,
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          onFavorite();
          return false;
        } else {
          onRemove();
          return true;
        }
      },
      background: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(colors: [theme.colorScheme.primary, theme.colorScheme.secondary]),
        ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Icon(Icons.favorite, color: theme.colorScheme.onPrimary, size: 36),
      ),
      secondaryBackground: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: theme.colorScheme.error,
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Icon(Icons.delete, color: theme.colorScheme.onError, size: 36),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Hero(
          tag: 'item_${item.id}',
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: theme.cardColor.withOpacity(0.9),
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor.withOpacity(0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.network(
                      item.images.isNotEmpty ? item.images.first : 'https://picsum.photos/seed/${item.id}/600/400',
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return Container(
                          color: theme.colorScheme.surfaceVariant,
                          child: const Center(child: CircularProgressIndicator()),
                        );
                      },
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.black.withOpacity(0.1), Colors.black.withOpacity(0.7)],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: GestureDetector(
                      onTap: onFavorite,
                      child: AnimatedScale(
                        scale: isFavorite ? 1.2 : 1,
                        duration: 200.ms,
                        child: CircleAvatar(
                          backgroundColor: Colors.white.withOpacity(0.8),
                          child: Icon(isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: isFavorite ? theme.colorScheme.error : theme.colorScheme.primary),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Get.locale?.languageCode == 'ar' ? item.titleAr : item.titleEn,
                          style: theme.textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text('${'home.currentPrice'.tr}: ${Helpers.formatCurrency(item.currentPrice)}',
                            style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white70)),
                        if (item.isAuction) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.timer, color: Colors.white, size: 16),
                              const SizedBox(width: 4),
                              Text(countdown, style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white)),
                            ],
                          ),
                        ],
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: onBid,
                            child: Text(item.isAuction ? 'home.bidNow'.tr : 'home.startPrice'.tr),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.2, end: 0, duration: 500.ms),
      ),
    );
  }
}
