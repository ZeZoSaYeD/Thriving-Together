import 'package:flutter/material.dart';
import 'package:final_thriving_together/language_selection.dart';
import 'package:final_thriving_together/pages/loading_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'Theme_provider.dart';
import 'dart:math';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoScale;
  late Animation<double> _textOpacity;
  late Animation<Offset> _buttonSlide;
  late Animation<double> _backgroundFade;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Logo scale animation
    _logoScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    // Text fade animation
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(0.3, 1.0, curve: Curves.easeIn),
        ),
    );

        // Button slide animation
        _buttonSlide = Tween<Offset>(
        begin: const Offset(0, 1.5),
    end: Offset.zero,
    ).animate(
    CurvedAnimation(
    parent: _controller,
    curve: Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
    ),
    );

    // Background fade animation
    _backgroundFade = Tween<double>(begin: 0.0, end: 1.0).animate(
    CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,
    ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _navigateToLogin(BuildContext context) async {
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
      ),
    );

    await Future.delayed(Duration(seconds: 2));

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => LanguageSelectionPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var curve = Curves.easeInOut;
          var tween = Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: curve));
          return FadeTransition(
            opacity: animation.drive(tween),
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

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: themeProvider.isDarkMode
              ? Colors.grey[900]!.withOpacity(_backgroundFade.value)
              : Color(0xFF4070F4).withOpacity(_backgroundFade.value),
          body: Stack(
              children: [
          // Animated background elements
          Positioned.fill(
          child: _AnimatedBackground(controller: _controller),
        ),

        Center(
        child: SingleChildScrollView(
        child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        // Logo with scale animation
        Align(
          alignment: Alignment.topRight,
          child: ScaleTransition(
          scale: _logoScale,
          child: Image.asset(
          'assets/images/logo.png',
          height: 100,
          width: 100,
          ),
          ),
        ),

        const SizedBox(height: 30),

        // Welcome text with fade animation
        FadeTransition(
        opacity: _textOpacity,
        child: Text(
        appLocalizations.splashWelcome,
        style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        //color: Color(0xFF4070F4),
          color: Colors.white,
        shadows: [
        Shadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 10,
        offset: Offset(2, 2),
        ),
        ],
        ),
        ),
        ),

        const SizedBox(height: 30),

        // Motto text with fade animation
        FadeTransition(
        opacity: _textOpacity,
        child: Text(
        appLocalizations.splashMoto,
        style: TextStyle(
        fontSize: 18,
        color: themeProvider.isDarkMode
        ? Colors.white
            : Colors.black,
        ),
        textAlign: TextAlign.center,
        ),
        ),

        const SizedBox(height: 40),

        // Button with slide animation
        SlideTransition(
        position: _buttonSlide,
        child: AnimatedButton(
        onPressed: () => _navigateToLogin(context),
        text: appLocalizations.splashButton,
        themeProvider: themeProvider,
        ),
        ),

        const SizedBox(height: 20),

        // Animated decorative image
        _AnimatedImage(controller: _controller),
        ],
        ),
        ),
        ),
        ),
        ],
        ),
        );
      },
    );
  }
}

class _AnimatedBackground extends StatelessWidget {
  final AnimationController controller;

  const _AnimatedBackground({required this.controller});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _BackgroundPainter(
            animationValue: controller.value,
            isDarkMode: themeProvider.isDarkMode,
          ),
        );
      },
    );
  }
}

class _BackgroundPainter extends CustomPainter {
  final double animationValue;
  final bool isDarkMode;

  _BackgroundPainter({required this.animationValue, required this.isDarkMode});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = (isDarkMode ? Colors.blue[900]! : Colors.blue[100]!)
          .withOpacity(0.15 * animationValue)
      ..style = PaintingStyle.fill;

    // Draw animated circles
    for (int i = 0; i < 3; i++) {
      final radius = 50.0 + 100.0 * i + 50.0 * sin(animationValue * 2 * pi);
      canvas.drawCircle(
        center,
        radius * (0.5 + 0.5 * animationValue),
        paint..color = paint.color.withOpacity(0.05 * (i + 1)),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class AnimatedButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String text;
  final ThemeProvider themeProvider;

  const AnimatedButton({
    required this.onPressed,
    required this.text,
    required this.themeProvider,
  });

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _hoverController.forward(),
      onExit: (_) => _hoverController.reverse(),
      child: AnimatedBuilder(
        animation: _hoverController,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 + 0.05 * _hoverController.value,
            child: ElevatedButton(
              onPressed: widget.onPressed,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                backgroundColor: widget.themeProvider.isDarkMode
                    ? Color(0xFFF56806)
                    : Color(0xFFF56806),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 5 + 3 * _hoverController.value,
                shadowColor: Colors.blue.withOpacity(0.5),
              ),
              child: Text(
                widget.text,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _AnimatedImage extends StatelessWidget {
  final AnimationController controller;

  const _AnimatedImage({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - controller.value)),
          child: Opacity(
            opacity: controller.value,
            child: Image.asset(
              'assets/images/1.png',
              height: 300,
              fit: BoxFit.contain,
            ),
          ),
        );
      },
    );
  }
}

/*import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:final_thriving_together/Theme_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final appLocalizations = AppLocalizations.of(context)!;

    return Scaffold(
      body: Stack(
        children: [
          // Animated background
          _AnimatedBackground(themeProvider: themeProvider),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated text with gradient and shine effect
                _AnimatedText(
                  text: appLocalizations.loading,
                  themeProvider: themeProvider,
                ),

                const SizedBox(height: 40),

                // Logo with pulse animation (no rotation)
                _PulsingLogo(),

                const SizedBox(height: 30),

                // Circular progress indicator that fills continuously
                _CircularProgressLoader(themeProvider: themeProvider),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedBackground extends StatelessWidget {
  final ThemeProvider themeProvider;

  const _AnimatedBackground({required this.themeProvider});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: ColorTween(
        begin: themeProvider.isDarkMode ? Colors.grey[900] : Colors.blue[50],
        end: themeProvider.isDarkMode ? Colors.black : Colors.white,
      ),
      duration: const Duration(seconds: 3),
      builder: (context, color, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.topLeft,
              radius: 1.5,
              colors: [
                color!.withOpacity(0.8),
                color.withOpacity(0.2),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AnimatedText extends StatefulWidget {
  final String text;
  final ThemeProvider themeProvider;

  const _AnimatedText({
    required this.text,
    required this.themeProvider,
  });

  @override
  __AnimatedTextState createState() => __AnimatedTextState();
}

class __AnimatedTextState extends State<_AnimatedText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<double> _scale;
  late Animation<double> _shine;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    )..repeat(reverse: true);

    _fade = Tween(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _scale = Tween(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _shine = Tween(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (rect) {
            return LinearGradient(
              colors: [
                widget.themeProvider.isDarkMode
                    ? Colors.blueAccent
                    : Colors.blue[800]!,
                widget.themeProvider.isDarkMode
                    ? Colors.lightBlueAccent
                    : Colors.blue[400]!,
                widget.themeProvider.isDarkMode
                    ? Colors.blueAccent
                    : Colors.blue[800]!,
              ],
              stops: [0, _shine.value.clamp(0.0, 1.0), 1],
            ).createShader(rect);
          },
          child: Transform.scale(
            scale: _scale.value,
            child: Opacity(
              opacity: _fade.value,
              child: Text(
                widget.text,
                style: TextStyle(
                  fontSize: 36.0,
                  fontWeight: FontWeight.w800,
                  fontStyle: FontStyle.italic,
                  letterSpacing: 1.5,
                  shadows: [
                    Shadow(
                      color: widget.themeProvider.isDarkMode
                          ? Colors.blue.withOpacity(0.5)
                          : Colors.blue.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PulsingLogo extends StatefulWidget {
  @override
  __PulsingLogoState createState() => __PulsingLogoState();
}

class __PulsingLogoState extends State<_PulsingLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<double> _opacity;
  late Animation<Color?> _color;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _scale = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.9, end: 1.1), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.1, end: 0.9), weight: 1),
    ]).animate(_controller);

    _opacity = Tween(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _color = ColorTween(
      begin: Colors.orange,
      end: Colors.orangeAccent,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scale.value,
          child: Opacity(
            opacity: _opacity.value,
            child:
            /*ColorFiltered(
              colorFilter: ColorFilter.mode(
                _color.value!,
                BlendMode.modulate,
              ),*/

              Image.asset(
                'assets/images/logo.png',
                width: 200,
                height: 200,
              ),
            ),
        );
      },
    );
  }
}

class _CircularProgressLoader extends StatefulWidget {
  final ThemeProvider themeProvider;

  const _CircularProgressLoader({required this.themeProvider});

  @override
  __CircularProgressLoaderState createState() => __CircularProgressLoaderState();
}

class __CircularProgressLoaderState extends State<_CircularProgressLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 60,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CircularProgressIndicator(
            value: _controller.value,
            strokeWidth: 6,
            backgroundColor: widget.themeProvider.isDarkMode
                ? Colors.grey[800]
                : Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(
              widget.themeProvider.isDarkMode
                  ? Colors.lightBlueAccent
                  : Colors.blueAccent,
            ),
          );
        },
      ),
    );
  }
}*/