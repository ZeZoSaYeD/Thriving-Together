import 'dart:async';
import 'package:final_thriving_together/pages/Settings.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:final_thriving_together/Theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class IntelligenceTestApp extends StatelessWidget {
  const IntelligenceTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: "Children's Intelligence Test",
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: const [
        Locale('en'), // English
        Locale('ar'), // Arabic
      ],
      locale: themeProvider.currentLocale,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Arial',
        textTheme: TextTheme(
          headlineMedium: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.blue[800],
          ),
          bodyLarge: TextStyle(
            fontSize: 18,
            height: 1.5,
          ),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        textTheme: TextTheme(
          headlineMedium: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
          bodyLarge: TextStyle(
            fontSize: 18,
            height: 1.5,
            color: Colors.grey[300],
          ),
        ),
      ),
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const StartScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final loc = AppLocalizations.of(context)!;
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.intelligenceTestTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: AnimationLimiter(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 500),
              childAnimationBuilder: (widget) => FadeInAnimation(
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: widget,
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    loc.intelligenceTestDescription,
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 30),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDarkMode
                          ? [Colors.blue[800]!, Colors.blue[600]!]
                          : [Colors.blue[500]!, Colors.blue[300]!],
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const QuizScreen(),
                        ),
                      );
                    },
                    child: Text(
                      loc.startTest,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with SingleTickerProviderStateMixin {
  late List<Question> selectedQuestions;
  int currentQuestionIndex = 0;
  int score = 0;
  late int timeLeft;
  late Timer timer;
  String? selectedAnswer;
  bool _questionsInitialized = false;
  final AudioPlayer audioPlayer = AudioPlayer();
  bool showResult = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  List<Question> _getQuestions(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return [
      Question(
        question: loc.q1_iq,
        options: [loc.o1_iq1, loc.o2_iq1, loc.o3_iq1],
        answer: loc.o1_iq1,
        image: 'assets/images/numbers.png',
      ),
      Question(
        question: loc.q2_iq,
        options: [loc.o1_iq2, loc.o2_iq2, loc.o3_iq2],
        answer: loc.o3_iq2,
        image: 'assets/images/square.png',
      ),
      Question(
        question: loc.q3_iq,
        options: [loc.o1_iq3, loc.o2_iq3, loc.o3_iq3],
        answer: loc.o2_iq3,
        image: 'assets/images/cat.jpg',
      ),
      Question(
        question: loc.q4_iq,
        options: [loc.o1_iq4, loc.o2_iq4, loc.o3_iq4],
        answer: loc.o2_iq4,
        image: 'assets/images/spider.png',
      ),
      Question(
        question: loc.q5_iq,
        options: [loc.o1_iq5, loc.o2_iq5, loc.o3_iq5],
        answer: loc.o2_iq5,
        image: 'assets/images/cloud.jpg',
      ),
      Question(
        question: loc.q6_iq,
        options: [loc.o1_iq6, loc.o2_iq6, loc.o3_iq6],
        answer: loc.o1_iq6,
      ),
      Question(
        question: loc.q7_iq,
        options: [loc.o1_iq7, loc.o2_iq7, loc.o3_iq7],
        answer: loc.o2_iq7,
      ),
      Question(
        question: loc.q8_iq,
        options: [loc.o1_iq8, loc.o2_iq8, loc.o3_iq8],
        answer: loc.o2_iq8,
      ),
      Question(
        question: loc.q9_iq,
        options: [loc.o1_iq9, loc.o2_iq9, loc.o3_iq9],
        answer: loc.o2_iq9,
      ),
      Question(
        question: loc.q10_iq,
        options: [loc.o1_iq10, loc.o2_iq10, loc.o3_iq10],
        answer: loc.o3_iq10,
      ),
      Question(
        question: loc.q11_iq,
        options: [loc.o1_iq11, loc.o2_iq11, loc.o3_iq11],
        answer: loc.o2_iq11,
      ),
      Question(
        question: loc.q12_iq,
        options: [loc.o1_iq12, loc.o2_iq12, loc.o3_iq12],
        answer: loc.o2_iq12,
      ),
      Question(
        question: loc.q13_iq,
        options: [loc.o1_iq13, loc.o2_iq13, loc.o3_iq13],
        answer: loc.o2_iq13,
      ),
      Question(
        question: loc.q14_iq,
        options: [loc.o1_iq14, loc.o2_iq14, loc.o3_iq14],
        answer: loc.o2_iq14,
      ),
      Question(
        question: loc.q15_iq,
        options: [loc.o1_iq15, loc.o2_iq15, loc.o3_iq15],
        answer: loc.o2_iq15,
      ),
      Question(
        question: loc.q16_iq,
        options: [loc.o1_iq16, loc.o2_iq16, loc.o3_iq16],
        answer: loc.o3_iq16,
        image: 'assets/images/square.png',
      ),
      Question(
        question: loc.q17_iq,
        options: [loc.o1_iq17, loc.o2_iq17, loc.o3_iq17],
        answer: loc.o2_iq17,
      ),
      Question(
        question: loc.q18_iq,
        options: [loc.o1_iq18, loc.o2_iq18, loc.o3_iq18],
        answer: loc.o1_iq18,
      ),
      Question(
        question: loc.q19_iq,
        options: [loc.o1_iq19, loc.o2_iq19, loc.o3_iq19],
        answer: loc.o2_iq19,
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    timeLeft = 30;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );
    _animationController.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_questionsInitialized) {
      final questions = _getQuestions(context);
      selectedQuestions = List.from(questions)..shuffle();
      selectedQuestions = selectedQuestions.take(10).toList();
      _questionsInitialized = true;
      startTimer();
    }
  }

  @override
  void dispose() {
    timer.cancel();
    audioPlayer.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          timeLeft--;
        });
      }
      if (timeLeft <= 0) {
        timer.cancel();
        nextQuestion();
      }
    });
  }

  void nextQuestion() {
    timer.cancel();
    _animationController.reset();

    // Check if answer is correct
    if (selectedAnswer == selectedQuestions[currentQuestionIndex].answer) {
      score++;
      audioPlayer.play(AssetSource('sounds/correct.mp3'));
    } else {
      audioPlayer.play(AssetSource('sounds/wrong.mp3'));
    }

    if (currentQuestionIndex < selectedQuestions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        timeLeft = 30;
        selectedAnswer = null;
        _animationController.forward();
        startTimer();
      });
    } else {
      setState(() {
        showResult = true;
      });
    }
  }

  void selectAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
    });
    nextQuestion();
  }

  void restartTest() {
    setState(() {
      final questions = _getQuestions(context);
      selectedQuestions = List.from(questions)..shuffle();
      selectedQuestions = selectedQuestions.take(10).toList();
      currentQuestionIndex = 0;
      score = 0;
      timeLeft = 30;
      selectedAnswer = null;
      showResult = false;
      timer.cancel();
      _animationController.forward();
      startTimer();
    });
  }

  void goBack() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final loc = AppLocalizations.of(context)!;
    final isDarkMode = themeProvider.isDarkMode;

    if (showResult) {
      final percentage = (score / selectedQuestions.length) * 100;
      return Scaffold(
        appBar: AppBar(
          title: Text(loc.intelligenceTestTitle),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: goBack,
          ),
        ),
        body: AnimationLimiter(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: AnimationConfiguration.toStaggeredList(
                duration: const Duration(milliseconds: 500),
                childAnimationBuilder: (widget) => FadeInAnimation(
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: widget,
                  ),
                ),
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.blueGrey[800] : Colors.blue[50],
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          loc.yourScore,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 300),
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: percentage >= 70
                                ? Colors.green
                                : percentage >= 40
                                ? Colors.orange
                                : Colors.red,
                          ),
                          child: Text(
                            '${percentage.toStringAsFixed(1)}%',
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '${loc.youGot} $score ${loc.outOf} ${selectedQuestions.length} ${loc.questionsCorrect}',
                          style: const TextStyle(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDarkMode
                            ? [Colors.blue[800]!, Colors.blue[600]!]
                            : [Colors.blue[500]!, Colors.blue[300]!],
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: restartTest,
                      child: Text(
                        loc.restartTest,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: goBack,
                    child: Text(
                      loc.back,
                      style: TextStyle(
                        fontSize: 16,
                        color: isDarkMode ? Colors.blue[200] : Colors.blue[700],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    if (selectedQuestions.isEmpty) {
      return Scaffold(
        body: Center(child: Text(loc.loadingQuestions)),
      );
    }

    final question = selectedQuestions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.intelligenceTestTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: goBack,
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Timer with progress indicator
              Column(
                children: [
                  LinearProgressIndicator(
                    value: timeLeft / 30,
                    backgroundColor: Colors.grey[300],
                    color: timeLeft > 15
                        ? Colors.green
                        : timeLeft > 5
                        ? Colors.orange
                        : Colors.red,
                    minHeight: 8,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${loc.timeLeft}: $timeLeft ${loc.seconds}',
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontSize: 16,
                      color: timeLeft > 15
                          ? Colors.green
                          : timeLeft > 5
                          ? Colors.orange
                          : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Question
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.blueGrey[800] : Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  question.question,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              // Image if available
              if (question.image != null)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        question.image!,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              // Options
              Expanded(
                child: AnimationLimiter(
                  child: ListView(
                    children: AnimationConfiguration.toStaggeredList(
                      duration: const Duration(milliseconds: 500),
                      childAnimationBuilder: (widget) => SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: widget,
                        ),
                      ),
                      children: question.options.map((option) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ElevatedButton(
                            onPressed: selectedAnswer == null
                                ? () => selectAnswer(option)
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: selectedAnswer == option
                                  ? (option == question.answer
                                  ? Colors.green
                                  : Colors.red)
                                  : isDarkMode
                                  ? Colors.blueGrey[700]
                                  : Colors.blue[100],
                              padding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 24,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              option,
                              style: TextStyle(
                                fontSize: 16,
                                color: selectedAnswer == option
                                    ? Colors.white
                                    : isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Question {
  final String question;
  final List<String> options;
  final String answer;
  final String? image;

  Question({
    required this.question,
    required this.options,
    required this.answer,
    this.image,
  });
}