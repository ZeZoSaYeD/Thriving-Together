import 'package:final_thriving_together/articles/Asd_page.dart';
import 'package:final_thriving_together/articles/Language_disorders_page.dart';
import 'package:final_thriving_together/articles/Speech_disorders_page.dart';
import 'package:final_thriving_together/pages/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:final_thriving_together/navigation_bar.dart';
import 'package:final_thriving_together/Theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class Articlespage extends StatefulWidget {
  final String? articleId;
  const Articlespage({this.articleId, Key? key}) : super(key: key);

  @override
  State<Articlespage> createState() => _ArticlespageState();
}

class _ArticlespageState extends State<Articlespage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  int currentIndex = 1;
  bool _showRecommendedArticle = false;

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

    // Check if we should show recommended article
    _showRecommendedArticle = widget.articleId != null;
    _controller.forward();
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

    // Show recommended article immediately if ID is provided
    if (_showRecommendedArticle) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showRecommendedArticle = false; // Prevent infinite rebuild
        _navigateToSpecificArticle(widget.articleId!);
      });
    }


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
            widget.articleId != null
                ? appLocalizations.recommendedArticle
                : appLocalizations.articlesPageTitle,
            key: ValueKey<String>(widget.articleId != null
                ? "recommended"
                : "regular"),
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
                      if (widget.articleId == null) ...[
                        const SizedBox(height: 20),
                        _buildArticleCard(
                          context,
                          imagePath: "assets/images/image2.jpg",
                          title: appLocalizations.speechDisorders,
                          description: appLocalizations.speechDisordersDesc,
                          route: SpeechDisordersPage(),
                        ),
                        const SizedBox(height: 20),
                        _buildArticleCard(
                          context,
                          imagePath: "assets/images/language.jpg",
                          title: appLocalizations.languageDisorders,
                          description: appLocalizations.languageDisordersDesc,
                          route: LanguageDisordersPage(),
                        ),
                        const SizedBox(height: 20),
                        _buildArticleCard(
                          context,
                          imagePath: "assets/images/autism.jpg",
                          title: appLocalizations.autismSpectrum,
                          description: appLocalizations.autismSpectrumDesc,
                          route: AsdPage(),
                        ),
                        const SizedBox(height: 30),
                      ],
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

  Widget _buildArticleCard(
      BuildContext context, {
        required String imagePath,
        required String title,
        required String description,
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
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      child: Image.asset(
                        imagePath,
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
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
                                appLocalizations.readMore,
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

  void _navigateToSpecificArticle(String articleId) {
    Widget targetPage;

    // Map article IDs to their corresponding pages
    switch (articleId) {
      case "autism_article":
        targetPage = AsdPage();
        break;
      case "speech_article":
        targetPage = SpeechDisordersPage();
        break;
      case "language_article":
        targetPage = LanguageDisordersPage();
        break;
      default:
        targetPage = AsdPage(); // Default fallback
    }

    _navigateWithLoading(context, targetPage);
  }
}