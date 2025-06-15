import 'package:flutter/material.dart';
import 'package:final_thriving_together/Theme_provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../pages/loading_screen.dart';

class AsdDiagnoses extends StatelessWidget{
  const AsdDiagnoses({super.key});
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
        settings: RouteSettings(arguments: true), // Pass arguments if needed
      ),
    ).then((value) {
      // Show loading screen again when the user navigates back
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
              l10n.autismSpectrumDisorderTitle,
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

  Widget _buildContentContainer(BuildContext context,AppLocalizations l10n, Color backgroundColor, Widget child) {
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

  Widget _buildSectionTitle(String text,AppLocalizations l10n, Color color) {
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

  Widget _buildParagraphText(String text,AppLocalizations l10n, Color color) {
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

  Widget _buildBulletListText(List<String> items,AppLocalizations l10n, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((item) => Padding(
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

  Widget _buildHighlightedSubsection(String title, String content,AppLocalizations l10n, Color highlightColor, Color textColor) {
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
            _buildParagraphText(content,l10n, textColor),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteText(String text,AppLocalizations l10n, Color color) {
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
    final accentColor = isDarkMode ? Colors.blue[200]! : Colors.blue[700]!;
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
                  childAnimationBuilder: (widget) => SlideAnimation(
                    horizontalOffset: 50.0,
                    child: FadeInAnimation(
                      child: widget,
                    ),
                  ),
                  children: [
                    _buildHeaderSection(context, l10n, isDarkMode),
                    _buildContentContainer(
                      context,l10n,
                      backgroundColor,
                      Column(
                        children: [
                          _buildSectionTitle(
                            l10n.asdDiagnosticCriteriaTitle,
                            l10n,
                            accentColor,
                          ),
                          _buildParagraphText(
                            l10n.asdDiagnosisDescription,
                            l10n,
                            textColor,
                          ),

                          _buildSectionTitle(
                            l10n.dsm5CriteriaTitle,
                            l10n,
                            accentColor,
                          ),
                          _buildBulletListText(
                            [
                              l10n.asdCriterion1,
                              l10n.asdCriterion2,
                              l10n.asdCriterion3,
                              l10n.asdCriterion4,
                              l10n.asdCriterion5
                            ],
                            l10n,
                            textColor,
                          ),

                          _buildSectionTitle(
                            l10n.assessmentToolsTitle,
                            l10n,
                            accentColor,
                          ),
                          _buildHighlightedSubsection(
                            l10n.ados2Title,
                            l10n.ados2Description,
                            l10n,
                            Colors.amber,
                            textColor,
                          ),
                          _buildHighlightedSubsection(
                            l10n.adiRTitle,
                            l10n.adiRDescription,
                            l10n,
                            Colors.amber,
                            textColor,
                          ),
                          _buildHighlightedSubsection(
                            l10n.mchatTitle,
                            l10n.mchatDescription,
                            l10n,
                            Colors.amber,
                            textColor,
                          ),

                          _buildSectionTitle(
                            l10n.earlySignsTitle,
                            l10n,
                            accentColor,
                          ),
                          _buildBulletListText(
                            [
                              l10n.earlySign1,
                              l10n.earlySign2,
                              l10n.earlySign3,
                              l10n.earlySign4,
                              l10n.earlySign5
                            ],
                            l10n,
                            textColor,
                          ),

                          _buildSectionTitle(
                            l10n.screeningProcessTitle,
                            l10n,
                            accentColor,
                          ),
                          _buildParagraphText(
                            l10n.screeningProcessDescription,
                            l10n,
                            textColor,
                          ),

                          _buildNoteText(
                            l10n.asdDiagnosisNote,
                            l10n,
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
