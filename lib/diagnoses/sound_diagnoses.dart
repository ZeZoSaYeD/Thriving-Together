import 'package:flutter/material.dart';
import 'package:final_thriving_together/Theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../pages/loading_screen.dart';

class SoundDiagnoses extends StatelessWidget {
  const SoundDiagnoses({super.key});

  // ignore: unused_element
  Future<void> _navigateWithLoading(BuildContext context,
      Widget targetPage) async {
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
        settings: RouteSettings(arguments: true), // Pass arguments if needed
      ),
    ).then((value) {
      // Show loading screen again when the user navigates back
      if (value == true) {
        _navigateWithLoading(context, targetPage);
      }
    });
  }

  Widget _buildHeaderSection(BuildContext context,
      AppLocalizations appLocalizations, bool isDarkMode) {
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
              appLocalizations.voiceDisorderDiagnosis,
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

  Widget _buildContentContainer(BuildContext context, Color backgroundColor,
      Widget child,AppLocalizations appLocalizations) {
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

  Widget _buildSectionTitle(String text, Color color,AppLocalizations appLocalizations) {
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

  Widget _buildParagraphText(String text, Color color,AppLocalizations appLocalizations) {
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

  Widget _buildBulletListText(List<String> items, Color color,AppLocalizations appLocalizations) {
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

  Widget _buildHighlightedSubsection(String title, String content,
      Color highlightColor, Color textColor,AppLocalizations appLocalizations) {
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
            _buildParagraphText(content, textColor,appLocalizations),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteText(String text, Color color,AppLocalizations appLocalizations) {
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
    final accentColor = isDarkMode ? Colors.green[200]! : Colors.green[700]!;
    final backgroundColor = isDarkMode ? Colors.grey[900]! : Colors.white;
    final appLocalizations = AppLocalizations.of(context)!;

    // Voice disorder types
    final disorderTypes = [
      "Vocal nodules (calluses on vocal folds)",
      "Vocal polyps (soft, fluid-filled lesions)",
      "Laryngitis (inflammation of vocal folds)",
      "Spasmodic dysphonia (neurological disorder)",
      "Vocal fold paralysis"
    ];

    // Evaluation methods
    final evaluationMethods = [
      "Case history and symptom review",
      "Perceptual voice assessment (GRBAS scale)",
      "Acoustic analysis (pitch, loudness, quality)",
      "Laryngeal visualization (stroboscopy)",
      "Aerodynamic measures (airflow, pressure)"
    ];

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
                    _buildHeaderSection(context, appLocalizations, isDarkMode),
                    _buildContentContainer(
                        context,
                        backgroundColor,
                        Column(
                          children: [
                            _buildSectionTitle(
                                appLocalizations.voiceDisorderTitle,
                                accentColor,
                                appLocalizations
                            ),
                            _buildParagraphText(
                                appLocalizations.voiceDisorderDescription,
                                textColor,
                                appLocalizations
                            ),
                            _buildSectionTitle(
                                appLocalizations.commonVoiceDisorders,
                                accentColor,
                                appLocalizations
                            ),
                            _buildBulletListText(
                                [
                                  appLocalizations.vocalNodules,
                                  appLocalizations.vocalPolyps,
                                  appLocalizations.laryngitis,
                                  appLocalizations.spasmodicDysphonia,
                                  appLocalizations.vocalFoldParalysis
                                ],
                                textColor,
                                appLocalizations
                            ),
                            _buildSectionTitle(
                                appLocalizations.evaluationMethods,
                                accentColor,
                                appLocalizations
                            ),
                            _buildBulletListText(
                                [
                                  appLocalizations.caseHistory,
                                  appLocalizations.perceptualAssessment,
                                  appLocalizations.acousticAnalysis,
                                  appLocalizations.laryngealVisualization,
                                  appLocalizations.aerodynamicMeasures
                                ],
                                textColor,
                                appLocalizations
                            ),
                            _buildSectionTitle(
                                appLocalizations.assessmentTools,
                                accentColor,
                                appLocalizations
                            ),
                            _buildHighlightedSubsection(
                                appLocalizations.vhiTitle,
                                appLocalizations.vhiDescription,
                                Colors.amber,
                                textColor,
                                appLocalizations
                            ),
                            _buildHighlightedSubsection(
                                appLocalizations.capevTitle,
                                appLocalizations.capevDescription,
                                Colors.amber,
                                textColor,
                                appLocalizations
                            ),
                            _buildHighlightedSubsection(
                                appLocalizations.videostroboscopyTitle,
                                appLocalizations.videostroboscopyDescription,
                                Colors.amber,
                                textColor,
                                appLocalizations
                            ),
                            _buildSectionTitle(
                                appLocalizations.diagnosticIndicators,
                                accentColor,
                                appLocalizations
                            ),
                            _buildParagraphText(
                                appLocalizations.diagnosticCriteria,
                                textColor,
                                appLocalizations
                            ),
                            _buildNoteText(
                                appLocalizations.importantNote,
                                textColor,
                                appLocalizations
                            ),
                            const SizedBox(height: 40),
                          ],
                        ),
                        appLocalizations
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