import '../models/question.dart';
import '../models/trait.dart';

class QuizRepository {
  final List<Question> _questions = [
    Question(
      id: 'O1',
      trait: Trait.openness,
      text: {
        'en': 'I enjoy exploring imaginative ideas.',
        'ar': 'أستمتع باستكشاف الأفكار الخيالية.',
      },
    ),
    Question(
      id: 'O2',
      trait: Trait.openness,
      text: {
        'en': 'Art and beauty move me deeply.',
        'ar': 'الفن والجمال يؤثران فيّ بعمق.',
      },
    ),
    Question(
      id: 'O3',
      trait: Trait.openness,
      reverseScored: true,
      text: {
        'en': 'I prefer familiar routines over new experiences.',
        'ar': 'أفضل الروتين المألوف على التجارب الجديدة.',
      },
    ),
    Question(
      id: 'O4',
      trait: Trait.openness,
      text: {
        'en': 'I seek knowledge for the joy of learning.',
        'ar': 'أبحث عن المعرفة من أجل متعة التعلم.',
      },
    ),
    Question(
      id: 'O5',
      trait: Trait.openness,
      text: {
        'en': 'I adapt quickly to new perspectives.',
        'ar': 'أتأقلم سريعًا مع وجهات النظر الجديدة.',
      },
    ),
    Question(
      id: 'C1',
      trait: Trait.conscientiousness,
      text: {
        'en': 'I plan my tasks with care.',
        'ar': 'أخطط لمهامي بعناية.',
      },
    ),
    Question(
      id: 'C2',
      trait: Trait.conscientiousness,
      reverseScored: true,
      text: {
        'en': 'I struggle to keep things organised.',
        'ar': 'أجد صعوبة في الحفاظ على التنظيم.',
      },
    ),
    Question(
      id: 'C3',
      trait: Trait.conscientiousness,
      text: {
        'en': 'I follow through on my promises.',
        'ar': 'أفي بوعودي.',
      },
    ),
    Question(
      id: 'C4',
      trait: Trait.conscientiousness,
      text: {
        'en': 'I like to prepare things in advance.',
        'ar': 'أحب التحضير للأشياء مسبقًا.',
      },
    ),
    Question(
      id: 'C5',
      trait: Trait.conscientiousness,
      reverseScored: true,
      text: {
        'en': 'I leave tasks unfinished.',
        'ar': 'أترك المهام دون إكمال.',
      },
    ),
    Question(
      id: 'E1',
      trait: Trait.extraversion,
      text: {
        'en': 'I feel energised when around people.',
        'ar': 'أشعر بالطاقة عندما أكون بين الناس.',
      },
    ),
    Question(
      id: 'E2',
      trait: Trait.extraversion,
      reverseScored: true,
      text: {
        'en': 'I keep my thoughts to myself.',
        'ar': 'أحتفظ بأفكاري لنفسي.',
      },
    ),
    Question(
      id: 'E3',
      trait: Trait.extraversion,
      text: {
        'en': 'I start conversations with ease.',
        'ar': 'أبدأ المحادثات بسهولة.',
      },
    ),
    Question(
      id: 'E4',
      trait: Trait.extraversion,
      text: {
        'en': 'I enjoy being the centre of attention.',
        'ar': 'أستمتع بأن أكون محور الاهتمام.',
      },
    ),
    Question(
      id: 'E5',
      trait: Trait.extraversion,
      reverseScored: true,
      text: {
        'en': 'I feel drained after social events.',
        'ar': 'أشعر بالإرهاق بعد المناسبات الاجتماعية.',
      },
    ),
    Question(
      id: 'A1',
      trait: Trait.agreeableness,
      text: {
        'en': 'I empathise with others’ feelings.',
        'ar': 'أتعاطف مع مشاعر الآخرين.',
      },
    ),
    Question(
      id: 'A2',
      trait: Trait.agreeableness,
      text: {
        'en': 'I offer help before being asked.',
        'ar': 'أقدم المساعدة قبل أن يُطلب مني.',
      },
    ),
    Question(
      id: 'A3',
      trait: Trait.agreeableness,
      reverseScored: true,
      text: {
        'en': 'I find it hard to forgive mistakes.',
        'ar': 'أجد صعوبة في مسامحة الأخطاء.',
      },
    ),
    Question(
      id: 'A4',
      trait: Trait.agreeableness,
      text: {
        'en': 'I enjoy creating harmony in groups.',
        'ar': 'أستمتع بخلق الانسجام في المجموعات.',
      },
    ),
    Question(
      id: 'A5',
      trait: Trait.agreeableness,
      text: {
        'en': 'I trust that people mean well.',
        'ar': 'أثق بأن الناس يقصدون الخير.',
      },
    ),
    Question(
      id: 'N1',
      trait: Trait.neuroticism,
      text: {
        'en': 'I notice when my mood shifts.',
        'ar': 'ألاحظ عندما يتغير مزاجي.',
      },
    ),
    Question(
      id: 'N2',
      trait: Trait.neuroticism,
      reverseScored: true,
      text: {
        'en': 'I rarely worry about things.',
        'ar': 'نادراً ما أقلق بشأن الأمور.',
      },
    ),
    Question(
      id: 'N3',
      trait: Trait.neuroticism,
      text: {
        'en': 'My feelings can overwhelm me.',
        'ar': 'قد تغمرني مشاعري أحيانًا.',
      },
    ),
    Question(
      id: 'N4',
      trait: Trait.neuroticism,
      text: {
        'en': 'I reflect on what triggers my stress.',
        'ar': 'أتأمل فيما يثير توتري.',
      },
    ),
    Question(
      id: 'N5',
      trait: Trait.neuroticism,
      reverseScored: true,
      text: {
        'en': 'I stay calm in tense situations.',
        'ar': 'أبقى هادئًا في المواقف المتوترة.',
      },
    ),
  ];

  List<Question> getQuestions() => List.unmodifiable(_questions);
}
