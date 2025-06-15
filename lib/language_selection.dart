import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:final_thriving_together/Theme_provider.dart';
import 'package:final_thriving_together/pages/loading_screen.dart';
import 'package:final_thriving_together/registration/login.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class LanguageSelectionPage extends StatelessWidget {
  final List<Map<String, String>> languages = [
    {'code': 'en', 'name': 'English', 'icon': '🇺🇸', 'subtitle': 'The global language'},
    {'code': 'ar', 'name': 'العربية', 'icon': '🇪🇬', 'subtitle': 'لغة الضاد'},
    // Add more languages as needed
  ];

  Future<void> _changeLanguage(BuildContext context, String languageCode) async {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    await themeProvider.setLocale(Locale(languageCode));

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => LoadingScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: Duration(milliseconds: 500),
      ),
    );

    await Future.delayed(Duration(seconds: 2));

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => LoginForm(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = Offset(1.0, 0.0);
          var end = Offset.zero;
          var curve = Curves.easeInOutQuart;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 800),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          loc.chooseLanguage,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
            shadows: [
              Shadow(
                blurRadius: 4.0,
                color: Colors.black.withOpacity(0.2),
                offset: Offset(1.0, 1.0),
              ),
            ],
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF4070F4),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF4070F4).withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: AnimationLimiter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Animated header text
                AnimationConfiguration.staggeredList(
                  position: 0,
                  duration: const Duration(milliseconds: 500),
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Text(
                          loc.selectYourPreferredLanguage,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                // Animated subtitle
                AnimationConfiguration.staggeredList(
                  position: 1,
                  duration: const Duration(milliseconds: 500),
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          loc.languageSelectionDescription,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.black54,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                // Animated language list
                Expanded(
                  child: AnimationLimiter(
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: languages.length,
                      itemBuilder: (context, index) {
                        final language = languages[index];
                        return AnimationConfiguration.staggeredList(
                          position: index + 2,
                          duration: const Duration(milliseconds: 500),
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: _buildLanguageCard(context, language),
                            ),
                          ),
                        );
                      },
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

  Widget _buildLanguageCard(BuildContext context, Map<String, String> language) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.0),
        onTap: () => _changeLanguage(context, language['code']!),
        splashColor: Color(0xFF4070F4).withOpacity(0.2),
        highlightColor: Color(0xFF4070F4).withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Flag with scale animation
              ScaleTransition(
                scale: AlwaysStoppedAnimation(1.2),
                child: Text(
                  language['icon']!,
                  style: TextStyle(fontSize: 32),
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Language name with gradient text
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [Color(0xFF4070F4), Color(0xFF6A90FF)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ).createShader(bounds),
                      child: Text(
                        language['name']!,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 4),
                    // Language subtitle
                    Text(
                      language['subtitle']!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              // Animated arrow icon
              RotationTransition(
                turns: AlwaysStoppedAnimation(0.25), // 90 degrees
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xFF4070F4),
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}