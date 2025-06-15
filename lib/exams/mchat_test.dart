import 'package:final_thriving_together/pages/Settings.dart';
import 'package:flutter/material.dart';
import 'package:final_thriving_together/Theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:audioplayers/audioplayers.dart';

class MCHATTest extends StatefulWidget {
  @override
  _MCHATTestState createState() => _MCHATTestState();
}

class _MCHATTestState extends State<MCHATTest> with SingleTickerProviderStateMixin {
  int currentQuestionIndex = 0;
  int score = 0;
  bool? selectedAnswer;
  bool showResult = false;
  bool showFeedback = false;
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

  List<String> getQuestions(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    return [
      appLocalizations.mchatQuestion1,
      appLocalizations.mchatQuestion2,
      appLocalizations.mchatQuestion3,
      appLocalizations.mchatQuestion4,
      appLocalizations.mchatQuestion5,
      appLocalizations.mchatQuestion6,
      appLocalizations.mchatQuestion7,
      appLocalizations.mchatQuestion8,
      appLocalizations.mchatQuestion9,
      appLocalizations.mchatQuestion10,
      appLocalizations.mchatQuestion11,
      appLocalizations.mchatQuestion12,
      appLocalizations.mchatQuestion13,
      appLocalizations.mchatQuestion14,
      appLocalizations.mchatQuestion15,
      appLocalizations.mchatQuestion16,
      appLocalizations.mchatQuestion17,
      appLocalizations.mchatQuestion18,
      appLocalizations.mchatQuestion19,
      appLocalizations.mchatQuestion20,
    ];
  }

  Future<void> selectAnswer(bool isYes) async {
    setState(() {
      selectedAnswer = isYes;
      if (!isYes) score++; // Only increment score for "No" answers
    });
  }

  void nextQuestion() {
    _animationController.reset();
    setState(() {
      if (currentQuestionIndex < getQuestions(context).length - 1) {
        currentQuestionIndex++;
        selectedAnswer = null;
        _animationController.forward();
      } else {
        showResult = true;
      }
    });
  }

  void restartTest() {
    _animationController.reset();
    setState(() {
      currentQuestionIndex = 0;
      score = 0;
      selectedAnswer = null;
      showResult = false;
      _animationController.forward();
    });
  }

  String getResultText(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    if (score <= 2) {
      return appLocalizations.mchatResultLowRisk;
    } else if (score <= 7) {
      return appLocalizations.mchatResultMediumRisk;
    } else {
      return appLocalizations.mchatResultHighRisk;
    }
  }

  Color getResultColor(BuildContext context) {
    if (score <= 2) {
      return Colors.green;
    } else if (score <= 7) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final appLocalizations = AppLocalizations.of(context)!;
    final questions = getQuestions(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.mchatTitle),
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
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (!showResult) ...[
                  SlideTransition(
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
                          questions[currentQuestionIndex],
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
                  const SizedBox(height: 32),
                  AnimationLimiter(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        AnimationConfiguration.staggeredGrid(
                          position: 0,
                          duration: const Duration(milliseconds: 500),
                          columnCount: 2,
                          child: ScaleAnimation(
                            child: FadeInAnimation(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: selectedAnswer == true
                                      ? Colors.green[400]
                                      : isDarkMode
                                      ? Colors.blueGrey[700]
                                      : Colors.blue[100],
                                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 5,
                                ),
                                onPressed: () => selectAnswer(true),
                                child: Text(
                                  appLocalizations.yes,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: selectedAnswer == true ? Colors.white : isDarkMode ? Colors.white : Colors.blue[900],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        AnimationConfiguration.staggeredGrid(
                          position: 1,
                          duration: const Duration(milliseconds: 500),
                          columnCount: 2,
                          child: ScaleAnimation(
                            child: FadeInAnimation(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: selectedAnswer == false
                                      ? Colors.red[400]
                                      : isDarkMode
                                      ? Colors.blueGrey[700]
                                      : Colors.blue[100],
                                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 5,
                                ),
                                onPressed: () => selectAnswer(false),
                                child: Text(
                                  appLocalizations.no,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: selectedAnswer == false ? Colors.white : isDarkMode ? Colors.white : Colors.blue[900],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
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
                      onPressed: selectedAnswer != null ? nextQuestion : null,
                      child: Text(
                        appLocalizations.next,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
                if (showResult) ...[
                  AnimationLimiter(
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
                                  appLocalizations.result,
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  appLocalizations.mchatScore(score, questions.length),
                                  style: const TextStyle(fontSize: 20),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 20),
                                AnimatedDefaultTextStyle(
                                  duration: const Duration(milliseconds: 300),
                                  style: TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    color: getResultColor(context),
                                  ),
                                  child: Text(
                                    '${((score / questions.length) * 100).toStringAsFixed(0)}%',
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  getResultText(context),
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: getResultColor(context),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 20),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                  child: Text(
                                    appLocalizations.mchatDisclaimer,
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
                                  onPressed: restartTest,
                                  child: Text(
                                    appLocalizations.restartTest,
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
                                  appLocalizations.finishTest,
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
                ],
              ],
            ),
          ),
          /*if (showFeedback)
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
                        selectedAnswer == false
                            ? appLocalizations.correctAnswer
                            : appLocalizations.wrongAnswer,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: selectedAnswer == false ? Colors.green : Colors.red,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            */
        ],
      ),
    );
  }
}