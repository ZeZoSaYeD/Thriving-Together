import 'package:final_thriving_together/exams/intelligence_test.dart';
import 'package:final_thriving_together/exams/language_comprehension_test.dart' show LanguageComprehensionTest;
import 'package:final_thriving_together/exams/mchat_test.dart';
import 'package:final_thriving_together/exams/mental_age_test.dart';
import 'package:final_thriving_together/pages/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:final_thriving_together/navigation_bar.dart';
import 'package:final_thriving_together/Theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class Examspage extends StatefulWidget {
  final String? examId;
  const Examspage({this.examId, Key? key}) : super(key: key);

  @override
  State<Examspage> createState() => _ExamspageState();
}

class _ExamspageState extends State<Examspage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  int currentIndex = 3;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _navigateWithLoading(BuildContext context, Widget targetPage) async {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => LoadingScreen(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
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

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final appLocalizations = AppLocalizations.of(context)!;

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
            appLocalizations.exams,
            key: ValueKey<String>(appLocalizations.exams),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: themeProvider.isDarkMode ? Colors.black : const Color(0xFF4070F4),
        elevation: 0,
      ),
      body: Stack(
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
                    themeProvider.isDarkMode ? Colors.grey[900]! : Colors.blue[50]!,
                    themeProvider.isDarkMode ? Colors.black : Colors.white,
                  ],
                ),
              ),
            ),
          ),

          // Content with staggered animations
          AnimationLimiter(
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: AnimationConfiguration.toStaggeredList(
                    duration: const Duration(milliseconds: 500),
                    childAnimationBuilder: (widget) => SlideAnimation(
                      horizontalOffset: 50.0,
                      child: FadeInAnimation(
                        child: widget,
                      ),
                    ),
                    children: [
                      const SizedBox(height: 20),
                      _buildExamCard(
                        context,
                        title: appLocalizations.mchatTitle,
                        description: appLocalizations.mchatDescription,
                        icon: Icons.child_care,
                        route: MCHATTest(),
                      ),
                      const SizedBox(height: 20),
                      _buildExamCard(
                        context,
                        title: appLocalizations.languageComprehensionTestTitle,
                        description: appLocalizations.languageComprehensionTestDesc,
                        icon: Icons.language,
                        route: LanguageComprehensionTest(),
                      ),
                      const SizedBox(height: 20),
                      _buildExamCard(
                        context,
                        title: appLocalizations.mentalAgeTest,
                        description: appLocalizations.mentalAgeTestDesc,
                        icon: Icons.psychology,
                        route: MentalAgeTestApp(),
                      ),
                      const SizedBox(height: 20),
                      _buildExamCard(
                        context,
                        title: appLocalizations.intelligenceTestTitle,
                        description: appLocalizations.intelligenceTestDesc,
                        icon: Icons.psychology_alt,
                        route: IntelligenceTestApp(),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Navigationbar(currentIndex: currentIndex),
    );
  }

  Widget _buildExamCard(
      BuildContext context, {
        required String title,
        required String description,
        required IconData icon,
        required Widget route,
      }) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final appLocalizations = AppLocalizations.of(context)!;

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
                  color: themeProvider.isDarkMode
                      ? Colors.grey[800]!.withOpacity(0.8)
                      : Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: themeProvider.isDarkMode
                          ? Colors.blue[900]!.withOpacity(0.3)
                          : Colors.blue[100]!,
                      blurRadius: 15,
                      spreadRadius: 2,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: themeProvider.isDarkMode
                            ? Colors.blue[900]!.withOpacity(0.5)
                            : Colors.blue[50],
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16)),
                      ),
                      child: Center(
                        child: Icon(
                          icon,
                          size: 60,
                          color: themeProvider.isDarkMode
                              ? Colors.lightBlueAccent
                              : const Color(0xFF4070F4),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: themeProvider.isDarkMode
                                  ? Colors.white
                                  : const Color(0xFF4070F4),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            description,
                            style: TextStyle(
                              fontSize: 16,
                              color: themeProvider.isDarkMode
                                  ? Colors.grey[300]
                                  : Colors.grey[700],
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              onPressed: () => _navigateWithLoading(context, route),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4070F4),
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
                                appLocalizations.exams_start,
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