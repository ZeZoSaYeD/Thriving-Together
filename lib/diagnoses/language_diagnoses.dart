import 'package:flutter/material.dart';
import 'package:final_thriving_together/Theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../pages/loading_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LanguageDiagnoses extends StatelessWidget {
  const LanguageDiagnoses({super.key});

  // ignore: unused_element
  Future<void> _navigateWithLoading(BuildContext context, Widget targetPage) async {
    // Show loading screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoadingScreen()),
    );

    // Simulate a delay (e.g., fetching data or preparing the target page)
    await Future.delayed(Duration(seconds: 2));

    // Navigate to the target page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => targetPage,
        settings: RouteSettings(arguments: true),
      ),
    ).then((value) {
      if (value == true) {
        _navigateWithLoading(context, targetPage);
      }
    });
  }

  Widget _buildHeaderSection(BuildContext context, AppLocalizations l10n, bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDarkMode
              ? [Colors.blue[900]!, Colors.blue[700]!]
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
              l10n.languageDisorderTitle,
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

  Widget _buildBulletListText(List<String> items, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((item) =>
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5, right: 10),
                  child: Icon(
                    Icons.circle,
                    size: 8,
                    color: color,
                  ),
                ),
                Expanded(
                  child: Text(
                    item,
                    style: TextStyle(
                      fontSize: 18,
                      height: 1.5,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
          )).toList(),
    );
  }

  Widget _buildHighlightedSubsection(String title, String content, Color highlightColor, Color textColor) {
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
            _buildParagraphText(content, textColor),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteText(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.orange.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: Colors.orange,
              size: 30,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final textColor = isDarkMode ? Colors.white : Colors.blue[900]!;
    final accentColor = isDarkMode ? Colors.yellow[200]! : Colors.yellow[700]!;
    final backgroundColor = isDarkMode ? Colors.grey[900]! : Colors.white;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: AnimationLimiter(
              child: Column(
                children: AnimationConfiguration.toStaggeredList(
                  duration: const Duration(milliseconds: 500),
                  childAnimationBuilder: (widget) =>
                      SlideAnimation(
                        horizontalOffset: 50.0,
                        child: FadeInAnimation(
                          child: widget,
                        ),
                      ),
                  children: [
                    _buildHeaderSection(context, l10n, isDarkMode),
                    _buildContentContainer(
                      context,
                      backgroundColor,
                      Column(
                        children: [
                          _buildSectionTitle(
                            l10n.languageDisorderDiagnosis,
                            accentColor,
                          ),
                          _buildParagraphText(
                            l10n.languageDisorderDefinition,
                            textColor,
                          ),

                          _buildSectionTitle(
                            l10n.typesOfLanguageDisorders,
                            accentColor,
                          ),
                          _buildBulletListText(
                            [
                              l10n.expressiveLanguageDisorder,
                              l10n.receptiveLanguageDisorder,
                              l10n.mixedReceptiveExpressive,
                              l10n.phonologicalDisorder,
                              l10n.stutteringDisorder
                            ],
                            textColor,
                          ),

                          _buildSectionTitle(
                            l10n.keyAssessmentAreas,
                            accentColor,
                          ),
                          _buildBulletListText(
                            [
                              l10n.vocabularyAssessment,
                              l10n.sentenceStructureAssessment,
                              l10n.narrativeSkillsAssessment,
                              l10n.socialCommunicationAssessment,
                              l10n.speechSoundAssessment,
                              l10n.listeningAssessment
                            ],
                            textColor,
                          ),

                          _buildSectionTitle(
                            l10n.standardizedAssessmentTools,
                            accentColor,
                          ),
                          _buildHighlightedSubsection(
                            l10n.celf5Title,
                            l10n.celf5Description,
                            Colors.amber,
                            textColor,
                          ),
                          _buildHighlightedSubsection(
                            l10n.pls5Title,
                            l10n.pls5Description,
                            Colors.amber,
                            textColor,
                          ),
                          _buildHighlightedSubsection(
                            l10n.toldp5Title,
                            l10n.toldp5Description,
                            Colors.amber,
                            textColor,
                          ),

                          _buildSectionTitle(
                            l10n.diagnosticIndicators,
                            accentColor,
                          ),
                          _buildParagraphText(
                            l10n.diagnosisRequirements,
                            textColor,
                          ),

                          _buildNoteText(
                            l10n.languageDisorderNote,
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
}