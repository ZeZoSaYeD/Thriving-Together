import 'package:flutter/material.dart';
import 'package:final_thriving_together/Theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class AsdPage extends StatelessWidget {
  const AsdPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final appLocalizations = AppLocalizations.of(context)!;
    final isDarkMode = themeProvider.isDarkMode;
    final textColor = isDarkMode ? Colors.white : Colors.blue[900]!;
    final accentColor = isDarkMode ? Colors.blue[200]! : Colors.blue[700]!;
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
                          _buildSectionTitle(
                            appLocalizations.autismSymptomsTitle,
                            accentColor,
                          ),
                          _buildParagraphText(
                            appLocalizations.autismDefinition,
                            textColor,
                          ),

                          _buildSectionTitle(
                            appLocalizations.prevalenceAndDiagnosisTitle,
                            accentColor,
                          ),
                          _buildParagraphText(
                            appLocalizations.prevalenceText,
                            textColor,
                          ),

                          _buildSectionTitle(
                            appLocalizations.coreDevelopmentalChallengesTitle,
                            accentColor,
                          ),
                          _buildParagraphText(
                            appLocalizations.coreChallengesIntro,
                            accentColor,
                          ),

                          _buildSubsectionTitle(
                            appLocalizations.socialInteraction,
                            textColor,
                          ),
                          _buildParagraphText(
                            appLocalizations.socialInteractionText,
                            textColor,
                          ),

                          _buildSubsectionTitle(
                            appLocalizations.languageasd,
                            textColor,
                          ),
                          _buildParagraphText(
                            appLocalizations.languageText,
                            textColor,
                          ),

                          _buildSubsectionTitle(
                            appLocalizations.behavior,
                            textColor,
                          ),
                          _buildParagraphText(
                            appLocalizations.behaviorText,
                            textColor,
                          ),

                          _buildSectionTitle(
                            appLocalizations.developmentalProgression,
                            accentColor,
                          ),

                          _buildSectionTitle(
                            appLocalizations.symptomsIntro,
                            accentColor,
                          ),

                          _buildSectionTitle(
                            appLocalizations.commonSymptomsTitle,
                            accentColor,
                          ),

                          _buildSubsectionTitle(
                            appLocalizations.socialDeficits,
                            textColor,
                          ),
                          _buildBulletListText(
                            appLocalizations.socialDeficitsList,
                            textColor,
                          ),

                          _buildSubsectionTitle(
                            appLocalizations.languageChallenges,
                            textColor,
                          ),
                          _buildBulletListText(
                            appLocalizations.languageChallengesList,
                            textColor,
                          ),

                          _buildSubsectionTitle(
                            appLocalizations.behavioralPatterns,
                            textColor,
                          ),
                          _buildBulletListText(
                            appLocalizations.behavioralPatternsList,
                            textColor,
                          ),

                          _buildNoteText(
                            appLocalizations.youngChildrenNote,
                            textColor,
                          ),

                          _buildSectionTitle(
                            appLocalizations.causesAndRiskFactorsTitle,
                            accentColor,
                          ),
                          _buildParagraphText(
                            appLocalizations.causesIntro,
                            textColor,
                          ),

                          _buildHighlightedSubsection(
                            appLocalizations.geneticFactors,
                            appLocalizations.geneticFactorsText,
                            Colors.amber,
                            textColor,
                          ),

                          _buildHighlightedSubsection(
                            appLocalizations.environmentalFactors,
                            appLocalizations.environmentalFactorsText,
                            Colors.amber,
                            textColor,
                          ),

                          _buildHighlightedSubsection(
                            appLocalizations.additionalTheories,
                            appLocalizations.additionalTheoriesText,
                            Colors.amber,
                            textColor,
                          ),

                          _buildSectionTitle(
                            appLocalizations.knownRiskFactorsTitle,
                            accentColor,
                          ),

                          _buildHighlightedSubsection(
                            appLocalizations.gender,
                            appLocalizations.genderText,
                            Colors.amber,
                            textColor,
                          ),

                          _buildHighlightedSubsection(
                            appLocalizations.familyHistory,
                            appLocalizations.familyHistoryText,
                            Colors.amber,
                            textColor,
                          ),

                          _buildHighlightedSubsection(
                            appLocalizations.medicalConditions,
                            appLocalizations.medicalConditionsText,
                            Colors.amber,
                            textColor,
                          ),

                          _buildHighlightedSubsection(
                            appLocalizations.parentalAge,
                            appLocalizations.parentalAgeText,
                            Colors.amber,
                            textColor,
                          ),

                          _buildSectionTitle(
                            appLocalizations.complicationsTitle,
                            accentColor,
                          ),
                          _buildParagraphText(
                            appLocalizations.complicationsIntro,
                            accentColor,
                          ),
                          _buildBulletListText(
                            appLocalizations.complicationsList,
                            textColor,
                          ),

                          _buildSectionTitle(
                            appLocalizations.diagnosisTitle,
                            accentColor,
                          ),
                          _buildParagraphText(
                            appLocalizations.diagnosisIntro,
                            accentColor,
                          ),
                          _buildBulletListText(
                            appLocalizations.diagnosisList,
                            textColor,
                          ),

                          _buildSectionTitle(
                            appLocalizations.treatmentOptionsTitle,
                            accentColor,
                          ),
                          _buildParagraphText(
                            appLocalizations.treatmentIntro,
                            accentColor,
                          ),

                          _buildHighlightedSubsection(
                            appLocalizations.behavioralTherapy,
                            appLocalizations.behavioralTherapyText,
                            Colors.green,
                            textColor,
                          ),

                          _buildHighlightedSubsection(
                            appLocalizations.speechTherapy,
                            appLocalizations.speechTherapyText,
                            Colors.green,
                            textColor,
                          ),

                          _buildHighlightedSubsection(
                            appLocalizations.educationalInterventions,
                            appLocalizations.educationalInterventionsText,
                            Colors.green,
                            textColor,
                          ),

                          _buildHighlightedSubsection(
                            appLocalizations.medication,
                            appLocalizations.medicationText,
                            Colors.green,
                            textColor,
                          ),

                          _buildHighlightedSubsection(
                            appLocalizations.alternativeTherapies,
                            appLocalizations.alternativeTherapiesText,
                            Colors.green,
                            textColor,
                          ),

                          _buildSubsectionTitle(
                            appLocalizations.alternativeExamplesTitle,
                            Colors.green,
                          ),
                          _buildBulletListText(
                            appLocalizations.alternativeExamplesList,
                            textColor,
                          ),

                          _buildNoteText(
                            appLocalizations.alternativeTherapiesNote,
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
          // Animated title
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
              appLocalizations.autismSpectrum,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 10),
          // Animated divider
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

  Widget _buildSubsectionTitle(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 300),
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: color,
          letterSpacing: 0.3,
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

  Widget _buildBulletListText(String text, Color color) {
    // Split text by newlines to create bullet points
    final points = text.split('\n');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final point in points)
          if (point.trim().isNotEmpty)
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
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 300),
                      style: TextStyle(
                        fontSize: 18,
                        height: 1.5,
                        color: color,
                      ),
                      child: Text(
                        point,
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                ],
              ),
            ),
      ],
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
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: color,
                ),
                child: Text(
                  text,
                  textAlign: TextAlign.start,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}