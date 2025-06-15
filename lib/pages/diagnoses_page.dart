import 'package:final_thriving_together/pages/congition_exercises.dart';
import 'package:flutter/material.dart';
import 'package:final_thriving_together/diagnoses/asd_diagnoses.dart';
import 'package:final_thriving_together/diagnoses/language_diagnoses.dart';
import 'package:final_thriving_together/diagnoses/sound_diagnoses.dart';
import 'package:final_thriving_together/diagnoses/speech_diagnoses.dart';
import 'package:final_thriving_together/navigation_bar.dart';
import 'package:final_thriving_together/Theme_provider.dart';
import 'package:final_thriving_together/pages/loading_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

class Diagnosespage extends StatefulWidget {
final String? videoId;
const Diagnosespage({this.videoId, Key? key}) : super(key: key);

@override
State<Diagnosespage> createState() => _DiagnosesPageState();
}

class _DiagnosesPageState extends State<Diagnosespage> with SingleTickerProviderStateMixin {
late AnimationController _controller;
late Animation<double> _fadeAnimation;
late Animation<double> _scaleAnimation;
int currentIndex = 2;
String selectedFilter = '';

List<String> filters = [];
final ScrollController _scrollController = ScrollController();

// Exercise data structure
final List<Map<String, dynamic>> speechExercises = [
{
'title': 'تمارين لأعضاء النطق والكلام',
'note': 'ملحوظة: هذه التمارين مستمرة يوميًا تبدأ بالتدريج من خمس عدات لكل تدريب في اليوم إلى 20 عددًا بالتدريج مع تطور الحالة',
'subtitle': 'تمارين للفم والفكين',
'steps': [
ExerciseStep(text: 'فتح الفك لأعلى وأسفل - من خمس لعشر مرات مع الزيادة', imagePath: 'assets/images/فتح الفك.gif'),
ExerciseStep(text: 'تدليكات حول مفصل الفك الأعلى ثم النزول بأصابع اليد السبابة والوسطى لأسفل', imagePath: 'assets/images/تدليك مفصل الفك.webp'),
ExerciseStep(text: 'ضم الشفتين وفتحهما', imagePath: 'assets/images/ضم الشفتان.gif'),
ExerciseStep(text: 'تدليكات حول الشفاه بشكل دائري - تقسيم الشفاه العليا والسفلى لأربع نقاط مع تدليك كل نقطة بشكل دائري', imagePath: 'assets/images/تدليك الشفاه.png'),
ExerciseStep(text: 'الضغط على الشفاه بإصبع السبابة كل شفة في اتجاه مخالف', imagePath: ''),
],
'images': [
'assets/images/فتح الفك.gif',
'assets/images/تدليك مفصل الفك.webp',
'assets/images/ضم الشفتان.gif',
'assets/images/تدليك الشفاه.png',
],
},
{
'subtitle': 'تمارين اللسان',
'steps': [
ExerciseStep(text: 'التمرين على خروج اللسان خارج الفم وإدخاله بسرعة', imagePath: 'assets/images/اخراج اللسان.jpg'),
ExerciseStep(text: 'خروج اللسان في الاتجاهين اليمين والشمال خارج الفم', imagePath: 'assets/images/اللسان يمين وشمال.png'),
ExerciseStep(text: 'الضغط باللسان على أحد جانبي الخد ثم بإصبع المتابع للحالة بالضغط على اللسان من الخارج على أن يقوم الطفل بالضغط الخارجي', imagePath: ''),
ExerciseStep(text: 'لف اللسان داخل الفم بشكل دائري حول الشفاه من الداخل', imagePath: 'assets/images/لف اللسان حول الشفاه من الداخل.jpg'),
ExerciseStep(text: 'حركة اللسان لأعلى أسفل خارج الفم', imagePath: 'assets/images/اللسان لاعلي واسفل.png'),
ExerciseStep(text: 'حركة اللسان داخل الفم في وضع نطق حرف الراء', imagePath: 'assets/images/حرف الراء داخل الفم.webp'),
ExerciseStep(text: 'الطقطقة داخل الفم', imagePath: 'assets/images/الطقطقه.webp'),
ExerciseStep(text: 'حمل اللسان لقلم أو خافض خارج الفم مع ثبات اللسان', imagePath: 'assets/images/حمل اللسان لشيء خارج الفم.jpg'),
],
'images': [
'assets/images/اخراج اللسان.jpg',
'assets/images/اللسان يمين وشمال.png',
'assets/images/لف اللسان حول الشفاه من الداخل.jpg',
'assets/images/اللسان لاعلي واسفل.png',
'assets/images/حرف الراء داخل الفم.webp',
'assets/images/الطقطقه.webp',
'assets/images/حمل اللسان لشيء خارج الفم.jpg',
],
},
{
'title': 'تمارين تنفس',
'note': 'ملحوظة: تمرين النفس يكون بأخذ النفس من الأنف وإخراجه مع كل تمرين من التمارين التالية',
'steps': [
ExerciseStep(text: 'النفخ في لعبة الفقاعات', imagePath: 'assets/images/النفخ في الفقاعات.jpg'),
ExerciseStep(text: 'أخذ نفس والنفخ في شاليموه داخل كوب به ماء', imagePath: 'assets/images/النفخ في شاليموه.png'),
ExerciseStep(text: 'النفخ في قصاصات الورق', imagePath: 'assets/images/نفخ قصاصات ورق.png'),
ExerciseStep(text: 'النفخ في بالونة', imagePath: 'assets/images/النفخ في بالون.jpg'),
ExerciseStep(text: 'النفخ في أي كرة صغيرة وخفيفة مثل كرة تنس الطاولة', imagePath: 'assets/images/نفخ كره.jpg'),
],
'images': [
'assets/images/النفخ في الفقاعات.jpg',
'assets/images/النفخ في شاليموه.png',
'assets/images/نفخ قصاصات ورق.png',
'assets/images/النفخ في بالون.jpg',
'assets/images/نفخ كره.jpg',
],
},
{
'title': 'تمارين تنفس بطني',
'note': 'ملحوظة: هذه التدريبات خاصة بالتلعثم والبحة الصوتية',
'steps': [
ExerciseStep(text: 'أخذ نفس عميق من الأنف مع تثبيت الكتفين وملء البطن به، ثم إخراجه من الفم ببطء', imagePath: ''),
ExerciseStep(text: 'أخذ نفس سريع بنفس الطريقة السابقة، ثم إخراجه بسرعة', imagePath: ''),
ExerciseStep(text: 'أخذ نفس بنفس الطريقة الأولى ثم حبس النفس في داخل البطن مدة 3 ثواني، ثم إخراجه وتزيد بالتدريج', imagePath: ''),
ExerciseStep(text: 'أخذ نفس عميق بنفس الطريقة الأولى، مع إخراجه بالأصوات الاحتكاكية مثل السين، الزاي', imagePath: ''),
ExerciseStep(text: 'أخذ نفس مع إخراج كلمة مثل الأرقام يقول مثلا واحد، ثم يأخذ نفس ويقول اثنين', imagePath: ''),
ExerciseStep(text: 'أخذ نفس ويخرج النفس وهو ينطق كلمتين مثل واحد واثنين', imagePath: ''),
ExerciseStep(text: 'أخذ نفس عميق بنفس الطريقة الأولى ثم ينطق جملة من ثلاث كلمات', imagePath: ''),
],
'images': [],
},
];

final List<Map<String, dynamic>> languageExercises = [
{
'title': 'التدريبات الخاصة باللغة الاستقبالية',
'subtitle': 'تمارين ما قبل اللغة',
'steps': [
ExerciseStep(text: 'تقليد حركات كبرى: ارفع ايدك، تقليد حركة رفع اليد للأعلى أو الأسفل، التسفيق، التخبيط، القفز، ثني الجزع، رفع القدم لأعلى وللأسفل', imagePath: ''),
ExerciseStep(text: 'تقليد حركات صغرى: تقليد فتح العين وقفلها، فتح الفم وغلقه، حركة اللسان، الإشارة بالأصابع', imagePath: ''),
ExerciseStep(text: 'تنفيذ أمر واحد: مثل: ارفع ايدك، سقف، خبط، طلع لسانك، افتح فمك، افتح الباب', imagePath: ''),
ExerciseStep(text: 'تنفيذ أوامر مركبة: مثل: حط ايدك على شعرك، غمض عينك وافتح فمك، افتح فمك وسقف', imagePath: ''),
],
'images': [],
},
{
'title': 'التدريبات الخاصة باللغة التعبيرية',
'note': 'ملحوظة: يتم التعرف على 6 أشياء شائعة من كل مجموعة يتم التعرف على الأشياء والتدريب على نطقها',
'subtitle': 'التعرف على المجموعات الضمنية',
'steps': [
ExerciseStep(text: 'التعرف على الحيوانات', imagePath: ''),
ExerciseStep(text: 'التعرف على الطيور', imagePath: ''),
ExerciseStep(text: 'التعرف على الفواكه', imagePath: ''),
ExerciseStep(text: 'التعرف على الخضراوات', imagePath: ''),
ExerciseStep(text: 'التعرف على الملابس', imagePath: ''),
ExerciseStep(text: 'التعرف على أدوات الطعام', imagePath: ''),
ExerciseStep(text: 'التعرف على أثاث المنزل', imagePath: ''),
ExerciseStep(text: 'التعرف على الألوان', imagePath: ''),
],
'images': [],
},
{
'subtitle': 'التدريب على الأفعال',
'steps': [
ExerciseStep(text: 'كلمة بمعنى جملة: مثل: اشرب اكل اجري انام العب', imagePath: ''),
ExerciseStep(text: 'جملة من كلمتين: مثل: عاوز اكل، عاوز اشرب، بابا جه', imagePath: ''),
ExerciseStep(text: 'التدريب على جملة من 3 كلمات: مثل: التدريب على سرد قصة مثل ترتيب الأحداث تسلسل الأحداث أو التدريب على وصف صورة', imagePath: ''),
ExerciseStep(text: 'التدريب على نحو الكلام: مثل: إضافة الضمائر مثل أنا وهو', imagePath: ''),
],
'images': [],
},
];

final List<Map<String, dynamic>> voiceExercises = [
{
'title': 'تمارين اضطرابات الصوت',
'note': 'ملحوظة: يتم التركيز على تمارين التنفس والتحكم في الصوت',
'subtitle': 'تمارين الإحماء الصوتي',
'steps': [
ExerciseStep(text: 'تمارين التنفس الحجابي:\n-اجلس مع الطفل بشكل مريح.\n-ضع يدك على بطن الطفل.\n-اطلب منه أن يأخذ نفسًا عميقًا من الأنف بحيث يتحرك بطنه للأمام (يدك تتحرك مع البطن).\n-زفر الهواء من الفم ببطء، مع محاولة تقليل حركة الصدر.', imagePath: ''),
ExerciseStep(text: 'تمارين تمدد الأحبال الصوتية:\n-اطلب من الطفل إصدار صوت "آه" ببطء من أدنى درجة صوت ممكنة إلى أعلى درجة.\n-يمكن تكرار الصوت بشكل متدرج من المنخفض إلى العالي\n-تمرين التدرج الصوتي يساعد في تمدد الأحبال الصوتية.', imagePath: ''),
ExerciseStep(text: 'تمارين نطق الحروف الساكنة:\n-اطلب من الطفل نطق الحرف الساكن بوضوح، ثم تكرار الحرف مع كلمة بسيطة تبدأ به (مثلاً: ب - بيت).\n-يمكن استخدام مرآة لمراقبة حركة الشفاه واللسان.\n-التمرين يُكرر عدة مرات لكل حرف.', imagePath: ''),
],
'images': [],
},
{
'subtitle': 'تمارين أخرى للصوت',
'steps': [
ExerciseStep(text: 'تمرين التنفس العميق: خلي الطفل ياخد نفس عميق من الأنف ويزفر من الفم ببطء', imagePath: ''),
ExerciseStep(text: 'تمرين الهمهمة: اطلب من الطفل يعمل صوت همهمة منخفضة (مثل صوت النحل).', imagePath: ''),
ExerciseStep(text: 'تمرين إصدار الأصوات المتنوعة: طلب من الطفل ينطق أصوات مختلفة مثل "م"، "ن"، "ر"، "س"، "ش" بوضوح.', imagePath: ''),
ExerciseStep(text: 'تمرين تقليد الأصوات: اسمعوا أصوات حيوانات (مثل مواء القطة، نباح الكلب)، وحاولوا تقليدها معًا.', imagePath: ''),
ExerciseStep(text: 'تمرين قراءة الجمل البسيطة بصوت مرتفع: اقرأوا جمل قصيرة مع الطفل بصوت واضح ومسموع.', imagePath: ''),
ExerciseStep(text: 'تمرين الغناء: شجع الطفل على الغناء بأغاني بسيطة ومحفزة.', imagePath: ''),
ExerciseStep(text: 'تمرين "البالون الصوتي": الطفل ينفخ في بالون مع محاولة إصدار صوت مستمر.', imagePath: ''),
],
'images': [],
},
];

  final List<Map<String, dynamic>> autismExercises = [
    {
      'title': 'تمارين اضطراب طيف التوحد',
      'note': 'يتم الاستعانة بتدريبات النطق والكلام',
      'subtitle': 'التوحد غير الناطق',
      'steps': <ExerciseStep>[
        ExerciseStep(text: 'يتم التعامل معه باستخدام برنامج بيكس (PECS)، وهو برنامج التعرف على التواصل من خلال الصور.', imagePath: ''),
      ],
      'images': <String>[],
    },
    {
      'subtitle': 'التوحد الناطق',
      'steps': <ExerciseStep>[
        ExerciseStep(text: 'التدريب على التواصل البصري:\n-شجع الطفل على النظر في عيني الأخصائي أو ولي الأمر لمدة 5 ثواني.\n-استخدم لعب أو أشياء مفضلة لجذب انتباه الطفل للنظر.', imagePath: ''),
        ExerciseStep(text: 'التدريب على كلمة "انظر لي" أو "انظر إلي":\n-قل للطفل "انظر لي" أو "انظر إلي" بشكل لطيف ومرن.\n-امدحه واثنِ عليه عند تحقيقه ذلك.', imagePath: ''),
        ExerciseStep(text: 'التدريب على التواصل البصري مع الأشخاص:\n-اطلب من الطفل مراقبة وجوه الأشخاص أثناء التحدث.\n-ساعده على فهم تعبيرات الوجه والإيماءات.', imagePath: ''),
      ],
      'images': <String>[],
    },
    {
      'subtitle': 'تمارين تكميلية لتطوير مهارات التوحد',
      'steps': <ExerciseStep>[
        ExerciseStep(text: 'التمرين على الإيماءات:\n-شجع الطفل على استخدام الإيماءات مثل الإشارة، التلويح، أو الهز بالرأس.\n-استخدم الإيماءات بنفسك أثناء التحدث لتعليم الطفل.', imagePath: ''),
        ExerciseStep(text: 'تمارين التواصل اللفظي:\n-استخدم جمل بسيطة وواضحة.\n-شجع الطفل على تكرار الكلمات البسيطة.', imagePath: ''),
        ExerciseStep(text: 'تمارين اللعب التعاوني:\n-شجع الطفل على اللعب مع الآخرين أو مع ولي الأمر بلعب بسيطة.\n-ألعاب مثل تبادل الكرة، أو البناء مع مكعبات تساعد على التفاعل.', imagePath: ''),
        ExerciseStep(text: 'تمارين تنظيم الحواس:\n-استخدام أنشطة تساعد الطفل على تنظيم حواسه مثل اللعب بالرمل، العجين، أو الألعاب التي تحتوي على أصوات.', imagePath: ''),
      ],
      'images': <String>[],
    },
    {
      'note': 'تمارين التوحد بشكل عام تحتاج إلى إشراف وتقييم مستمر من قبل أخصائيين متخصصين في علاج اضطرابات طيف التوحد، لأن التوحد له أنواع ومستويات مختلفة لكل حالة خصوصياتها. المحتوى السابق هو جزء مساعد فقط يهدف لدعم الأهالي في التعامل اليومي مع أطفالهم، ولا يغني عن التشخيص والعلاج المهني المتخصص.',
      'steps': <ExerciseStep>[],
      'images': <String>[],
    },
  ];

/*final List<Map<String, dynamic>> cognitionExercises = [
{
'title': 'تمارين الإدراك',
'note': 'ملحوظة: هذه التمارين تعزز المهارات الإدراكية مثل التعرف على الحروف، الأشكال، والتسلسل من خلال أنشطة تفاعلية. اضغط "اقرأ المزيد" لتجربة التمارين التفاعلية.',
'steps': [
ExerciseStep(text: 'استمع للصوت وحدد الحرف', imagePath: ''),
ExerciseStep(text: 'اختر الحرف المناسب للصورة', imagePath: 'assets/images/apple.png'),
ExerciseStep(text: 'كوّن كلمة من الحروف التالية', imagePath: ''),
ExerciseStep(text: 'استمع للكلمة وحدد الصوت الذي تسمعه في البداية', imagePath: ''),
ExerciseStep(text: 'اختر الشكل الصحيح', imagePath: 'assets/images/circle.jpeg'),
ExerciseStep(text: 'اختر الكلمة التي تختلف عن البقية', imagePath: ''),
ExerciseStep(text: 'رتب الصور حسب التسلسل الصحيح', imagePath: 'assets/images/step1.jpg'),
ExerciseStep(text: 'أكمل الجملة بالكلمة المناسبة', imagePath: 'assets/images/car.jpg'),
ExerciseStep(text: 'اختر الحرف الذي يشبه الحرف المعروض', imagePath: ''),
ExerciseStep(text: 'اقرأ الكلمة واختر الصورة المناسبة', imagePath: 'assets/images/house.jpg'),
ExerciseStep(text: 'اختر الجملة التي تصف الصورة بشكل صحيح', imagePath: 'assets/images/playing.jpg'),
ExerciseStep(text: 'كوّن جملة صحيحة من الكلمات التالية', imagePath: ''),
ExerciseStep(text: 'كم عدد الحروف في كلمة "كتاب"؟', imagePath: 'assets/images/book.png'),
ExerciseStep(text: 'ما هو الحرف الذي يبدأ به اسم هذه الصورة؟', imagePath: 'assets/images/sunn.jpg'),
ExerciseStep(text: 'استمع للحرف واختر الحرف الصحيح', imagePath: ''),
ExerciseStep(text: 'اختر لون التفاحة', imagePath: 'assets/images/apple.png'),
ExerciseStep(text: 'كم عدد التفاحات في الصورة؟', imagePath: 'assets/images/five_apples.jpg'),
ExerciseStep(text: 'هل هذه صورة لشجرة؟', imagePath: 'assets/images/tree.jpg'),
ExerciseStep(text: 'ضع إشارة صح أو خطأ', imagePath: ''),
ExerciseStep(text: 'أنشطة تعليمية باستخدام موقع Word Wall', imagePath: ''),
],
'images': [
'assets/images/apple.png',
'assets/images/circle.jpeg',
'assets/images/step1.jpg',
'assets/images/step2.jpg',
'assets/images/step3.jpg',
'assets/images/car.jpg',
'assets/images/house.jpg',
'assets/images/book.png',
'assets/images/tree.jpg',
'assets/images/playing.jpg',
'assets/images/sunn.jpg',
],
},
];*/

@override
void initState() {
super.initState();
_controller = AnimationController(
duration: const Duration(milliseconds: 800),
vsync: this,
);

_fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
CurvedAnimation(parent: _controller, curve: Curves.easeIn),
);

_scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
CurvedAnimation(parent: _controller, curve: Curves.easeOut),
);

_controller.forward();
}

@override
void dispose() {
_controller.dispose();
_scrollController.dispose();
super.dispose();
}

Future<void> _navigateWithLoading(BuildContext context, Widget targetPage) async {
Navigator.push(
context,
PageRouteBuilder(
pageBuilder: (_, __, ___) => LoadingScreen(),
transitionsBuilder: (_, animation, __, child) {
return FadeTransition(opacity: animation, child: child);
},
),
);

await Future.delayed(const Duration(seconds: 2));

Navigator.pushReplacement(
context,
PageRouteBuilder(
pageBuilder: (_, __, ___) => targetPage,
transitionsBuilder: (_, animation, __, child) {
return SlideTransition(
position: Tween<Offset>(
begin: const Offset(1, 0),
end: Offset.zero,
).animate(animation),
child: child,
);
},
),
);
}

void _scrollToExercises() {
_scrollController.animateTo(
_scrollController.position.maxScrollExtent,
duration: const Duration(milliseconds: 800),
curve: Curves.easeInOut,
);
}

@override
Widget build(BuildContext context) {
final themeProvider = Provider.of<ThemeProvider>(context);
final isDarkMode = themeProvider.isDarkMode;
final textColor = isDarkMode ? Colors.white : Colors.blue[900]!;
final accentColor = isDarkMode ? Colors.blue[200]! : Colors.blue[700]!;
final backgroundColor = isDarkMode ? Colors.grey[900]! : Colors.white;
final l10n = AppLocalizations.of(context)!;

// Initialize filters
filters = [
l10n.filterSpeech,
l10n.filterLanguage,
l10n.filterVoice,
l10n.filterAutism,
//l10n.filterCognition,
];
if (selectedFilter.isEmpty || !filters.contains(selectedFilter)) {
selectedFilter = l10n.filterSpeech;
}

return Scaffold(
appBar: AppBar(
leading: IconButton(
icon: AnimatedIcon(
icon: AnimatedIcons.menu_arrow,
progress: _controller,
color: Colors.white,
),
onPressed: () => Navigator.pop(context),
),
title: AnimatedSwitcher(
duration: const Duration(milliseconds: 300),
child: Text(
l10n.diagnosesPageTitle,
key: ValueKey<String>(l10n.diagnosesPageTitle),
style: const TextStyle(
fontSize: 24,
fontWeight: FontWeight.bold,
color: Colors.white,
),
),
),
backgroundColor: isDarkMode ? Colors.black : const Color(0xFF4070F4),
elevation: 0,
),
body: Directionality(
textDirection: TextDirection.rtl,
child: Stack(
children: [
// Animated Background
Positioned.fill(
child: AnimatedContainer(
duration: const Duration(milliseconds: 500),
decoration: BoxDecoration(
gradient: LinearGradient(
begin: Alignment.topLeft,
end: Alignment.bottomRight,
colors: [
isDarkMode ? Colors.grey[900]! : Colors.blue[50]!,
isDarkMode ? Colors.black : Colors.white,
],
),
),
),
),

// Main Content
AnimationLimiter(
child: SingleChildScrollView(
controller: _scrollController,
child: Column(
children: AnimationConfiguration.toStaggeredList(
duration: const Duration(milliseconds: 500),
childAnimationBuilder: (widget) => SlideAnimation(
horizontalOffset: 50.0,
child: FadeInAnimation(child: widget),
),
children: [
const SizedBox(height: 20),

// Diagnosis Cards
_buildDiagnosisCard(
context,
imagePath: "assets/images/speech.jpeg",
title: l10n.speechDisorders,
description: l10n.speechDisordersDesc,
color: const Color(0xFFf44036),
route: const SpeechDiagnoses(),
),

_buildDiagnosisCard(
context,
imagePath: "assets/images/languages.jpeg",
title: l10n.languageDisorders,
description: l10n.languageDisordersDesc,
color: const Color(0xFF009688),
route: const LanguageDiagnoses(),
),

_buildDiagnosisCard(
context,
imagePath: "assets/images/voice.jpeg",
title: l10n.voiceDisorders,
description: l10n.voiceDisordersDesc,
color: const Color(0xFF03a9f4),
route: const SoundDiagnoses(),
),

_buildDiagnosisCard(
context,
imagePath: "assets/images/autism1.png",
title: l10n.autismSpectrum,
description: l10n.autismSpectrumDesc,
color: const Color(0xFF4CAF50),
route: const AsdDiagnoses(),
),
_buildDiagnosisCard(
context,
imagePath: "assets/images/cognition.jpg",
title: l10n.cognitionActivities,
description: l10n.cognitionActivitiesDesc,
color: const Color(0xFF9C27B0),
route: const CognitionExercises(),
),

const SizedBox(height: 30),

// Scroll Down Arrow
GestureDetector(
onTap: _scrollToExercises,
child: Padding(
padding: const EdgeInsets.symmetric(vertical: 20),
child: Column(
children: [
Icon(
Icons.arrow_downward,
color: isDarkMode ? Colors.grey[300] : const Color(0xFF02A4B2),
size: 32,
),
Text(
l10n.scrollToExercises,
style: TextStyle(
fontWeight: FontWeight.bold,
color: isDarkMode ? Colors.grey[300] : Colors.black,
),
),
],
),
),
),

// Therapy Filter Section
Container(
color: isDarkMode ? Colors.grey[850] : const Color(0xFFF9F9F9),
padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
child: Column(
children: [
Text(
l10n.selectDiagnosisType,
style: TextStyle(
fontSize: 24,
fontWeight: FontWeight.bold,
color: isDarkMode ? Colors.white : const Color(0xFF2C5DAB),
),
),
const SizedBox(height: 10),
Text(
l10n.diagnosisHelp,
style: TextStyle(
fontSize: 16,
color: isDarkMode ? Colors.grey[300] : Colors.grey[600],
),
textAlign: TextAlign.center,
),
const SizedBox(height: 20),

// Filter Chips
Wrap(
spacing: 15,
runSpacing: 15,
alignment: WrapAlignment.center,
children: filters.map((filter) {
return FilterChip(
label: Text(filter),
selected: selectedFilter == filter,
onSelected: (selected) {
setState(() {
selectedFilter = filter;
});
},
selectedColor: const Color(0xFF4A90E2),
checkmarkColor: Colors.white,
labelStyle: TextStyle(
color: selectedFilter == filter
? Colors.white
    : isDarkMode
? Colors.grey[300]
    : Colors.black,
),
backgroundColor: isDarkMode ? Colors.grey[700] : const Color(0xFFEEEEEE),
);
}).toList(),
),

const SizedBox(height: 20),
LinearProgressIndicator(
value: 0.0,
backgroundColor: isDarkMode ? Colors.grey[700] : const Color(0xFFDDDDDD),
color: const Color(0xFF4A90E2),
),
],
),
),

// Exercise Section
Container(
padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
l10n.effectiveExercises(selectedFilter),
style: TextStyle(
fontSize: 24,
fontWeight: FontWeight.bold,
color: isDarkMode ? Colors.white : const Color(0xFF2C5DAB),
),
),
const SizedBox(height: 20),

// Display exercises based on selected filter
..._getExercisesForFilter(selectedFilter).map((exercise) =>
ExerciseCard(
title: exercise['title'] ?? '',
subtitle: exercise['subtitle'] ?? '',
note: exercise['note'] ?? '',
steps: exercise['steps'] as List<ExerciseStep>,
images: (exercise['images'] as List<dynamic>?)?.cast<String>() ?? [],
themeProvider: themeProvider,
)
),
],
),
),

const SizedBox(height: 40),
],
),
),
),
),
],
),
),
bottomNavigationBar: Navigationbar(currentIndex: currentIndex),
);
}

List<Map<String, dynamic>> _getExercisesForFilter(String filter) {
final l10n = AppLocalizations.of(context)!;

// Compare against all possible localized versions of each filter
if (filter == l10n.filterSpeech || filter == 'Speech') {
return speechExercises;
} else if (filter == l10n.filterLanguage || filter == 'Language') {
return languageExercises;
} else if (filter == l10n.filterVoice || filter == 'Voice') {
return voiceExercises;
} else if (filter == l10n.filterAutism || filter == 'Autism') {
return autismExercises;
} /*else if (filter == l10n.filterCognition || filter == 'Cognition Activities') {
return cognitionExercises;
}*/

return speechExercises;
}

Widget _buildDiagnosisCard(
BuildContext context, {
required String imagePath,
required String title,
required String description,
required Color color,
required Widget route,
}) {
final themeProvider = Provider.of<ThemeProvider>(context);
final isDarkMode = themeProvider.isDarkMode;
final l10n = AppLocalizations.of(context)!;

return MouseRegion(
onEnter: (_) => _controller.forward(),
onExit: (_) => _controller.reverse(),
child: AnimatedBuilder(
animation: _controller,
builder: (context, child) {
return Transform.scale(
scale: _scaleAnimation.value,
child: Opacity(
opacity: _fadeAnimation.value,
child: Container(
width: 350,
margin: const EdgeInsets.symmetric(horizontal: 16),
decoration: BoxDecoration(
color: isDarkMode
? Colors.grey[800]!.withOpacity(0.8)
    : Colors.white.withOpacity(0.9),
borderRadius: BorderRadius.circular(4),
boxShadow: [
BoxShadow(
color: isDarkMode
? Colors.blue[900]!.withOpacity(0.3)
    : Colors.blue[100]!,
blurRadius: 6,
spreadRadius: 2,
offset: const Offset(0, 5),
),
],
),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
ClipRRect(
borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
child: Image.asset(
imagePath,
height: 180,
width: double.infinity,
fit: BoxFit.cover,
),
),
Padding(
padding: const EdgeInsets.all(4),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
title,
style: TextStyle(
fontSize: 22,
fontWeight: FontWeight.bold,
color: color,
),
),
const SizedBox(height: 8),
Text(
description,
style: TextStyle(
fontSize: 16,
color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
height: 1.5,
),
),
const SizedBox(height: 16),
Align(
alignment: Alignment.centerRight,
child: ElevatedButton(
onPressed: () => _navigateWithLoading(context, route),
style: ElevatedButton.styleFrom(
backgroundColor: color,
foregroundColor: Colors.white,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(30),
),
padding: const EdgeInsets.symmetric(
horizontal: 24,
vertical: 12,
),
elevation: 5,
),
child: Text(
l10n.readMore,
style: const TextStyle(
fontSize: 16,
fontWeight: FontWeight.w600,
),
),
),
),
],
),
),
],
),
),
),
);
},
),
);
}
}

class ExerciseCard extends StatelessWidget {
final String title;
final String subtitle;
final String note;
final List<ExerciseStep> steps;
final ThemeProvider themeProvider;
final List<String> images;

const ExerciseCard({
super.key,
required this.title,
this.subtitle = '',
this.note = '',
required this.steps,
required this.themeProvider,
required this.images,
});

@override
Widget build(BuildContext context) {
final isDarkMode = themeProvider.isDarkMode;
final isRTL = Directionality.of(context) == TextDirection.rtl;

return AnimationConfiguration.staggeredList(
position: 0,
duration: const Duration(milliseconds: 500),
child: SlideAnimation(
verticalOffset: 50.0,
child: FadeInAnimation(
child: Container(
margin: const EdgeInsets.only(bottom: 30),
padding: const EdgeInsets.all(30),
decoration: BoxDecoration(
gradient: LinearGradient(
colors: [
isDarkMode ? Colors.grey[800]! : Colors.white,
isDarkMode ? Colors.grey[900]! : const Color(0xFFF8FBFF),
],
begin: Alignment.topLeft,
end: Alignment.bottomRight,
),
border: Border.all(color: const Color(0xFF2C5DAB)),
borderRadius: BorderRadius.circular(16),
boxShadow: const [
BoxShadow(
color: Color(0x143984C6),
blurRadius: 18,
offset: Offset(0, 6),
),
],
),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
if (title.isNotEmpty)
Text(
title,
style: TextStyle(
fontSize: 22,
fontWeight: FontWeight.bold,
color: isDarkMode ? Colors.grey[300] : const Color(0xFFF56806),
),
),

if (note.isNotEmpty)
Padding(
padding: const EdgeInsets.only(top: 8, bottom: 12),
child: Text(
note,
style: TextStyle(
fontSize: 16,
color: isDarkMode ? Colors.blue[200] : const Color(0xFF2C5DAB),
fontStyle: FontStyle.italic,
),
),
),

if (subtitle.isNotEmpty)
Padding(
padding: const EdgeInsets.only(top: 8, bottom: 4),
child: Text(
subtitle,
style: TextStyle(
fontSize: 20,
fontWeight: FontWeight.bold,
color: isDarkMode ? Colors.grey[300] : const Color(0xFF2C5DAB),
),
),
),

Container(
margin: const EdgeInsets.symmetric(vertical: 15),
height: 2,
decoration: const BoxDecoration(
color: Color(0x12777777),
border: Border(right: BorderSide(color: Color(0xFF3498DB), width: 3)),
),
),

// Exercise Steps with Images
...steps.map((step) => Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
// Step Text
Padding(
padding: EdgeInsets.only(
right: isRTL ? 25 : 0,
left: isRTL ? 0 : 25,
bottom: step.imagePath.isNotEmpty ? 12 : 0,
),
child: Row(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
'•',
style: TextStyle(
color: isDarkMode ? Colors.grey[300] : const Color(0xFFF56806),
fontWeight: FontWeight.bold,
),
),
const SizedBox(width: 10),
Expanded(
child: Text(
step.text,
style: TextStyle(
fontSize: 19,
color: isDarkMode ? Colors.grey[300] : const Color(0xFF2A3F54),
height: 1.7,
),
),
),
],
),
),

// Step Image (if exists)
if (step.imagePath.isNotEmpty)
Padding(
padding: const EdgeInsets.only(bottom: 20),
child: Center(
child: ClipRRect(
borderRadius: BorderRadius.circular(12),
child: Image.asset(
step.imagePath,
width: 200,
height: 200,
fit: BoxFit.cover,
errorBuilder: (context, error, stackTrace) {
return Container(
width: 200,
height: 200,
color: Colors.grey[200],
child: const Icon(Icons.image_not_supported),
);
},
),
),
),
),
],
)),
],
),
),
),
),
);
}
}

// New class to represent an exercise step with optional image
class ExerciseStep {
final String text;
final String imagePath;

ExerciseStep({
required this.text,
this.imagePath = '',
});
}