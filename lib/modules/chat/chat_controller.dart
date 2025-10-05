import 'package:get/get.dart';

class ChatController extends GetxController {
  final messages = const [
    ChatMessage(authorKey: 'chat_host', textEn: 'Hey! Welcome to the Hyper Market lounge.', textAr: 'مرحباً! أهلاً بك في صالة هايبر ماركت.'),
    ChatMessage(authorKey: 'chat_you', textEn: 'The colors here are wild!', textAr: 'الألوان هنا رهيبة!'),
    ChatMessage(authorKey: 'chat_host', textEn: 'Absolutely. Tap any bubble to continue exploring.', textAr: 'بالتأكيد. اضغط على أي فقاعة لمواصلة الاستكشاف.'),
    ChatMessage(authorKey: 'chat_you', textEn: 'Can I pin this convo?', textAr: 'هل يمكنني تثبيت هذه المحادثة؟'),
    ChatMessage(authorKey: 'chat_host', textEn: 'Soon! Check the feature ideas for what is coming next.', textAr: 'قريباً! راجع قائمة الأفكار لمعرفة ما سيأتي.'),
  ].obs;
}

class ChatMessage {
  const ChatMessage({required this.authorKey, required this.textEn, required this.textAr});

  final String authorKey;
  final String textEn;
  final String textAr;

  String text(String locale) => locale == 'ar' ? textAr : textEn;
}
