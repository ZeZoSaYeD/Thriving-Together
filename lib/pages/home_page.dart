import 'dart:math';

import 'package:final_thriving_together/Theme_provider.dart';
import 'package:final_thriving_together/pages/Settings.dart';
import 'package:final_thriving_together/pages/congition_exercises.dart';
import 'package:final_thriving_together/pages/articles_page.dart';
import 'package:final_thriving_together/pages/diagnoses_page.dart';
import 'package:final_thriving_together/pages/exams_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../registration/User_credentials.dart';

class HomePage extends StatefulWidget {
  final String username;
  final String password;

  const HomePage({super.key, required this.username, required this.password});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  int currentIndex = 0;
  int _currentCarouselIndex = 0;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  /*Widget _buildRecommendationWidget(ThemeProvider themeProvider) {
    final List<String> questions = [
      "Does your child struggle with eye contact?",
      "Does your child have delayed speech?",
      "Does your child respond to their name?",
      "Does your child engage in repetitive behaviors?",
    ];
    List<bool?> answers = List.filled(4, null);

    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          children: [
            Text("Quick Assessment", style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: themeProvider.isDarkMode ? Colors.white : Colors.blue[800],
            )),
            SizedBox(height: 10),
            ...List.generate(questions.length, (index) {
              return Card(
                color: themeProvider.isDarkMode ? Colors.grey[800] : Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(questions[index], style: GoogleFonts.poppins(
                        color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                      )),
                      Row(
                        children: [
                          Radio<bool>(
                            value: true,
                            groupValue: answers[index],
                            onChanged: (value) => setState(() => answers[index] = value),
                          ),
                          Text("Yes", style: GoogleFonts.poppins(
                            color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                          )),
                          Radio<bool>(
                            value: false,
                            groupValue: answers[index],
                            onChanged: (value) => setState(() => answers[index] = value),
                          ),
                          Text("No", style: GoogleFonts.poppins(
                            color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                          )),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
            if (answers.every((a) => a != null))
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeProvider.isDarkMode ? Colors.blue[800] : Colors.blue,
                ),
                onPressed: () => _handleRecommendations(context, answers),
                child: Text("Get Recommendations", style: GoogleFonts.poppins(
                  color: Colors.white,
                )),
              ),
          ],
        );
      },
    );
  }

  void _handleRecommendations(BuildContext context, List<bool?> answers) async {
    // Save answers
    await UserCredentials.saveRecommendationAnswers(widget.username, answers);

    // Calculate score
    final score = answers.where((a) => a == true).length;

    // Navigate directly to recommended content
    if (score >= 3) {
      Navigator.push(context, MaterialPageRoute(
        builder: (context) => Diagnosespage(videoId: "autism_video"),
      ));
    } else if (score >= 1) {
      Navigator.push(context, MaterialPageRoute(
        builder: (context) => Articlespage(articleId: "speech_article"),
      ));
    } else {
      Navigator.push(context, MaterialPageRoute(
        builder: (context) => Examspage(examId: "basic_exam"),
      ));
    }
  }*/

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutQuint,
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final appLocalizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: themeProvider.isDarkMode ? Colors.black : Colors.white,
      body: Stack(
        children: [
          // Animated Background
          AnimatedContainer(
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

          // Content
          AnimationLimiter(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: AnimationConfiguration.toStaggeredList(
                    duration: const Duration(milliseconds: 500),
                    childAnimationBuilder: (widget) => SlideAnimation(
                      horizontalOffset: 0,
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: widget,
                      ),
                    ),
                    children: [
                      const SizedBox(height: 30),

                      // Animated Carousel
                      _buildAnimatedCarousel(themeProvider),

                      const SizedBox(height: 30),

                      // Welcome Section
                      _buildWelcomeSection(themeProvider, appLocalizations),

                      const SizedBox(height: 30),

                      // Motivational Quote
                      _buildMotivationalQuote(themeProvider, appLocalizations),

                      const SizedBox(height: 30),

                      // Quick Actions Grid
                      _buildQuickActionsGrid(themeProvider, appLocalizations),

                      const SizedBox(height: 30),

                      // Bottom Carousel
                      _buildBottomCarousel(themeProvider,appLocalizations),

                      const SizedBox(height: 50),

                      _buildContactSection(themeProvider, appLocalizations),

                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedCarousel(ThemeProvider themeProvider) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: CarouselSlider(
        options: CarouselOptions(
          autoPlay: true,
          enlargeCenterPage: true,
          aspectRatio: 16 / 9,
          viewportFraction: 0.9,
          onPageChanged: (index, reason) {
            setState(() {
              _currentCarouselIndex = index;
            });
          },
        ),
        items: [
          'assets/images/Fluency Disorders.jpg',
          'assets/images/languages.jpeg',
          'assets/images/voice.jpeg',
        ].map((imagePath) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: const Offset(0, 5),
                ),
              ],
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildWelcomeSection(ThemeProvider themeProvider, AppLocalizations appLocalizations) {

    final welcomeMessage = appLocalizations.welcomeMessage(widget.username);

    final parts = welcomeMessage.split('Thriving Together!');

    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: themeProvider.isDarkMode
                ? Colors.grey[900]!.withOpacity(0.7)
                : Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20),
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
              Text.rich(
                TextSpan(
                  children: [
                    // Part before "Thriving Together" (with default style)
                    TextSpan(
                      text: parts[0],
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: themeProvider.isDarkMode ? Colors.white : const Color(0xFF4070F4),
                        letterSpacing: 0.5,
                        height: 1.3,
                      ),
                    ),
                    // "Thriving Together" with custom color
                    TextSpan(
                      text: 'Thriving Together!',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFF56806), // Your orange color
                        letterSpacing: 0.5,
                        height: 1.3,
                      ),
                    ),
                    // Part after "Thriving Together" (with default style)
                    TextSpan(
                      text: parts.length > 1 ? parts[1] : '',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: themeProvider.isDarkMode ? Colors.white : const Color(0xFF4070F4),
                        letterSpacing: 0.5,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              /*Text(
                appLocalizations.welcomeSubtitle,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: themeProvider.isDarkMode
                      ? Colors.grey[300]
                      : Colors.grey[700],
                  fontStyle: FontStyle.italic,
                ),
              ),*/
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMotivationalQuote(ThemeProvider themeProvider, AppLocalizations appLocalizations) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: themeProvider.isDarkMode
              ? Colors.grey[800]!.withOpacity(0.8)
              : Colors.blue[50]!.withOpacity(0.8),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: themeProvider.isDarkMode
                ? Colors.blue[800]!
                : Colors.blue[200]!,
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Icon(
              Icons.format_quote,
              color: themeProvider.isDarkMode
                  ? Colors.blue[400]
                  : const Color(0xFF4070F4),
              size: 36,
            ),
            const SizedBox(height: 10),
            Text(
              _getRandomQuote(appLocalizations),
              style: GoogleFonts.lora(
                fontSize: 18,
                fontStyle: FontStyle.italic,
                color: themeProvider.isDarkMode
                    ? Colors.white
                    : Colors.grey[800],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Icon(
              Icons.format_quote,
              color: themeProvider.isDarkMode
                  ? Colors.blue[400]
                  : const Color(0xFF4070F4),
              size: 36,
              textDirection: TextDirection.rtl,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionsGrid(ThemeProvider themeProvider, AppLocalizations appLocalizations) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 1.1,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          children: [
            _buildAnimatedActionCard(
              context,
              icon: Icons.article,
              label: appLocalizations.articlesPageTitle,
              color: themeProvider.isDarkMode ? Colors.white : Colors.blue,
              route: Articlespage(),
              themeProvider: themeProvider,
            ),
            _buildAnimatedActionCard(
              context,
              icon: Icons.quiz,
              label: appLocalizations.exams,
              color: themeProvider.isDarkMode ? Colors.white : Colors.orange,
              route: Examspage(),
              themeProvider: themeProvider,
            ),
            _buildAnimatedActionCard(
              context,
              icon: Icons.medical_services,
              label: appLocalizations.diagnosesPageTitle,
              color: themeProvider.isDarkMode ? Colors.white : Colors.green,
              route: Diagnosespage(),
              themeProvider: themeProvider,
            ),
            _buildAnimatedActionCard(
              context,
              icon: Icons.settings,
              label: appLocalizations.settingsPageTitle,
              color: themeProvider.isDarkMode ? Colors.white : Colors.grey,
              route: SettingsPage(),
              themeProvider: themeProvider,
            ),
           /* _buildAnimatedActionCard(
              context,
              icon: Icons.keyboard_voice_sharp,
              label: appLocalizations.help,
              color: themeProvider.isDarkMode ? Colors.white : Colors.grey,
              route: SettingsPage(),
              themeProvider: themeProvider,
            ),*/
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedActionCard(
      BuildContext context, {
        required IconData icon,
        required String label,
        required Color color,
        required Widget route,
        required ThemeProvider themeProvider,
      }) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            color: themeProvider.isDarkMode ? Colors.grey[800] : Colors.white,
            child: InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => route));
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      themeProvider.isDarkMode ? Colors.grey[800]! : Colors.white,
                      themeProvider.isDarkMode ? Colors.grey[700]! : Colors.grey[50]!,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: themeProvider.isDarkMode
                          ? Colors.black.withOpacity(0.3)
                          : Colors.blue[100]!,
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        icon,
                        size: 40,
                        color: color,
                      ),
                      const SizedBox(height: 15),
                      Text(
                        label,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: themeProvider.isDarkMode ? Colors.white : Colors.grey[800],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomCarousel(ThemeProvider themeProvider,AppLocalizations applocalizations) {
    final List<Map<String, String>> carouselItems = [
      {
        'image': 'assets/images/sky.jpg',
        'text': applocalizations.carouseltext1,
      },
      {
        'image': 'assets/images/kids.jpg',
        'text': applocalizations.carouseltext2,
      },
      {
        'image': 'assets/images/play.jpg',
        'text': applocalizations.carouseltext3,
      },
    ];

    return FadeTransition(
      opacity: _fadeAnimation,
      child: CarouselSlider(
        options: CarouselOptions(
          autoPlay: true,
          enlargeCenterPage: true,
          aspectRatio: 16 / 9,
          viewportFraction: 0.9,
        ),
        items: carouselItems.map((item) {
          return Stack(
            children: [
              // Image Container (keep your existing styling)
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: const Offset(0, 5),
                    ),
                  ],
                  image: DecorationImage(
                    image: AssetImage(item['image']!),
                    fit: BoxFit.fill,
                    colorFilter: ColorFilter.mode(Colors.blue.withOpacity(0.3), BlendMode.darken)
                  ),
                ),
              ),
              // Text Overlay
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 50,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      item['text']!,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  String _getRandomQuote(AppLocalizations loc) {
    final randomIndex = Random().nextInt(3);
    switch (randomIndex) {
      case 0:
        return loc.motivationalQuote1;
      case 1:
        return loc.motivationalQuote2;
      case 2:
        return loc.motivationalQuote3;
      default:
        return loc.motivationalQuote1;
    }
  }
  Widget _buildContactSection(ThemeProvider themeProvider, AppLocalizations appLocalizations) {
    /*final _formKey = GlobalKey<FormState>();
    final _nameController = TextEditingController();
    final _emailController = TextEditingController();
    final _messageController = TextEditingController();
    */

    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: themeProvider.isDarkMode
                ? Colors.grey[800]!.withOpacity(0.8)
                : Colors.blue[50]!.withOpacity(0.8),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: themeProvider.isDarkMode
                  ? Colors.blue[800]!
                  : Colors.blue[200]!,
              width: 1.5,
            ),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appLocalizations.contactUs,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: themeProvider.isDarkMode ? Colors.white : const Color(0xFF4070F4),
                  ),
                ),
                const SizedBox(height: 15),

                // Name Field
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: appLocalizations.name,
                    labelStyle: GoogleFonts.poppins(
                      color: themeProvider.isDarkMode ? Colors.grey[400] : Colors.grey[700],
                    ),
                    prefixIcon: Icon(Icons.person, color: const Color(0xFF4070F4)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: themeProvider.isDarkMode ? Colors.grey[700] : Colors.white,
                  ),
                  style: GoogleFonts.poppins(
                    color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return appLocalizations.nameRequired;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),

                // Email Field
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: appLocalizations.email,
                    labelStyle: GoogleFonts.poppins(
                      color: themeProvider.isDarkMode ? Colors.grey[400] : Colors.grey[700],
                    ),
                    prefixIcon: Icon(Icons.email, color: const Color(0xFF4070F4)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: themeProvider.isDarkMode ? Colors.grey[700] : Colors.white,
                  ),
                  style: GoogleFonts.poppins(
                    color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return appLocalizations.emailRequired;
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return appLocalizations.validEmail;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),

                // Message Field
                TextFormField(
                  controller: _messageController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: appLocalizations.message,
                    labelStyle: GoogleFonts.poppins(
                      color: themeProvider.isDarkMode ? Colors.grey[400] : Colors.grey[700],
                    ),
                    prefixIcon: Icon(Icons.message, color: const Color(0xFF4070F4)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: themeProvider.isDarkMode ? Colors.grey[700] : Colors.white,
                  ),
                  style: GoogleFonts.poppins(
                    color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return appLocalizations.messageRequired;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4070F4),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _submitContactForm(context);
                      }
                    },
                    child: Text(
                      appLocalizations.submit,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
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

  Future<void> _submitContactForm(BuildContext context) async {
    try {
      // Helper function moved outside the parameter list
      String encodeQueryParameters(Map<String, String> params) {
        return params.entries
            .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
            .join('&');
      }

      final Uri emailUri = Uri(
        scheme: 'mailto',
        path: 'zeyadsayed775@gmail.com',
        query: encodeQueryParameters({
          'subject': 'Contact Form Submission',
          'body': 'Name: ${_nameController.text}\n'
              'Email: ${_emailController.text}\n\n'
              'Message: ${_messageController.text}'
        }),
      );

      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
        _nameController.clear();
        _emailController.clear();
        _messageController.clear();
      } else {
        throw 'Could not launch email client';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }
}