import 'dart:async';
import 'package:final_thriving_together/pages/Settings.dart';
import 'package:flutter/material.dart';
import 'package:final_thriving_together/Theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MentalAgeTestApp(),
    ),
  );
}

class MentalAgeTestApp extends StatelessWidget {
  const MentalAgeTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Mental Age Test',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: const [
        Locale('en'), // English
        Locale('ar'), // Arabic
      ],
      locale: themeProvider.currentLocale,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Arial',
      ),
      darkTheme: ThemeData.dark(),
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

class _StartScreenState extends State<StartScreen> with SingleTickerProviderStateMixin {
  final _ageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _audioPlayer.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.mentalAgeTest),
        centerTitle: true,
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
        backgroundColor: isDarkMode ? Colors.blueGrey[900] : Colors.blue[700],
        foregroundColor: Colors.white,
        elevation: 10,
        shadowColor: isDarkMode ? Colors.blueAccent : Colors.blue[200],
      ),
      body: Center(
        child: AnimationLimiter(
          child: Form(
            key: _formKey,
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
                  AnimationConfiguration.staggeredList(
                    position: 0,
                    duration: const Duration(milliseconds: 500),
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Text(
                          loc.enterYourAge,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  AnimationConfiguration.staggeredList(
                    position: 1,
                    duration: const Duration(milliseconds: 500),
                    child: SizedBox(
                      width: 200,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: TextFormField(
                            controller: _ageController,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return loc.ageValidation;
                              }
                              final age = int.tryParse(value);
                              if (age == null || age < 3 || age > 15) {
                                return loc.ageRangeValidation;
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: loc.enterYourAge,
                              filled: true,
                              fillColor: isDarkMode ? Colors.blueGrey[800] : Colors.blue[50],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  AnimationConfiguration.staggeredList(
                    position: 2,
                    duration: const Duration(milliseconds: 500),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
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
                          if (_formKey.currentState!.validate()) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => QuizScreen(
                                  userAge: int.parse(_ageController.text),
                                ),
                              ),
                            );
                          }
                        },
                        child: Text(
                          loc.startTest,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class QuizScreen extends StatefulWidget {
  final int userAge;

  const QuizScreen({super.key, required this.userAge});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with SingleTickerProviderStateMixin {
  late List<Question> selectedQuestions;
  int currentQuestionIndex = 0;
  int score = 0;
  int totalAgeLevel = 0;
  late int timeLeft;
  late Timer timer;
  String? selectedAnswer;
  bool _questionsInitialized = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    timeLeft = 10;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
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
      selectedQuestions = selectedQuestions.take(5).toList();
      _questionsInitialized = true;
      startTimer();
    }
  }

  @override
  void dispose() {
    timer.cancel();
    _animationController.dispose();
    _audioPlayer.dispose();
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
    if (currentQuestionIndex < selectedQuestions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        timeLeft = 10;
        selectedAnswer = null;
        _animationController.reset();
        _animationController.forward();
        startTimer();
      });
    } else {
      showResult();
    }
  }

  Future<void> selectAnswer(String answer) async {
    timer.cancel();
    final question = selectedQuestions[currentQuestionIndex];

    if (answer == question.answer) {
      score++;
      totalAgeLevel += question.ageLevel;
      await _audioPlayer.play(AssetSource('sounds/correct.mp3'));
    } else {
      await _audioPlayer.play(AssetSource('sounds/wrong.mp3'));
    }

    setState(() {
      selectedAnswer = answer;
    });
    await Future.delayed(const Duration(seconds: 1));
    nextQuestion();
  }

  void showResult() {
    // Calculate the percentage of correct answers
    double correctPercentage = score / selectedQuestions.length;

    // Calculate mental age based on the percentage of correct answers
    int mentalAge;
    if (correctPercentage == 1.0) {
      // All answers correct - mental age equals actual age
      mentalAge = widget.userAge;
    } else if (correctPercentage >= 0.5) {
      // At least half correct - mental age is 1-2 years less
      mentalAge = widget.userAge - 1;
      if (correctPercentage < 0.75 && widget.userAge > 3) {
        mentalAge = widget.userAge - 2;
      }
    } else if (correctPercentage > 0) {
      // Some correct answers - mental age is 3-5 years less
      mentalAge = widget.userAge - 3;
      if (correctPercentage < 0.25 && widget.userAge > 5) {
        mentalAge = widget.userAge - 5;
      }
    } else {
      // No correct answers - mental age is significantly less
      mentalAge = (widget.userAge * 0.6).round(); // 60% of actual age
      if (mentalAge >= widget.userAge - 1) {
        mentalAge = widget.userAge - 2; // Ensure it's at least 2 years less
      }
    }

    // Ensure mental age doesn't go below 3 (minimum reasonable age)
    mentalAge = mentalAge.clamp(3, 15);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(
          mentalAge: mentalAge,
          userAge: widget.userAge,
        ),
      ),
    );
  }

  List<Question> _getQuestions(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return [
      Question(
        question: loc.q1,
        options: [loc.q1o1, loc.q1o2, loc.q1o3],
        answer: loc.q1o1,
        ageLevel: 6,
        image: 'assets/images/green.png',
      ),
      Question(
        question: loc.q2,
        options: [loc.q2o1, loc.q2o2, loc.q2o3],
        answer: loc.q2o1,
        ageLevel: 7,
        image: 'assets/images/spider.png',
      ),
      Question(
        question: loc.q3,
        options: [loc.q3o1, loc.q3o2, loc.q3o3],
        answer: loc.q3o1,
        ageLevel: 6,
        image: 'assets/images/numbers.png',
      ),
      Question(
        question: loc.q4,
        options: [loc.q4o1, loc.q4o2, loc.q4o3],
        answer: loc.q4o1,
        ageLevel: 8,
        image: 'assets/images/horse.png',
      ),
      Question(
        question: loc.q5,
        options: [loc.q5o1, loc.q5o2, loc.q5o3],
        answer: loc.q5o1,
        ageLevel: 5,
        image: 'assets/images/sun.jpg',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    if (selectedQuestions.isEmpty) {
      return Scaffold(
        body: Center(child: Text(loc.loadingQuestions)),
      );
    }

    final question = selectedQuestions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        // ... (app bar code remains the same)
      ),
      body: SingleChildScrollView(  // Added to prevent overflow
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AnimationConfiguration.staggeredList(
                position: 0,
                duration: const Duration(milliseconds: 500),
                child: FadeInAnimation(
                  child: Text(
                    loc.timeRemaining(timeLeft),
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontSize: 18,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              AnimationConfiguration.staggeredList(
                position: 1,
                duration: const Duration(milliseconds: 500),
                child: SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.blueGrey[800] : Colors.blue[50],
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Text(
                        question.question,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (question.image != null)
                AnimationConfiguration.staggeredList(
                  position: 2,
                  duration: const Duration(milliseconds: 500),
                  child: Container(
                    height: 200,  // Fixed height for image
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: ScaleAnimation(
                      child: FadeInAnimation(
                        child: Image.asset(
                          question.image!,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              AnimationLimiter(
                child: Column(
                  children: AnimationConfiguration.toStaggeredList(
                    duration: const Duration(milliseconds: 500),
                    childAnimationBuilder: (widget) => ScaleAnimation(
                      child: FadeInAnimation(
                        child: widget,
                      ),
                    ),
                    children: question.options.map((option) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Container(
                          width: double.infinity,  // Make buttons full width
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: selectedAnswer == option
                                  ? (option == question.answer
                                  ? Colors.green
                                  : Colors.red)
                                  : isDarkMode
                                  ? Colors.blueGrey[700]
                                  : Colors.blue[100],
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 24),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                  color: isDarkMode
                                      ? Colors.blueGrey[500]!
                                      : Colors.blue[300]!,
                                  width: 1,
                                ),
                              ),
                              elevation: 3,
                              shadowColor: Colors.black.withOpacity(0.2),
                            ),
                            onPressed: selectedAnswer == null
                                ? () => selectAnswer(option)
                                : null,
                            child: Text(
                              option,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: selectedAnswer == option
                                    ? Colors.white
                                    : isDarkMode
                                    ? Colors.white
                                    : Colors.blue[900],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 20),  // Added extra spacing at bottom
            ],
          ),
        ),
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final int mentalAge;
  final int userAge;

  const ResultScreen({
    super.key,
    required this.mentalAge,
    required this.userAge,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final resultColor = mentalAge > userAge ? Colors.green : Colors.blue;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.testResults),
        centerTitle: true,
        backgroundColor: isDarkMode ? Colors.blueGrey[900] : Colors.blue[700],
        foregroundColor: Colors.white,
        elevation: 10,
        shadowColor: isDarkMode ? Colors.blueAccent : Colors.blue[200],
      ),
      body: AnimationLimiter(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
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
                          loc.testResults,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          loc.mentalAgeResult(mentalAge),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: resultColor,
                          ),
                        ),
                        Text(
                          loc.chronologicalAge(userAge),
                          style: const TextStyle(fontSize: 24),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          mentalAge > userAge ? loc.moreMature : loc.atAgeLevel,
                          style: TextStyle(
                            fontSize: 22,
                            color: resultColor,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            loc.mentalAgeDisclaimer,
                            style: TextStyle(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const StartScreen(),
                          ),
                              (route) => false,
                        );
                      },
                      child: Text(
                        loc.backToStart,
                        style: const TextStyle(
                          fontSize: 16,
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
      ),
    );
  }
}

class Question {
  final String question;
  final List<String> options;
  final String answer;
  final int ageLevel;
  final String? image;

  Question({
    required this.question,
    required this.options,
    required this.answer,
    required this.ageLevel,
    this.image,
  });
}