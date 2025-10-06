/*
  هذا الملف يجمع الثوابت العامة مثل قائمة الفئات والروابط الوهمية.
  يمكن تحديثه لإضافة ثوابت جديدة أو جلبها ديناميكياً لاحقاً.
*/
class AppConstants {
  static const List<String> categoryKeys = [
    'category.cars',
    'category.houses',
    'category.lands',
    'category.electronics',
    'category.antiques',
  ];

  static const List<String> categoryIds = [
    'cars',
    'houses',
    'lands',
    'electronics',
    'antiques',
  ];

  static const List<String> placeholderImages = [
    'https://picsum.photos/seed/car/600/400',
    'https://picsum.photos/seed/house/600/400',
    'https://picsum.photos/seed/land/600/400',
    'https://picsum.photos/seed/electronics/600/400',
    'https://picsum.photos/seed/antique/600/400',
  ];
}
