import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:final_thriving_together/Theme_provider.dart';
import 'package:provider/provider.dart';
import 'dart:math';

class LanguageComprehensionTest extends StatefulWidget {
  @override
  _LanguageComprehensionTestState createState() => _LanguageComprehensionTestState();
}

class _LanguageComprehensionTestState extends State<LanguageComprehensionTest>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> allQuestions = [];
  List<Map<String, dynamic>> questions = [];
  int currentQuestionIndex = 0;
  int score = 0;
  int? selectedOptionIndex;
  bool showResult = false;
  bool showFeedback = false;
  bool isAnswerCorrect = false;
  bool _isLoading = true;
  final AudioPlayer audioPlayer = AudioPlayer();
  final Random _random = Random();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

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
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isLoading) {
      _loadQuestions();
    }
  }

  Future<void> _loadQuestions() async {
    await _initializeQuestions();
    getRandomQuestions();
  }

  List<Map<String, dynamic>> _shuffleOptions(List<Map<String, dynamic>> options) {
    final correctOption = options.firstWhere((opt) => opt["correct"] == true);
    final incorrectOptions = options.where((opt) => opt != correctOption).toList();
    incorrectOptions.shuffle();
    final insertIndex = _random.nextInt(incorrectOptions.length + 1);
    incorrectOptions.insert(insertIndex, correctOption);
    return incorrectOptions;
  }

  Future<void> _initializeQuestions() async {
    final l = AppLocalizations.of(context);
    if (l == null) {
      await Future.delayed(const Duration(milliseconds: 100));
      return _initializeQuestions(); // Retry after delay
    }

    allQuestions = [
      {
        "question": l.question1,
        "options": _shuffleOptions([
          {"image": "assets/images/elephant.jpg", "correct": true},
          {"image": "assets/images/lion.jpg", "correct": false},
          {"image": "assets/images/cat.jpg", "correct": false},
          {"image": "assets/images/dog.jpg", "correct": false},
        ])
      },
      {
        "question": l.question2,
        "options": _shuffleOptions([
          {"image": "assets/images/eating.jpg", "correct": true},
          {"image": "assets/images/running.jpg", "correct": false},
          {"image": "assets/images/sleeping.jpg", "correct": false},
          {"image": "assets/images/playing.jpg", "correct": false},
        ])
      },
      {
        "question": l.question3,
        "options": _shuffleOptions([
          {"image": "assets/images/car.jpg", "correct": true},
          {"image": "assets/images/bus.jpg", "correct": false},
          {"image": "assets/images/bicycle.jpg", "correct": false},
          {"image": "assets/images/train.jpg", "correct": false},
        ])
      },
      {
        "question": l.question4,
        "options": _shuffleOptions([
          {"image": "assets/images/plane.jpg", "correct": true},
          {"image": "assets/images/boat.jpg", "correct": false},
          {"image": "assets/images/car.jpg", "correct": false},
          {"image": "assets/images/train.jpg", "correct": false},
        ])
      },
      {
        "question": l.question5,
        "options": _shuffleOptions([
          {"image": "assets/images/fish.jpg", "correct": true},
          {"image": "assets/images/dog.jpg", "correct": false},
          {"image": "assets/images/cat.jpg", "correct": false},
          {"image": "assets/images/rabbit.jpg", "correct": false},
        ])
      },
      {
        "question": l.question6,
        "options": _shuffleOptions([
          {"image": "assets/images/doctor.jpg", "correct": true},
          {"image": "assets/images/teacher.jpg", "correct": false},
          {"image": "assets/images/policeman.jpg", "correct": false},
          {"image": "assets/images/chef.jpg", "correct": false},
        ])
      },
      {
        "question": l.question7,
        "options": _shuffleOptions([
          {"image": "assets/images/reading.jpg", "correct": true},
          {"image": "assets/images/writing.jpg", "correct": false},
          {"image": "assets/images/running.jpg", "correct": false},
          {"image": "assets/images/cooking.jpg", "correct": false},
        ])
      },
      {
        "question": l.question8,
        "options": _shuffleOptions([
          {"image": "assets/images/rain.jpg", "correct": true},
          {"image": "assets/images/sun.jpg", "correct": false},
          {"image": "assets/images/snow.jpg", "correct": false},
          {"image": "assets/images/cloud.jpg", "correct": false},
        ])
      },
      {
        "question": l.question9,
        "options": _shuffleOptions([
          {"image": "assets/images/night.jpg", "correct": true},
          {"image": "assets/images/morning.jpg", "correct": false},
          {"image": "assets/images/sunset.jpg", "correct": false},
          {"image": "assets/images/noon.jpg", "correct": false},
        ])
      },
      {
        "question": l.question10,
        "options": _shuffleOptions([
          {"image": "assets/images/ball.jpg", "correct": true},
          {"image": "assets/images/bat.jpg", "correct": false},
          {"image": "assets/images/bicycle.jpg", "correct": false},
          {"image": "assets/images/hat.jpg", "correct": false},
        ])
      },
      {
        "question": l.question11,
        "options": _shuffleOptions([
          {"image": "assets/images/swimming.jpg", "correct": true},
          {"image": "assets/images/jumping.jpg", "correct": false},
          {"image": "assets/images/running.jpg", "correct": false},
          {"image": "assets/images/cycling.jpg", "correct": false},
        ])
      },
      {
        "question": l.question12,
        "options": _shuffleOptions([
          {"image": "assets/images/school.jpg", "correct": true},
          {"image": "assets/images/hospital.jpg", "correct": false},
          {"image": "assets/images/bank.jpg", "correct": false},
          {"image": "assets/images/shop.jpg", "correct": false},
        ])
      },
      {
        "question": l.question13,
        "options": _shuffleOptions([
          {"image": "assets/images/sleeping.jpg", "correct": true},
          {"image": "assets/images/running.jpg", "correct": false},
          {"image": "assets/images/eating.jpg", "correct": false},
          {"image": "assets/images/reading.jpg", "correct": false},
        ])
      },
    ];

    setState(() {
      _isLoading = false;
    });
  }

  void getRandomQuestions() {
    setState(() {
      questions = List.from(allQuestions)..shuffle();
      questions = questions.take(10).toList();
      currentQuestionIndex = 0;
      score = 0;
      showResult = false;
      showFeedback = false;
      selectedOptionIndex = null;
      _animationController.reset();
      _animationController.forward();
    });
  }


  void selectOption(int index) {
    setState(() {
      selectedOptionIndex = index;
    });
  }

  Future<void> nextQuestion() async {
    if (selectedOptionIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.selectOption)),
      );
      return;
    }

    bool isCorrect = questions[currentQuestionIndex]["options"][selectedOptionIndex!]["correct"];
    setState(() {
      showFeedback = true;
      isAnswerCorrect = isCorrect;
    });

    if (isCorrect) {
      score++;
      await audioPlayer.play(AssetSource('sounds/correct.mp3'));
    } else {
      await audioPlayer.play(AssetSource('sounds/wrong.mp3'));
    }

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      showFeedback = false;
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
        selectedOptionIndex = null;
        _animationController.reset();
        _animationController.forward();
      } else {
        showResult = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    if (l == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text('Loading language resources...'),
            ],
          ),
        ),
      );
    }

    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (questions.isEmpty) {
      return Scaffold(
        body: Center(
          child: Text(l.loadingQuestions),
        ),
      );
    }

    if (showResult) {
      return _buildResultScreen(l, isDarkMode);
    }

    return _buildQuestionScreen(isDarkMode);
  }

  Widget _buildQuestionScreen(bool isDarkMode) {
    var currentQuestion = questions[currentQuestionIndex];

    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.blueGrey[800] : Colors.blue[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        currentQuestion["question"],
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
                const SizedBox(height: 20),
                Expanded(
                  child: AnimationLimiter(
                    child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: 1.0,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      children: List.generate(4, (index) {
                        return AnimationConfiguration.staggeredGrid(
                          position: index,
                          duration: const Duration(milliseconds: 500),
                          columnCount: 2,
                          child: ScaleAnimation(
                            child: FadeInAnimation(
                              child: GestureDetector(
                                onTap: () => selectOption(index),
                                child: Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: BorderSide(
                                      color: selectedOptionIndex == index
                                          ? Colors.blue
                                          : Colors.transparent,
                                      width: 3,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      currentQuestion["options"][index]["image"],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                AnimatedContainer(
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
                    onPressed: nextQuestion,
                    child: Text(
                      AppLocalizations.of(context)!.next,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (showFeedback)
            Positioned.fill(
              child: Container(
                color: Colors.black54,
                child: Center(
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        isAnswerCorrect
                            ? AppLocalizations.of(context)!.correctAnswer
                            : AppLocalizations.of(context)!.wrongAnswer,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: isAnswerCorrect ? Colors.green : Colors.red,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildResultScreen(AppLocalizations l, bool isDarkMode) {
    return Scaffold(
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
                        l.result,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        '${l.youGot} $score ${l.outOf} ${questions.length} ${l.questionsCorrect}',
                        style: const TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 300),
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: (score / questions.length) >= 0.7
                              ? Colors.green
                              : (score / questions.length) >= 0.4
                              ? Colors.orange
                              : Colors.red,
                        ),
                        child: Text(
                          '${((score / questions.length) * 100).toStringAsFixed(0)}%',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
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
                        onPressed: getRandomQuestions,
                        child: Text(
                          l.restartTest,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        l.back,
                        style: TextStyle(
                          fontSize: 16,
                          color: isDarkMode ? Colors.blue[200] : Colors.blue[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    audioPlayer.dispose();
    super.dispose();
  }
}