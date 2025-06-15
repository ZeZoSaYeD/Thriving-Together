import 'package:flutter/material.dart';
import 'package:final_thriving_together/Theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class SpeechDisordersPage extends StatelessWidget {
  const SpeechDisordersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final appLocalizations = AppLocalizations.of(context)!;
    final isDarkMode = themeProvider.isDarkMode;
    final textColor = isDarkMode ? Colors.white : Colors.blue[900]!;
    final accentColor = isDarkMode ? Colors.orange[200]! : Colors.orange[700]!;
    final backgroundColor = isDarkMode ? Colors.grey[900]! : Colors.white;

    return Scaffold(
      body: Stack(
        children: [
          // Background image (uncomment if you want to use it)
          /*
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/background image.jpg"),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(isDarkMode ? 0.7 : 0.3),
                    BlendMode.darken,
                  ),
                ),
              ),
            ),
          ),
          */

          // Content with animations
          SingleChildScrollView(
            child: AnimationLimiter(
              child: Column(
                children: AnimationConfiguration.toStaggeredList(
                  duration: const Duration(milliseconds: 500),
                  childAnimationBuilder: (widget) => SlideAnimation(
                    horizontalOffset: 50.0,
                    child: FadeInAnimation(
                      child: widget,
                    ),
                  ),
                  children: [
                    // Header section
                    _buildHeaderSection(context, appLocalizations, isDarkMode),

                    // Main content sections
                    _buildContentContainer(
                      context,
                      backgroundColor,
                      Column(
                        children: [
                          _buildParagraphText(
                            appLocalizations.speechDisordersIntro,
                            textColor,
                          ),
                          _buildParagraphText(
                            appLocalizations.speechDisordersDefinition,
                            textColor,
                          ),

                          _buildSectionTitle(
                            appLocalizations.causesOfSpeechDisordersTitle,
                            accentColor,
                          ),

                          _buildHighlightedSubsection(
                            appLocalizations.physicalProblems,
                            appLocalizations.physicalProblemsText,
                            Colors.orange,
                            textColor,
                          ),

                          _buildHighlightedSubsection(
                            appLocalizations.congenitalAnomalies,
                            appLocalizations.congenitalAnomaliesText,
                            Colors.orange,
                            textColor,
                          ),

                          _buildHighlightedSubsection(
                            appLocalizations.psychologicalFactors,
                            appLocalizations.psychologicalFactorsText,
                            Colors.orange,
                            textColor,
                          ),

                          _buildHighlightedSubsection(
                            appLocalizations.environmentalFactors,
                            appLocalizations.environmentalFactorsText,
                            Colors.orange,
                            textColor,
                          ),

                          _buildSectionTitle(
                            appLocalizations.typesOfChildSpeechDisordersTitle,
                            accentColor,
                          ),

                          _buildHighlightedSubsection(
                            appLocalizations.substitutionTitle,
                            appLocalizations.substitutionText,
                            Colors.orange,
                            textColor,
                          ),

                          _buildHighlightedSubsection(
                            appLocalizations.omissionTitle,
                            appLocalizations.omissionText,
                            Colors.orange,
                            textColor,
                          ),

                          _buildHighlightedSubsection(
                            appLocalizations.additionTitle,
                            appLocalizations.additionText,
                            Colors.orange,
                            textColor,
                          ),

                          _buildHighlightedSubsection(
                            appLocalizations.distortionTitle,
                            appLocalizations.distortionText,
                            Colors.orange,
                            textColor,
                          ),

                          _buildSectionTitle(
                            appLocalizations.diagnosisTitle,
                            accentColor,
                          ),
                          _buildParagraphText(
                            appLocalizations.diagnosisText,
                            textColor,
                          ),

                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection(
      BuildContext context, AppLocalizations appLocalizations, bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDarkMode
              ? [Colors.blueGrey[900]!, Colors.blueGrey[700]!]
              : [const Color(0xFF4070F4), const Color(0xFF5B8DF5)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 3,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 300),
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 5,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
            child: Text(
              appLocalizations.speechDisordersTitle,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 10),
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            height: 3,
            width: 150,
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(3),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.7),
                  blurRadius: 5,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentContainer(BuildContext context, Color backgroundColor, Widget child) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildSectionTitle(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(top: 25, bottom: 15),
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 300),
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: color,
          letterSpacing: 0.5,
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildParagraphText(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 300),
        style: TextStyle(
          fontSize: 18,
          height: 1.6,
          color: color,
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildHighlightedSubsection(
      String title, String content, Color highlightColor, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: highlightColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: highlightColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            // Title with animated underline
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 300),
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: highlightColor,
                    ),
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 2,
                    width: 80,
                    margin: const EdgeInsets.only(top: 5),
                    decoration: BoxDecoration(
                      color: highlightColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ),
            // Content
            _buildParagraphText(content, textColor),
          ],
        ),
      ),
    );
  }
}