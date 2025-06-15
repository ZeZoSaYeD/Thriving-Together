import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:final_thriving_together/Theme_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final appLocalizations = AppLocalizations.of(context)!;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: themeProvider.isDarkMode
              ? null
              : LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF4070F4), Colors.grey[50]!],
          ),
          color: themeProvider.isDarkMode ? Colors.grey[900] : null,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Simple pulsing logo
              _SimplePulsingLogo(),

              const SizedBox(height: 40),

              // Clean loading text with fade transition
              _FadingLoadingText(
                text: appLocalizations.loading,
                themeProvider: themeProvider,
              ),

              const SizedBox(height: 30),

              // Minimalist progress indicator
              _MinimalistLoader(themeProvider: themeProvider),
            ],
          ),
        ),
      ),
    );
  }
}

class _FadingLoadingText extends StatefulWidget {
  final String text;
  final ThemeProvider themeProvider;

  const _FadingLoadingText({
    required this.text,
    required this.themeProvider,
  });

  @override
  _FadingLoadingTextState createState() => _FadingLoadingTextState();
}

class _FadingLoadingTextState extends State<_FadingLoadingText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _opacity = Tween(begin: 0.6, end: 1.0).animate(
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
    return FadeTransition(
      opacity: _opacity,
      child: Text(
        widget.text,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w500,
          color: widget.themeProvider.isDarkMode
              ? Colors.white
              : Colors.grey[800],
          fontFamily: 'Poppins',
        ),
      ),
    );
  }
}

class _SimplePulsingLogo extends StatefulWidget {
  @override
  _SimplePulsingLogoState createState() => _SimplePulsingLogoState();
}

class _SimplePulsingLogoState extends State<_SimplePulsingLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _scale = Tween(begin: 0.95, end: 1.0).animate(
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
        return Transform.scale(
          scale: _scale.value,
          child: Image.asset(
            'assets/images/logo.png',
            width: 120,
            height: 120,
          ),
        );
      },
    );
  }
}

class _MinimalistLoader extends StatefulWidget {
  final ThemeProvider themeProvider;

  const _MinimalistLoader({required this.themeProvider});

  @override
  _MinimalistLoaderState createState() => _MinimalistLoaderState();
}

class _MinimalistLoaderState extends State<_MinimalistLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
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
      width: 40,
      height: 40,
      child: CircularProgressIndicator(
        strokeWidth: 3,
        valueColor: AlwaysStoppedAnimation<Color>(
          widget.themeProvider.isDarkMode
              ? Colors.orangeAccent
              : Color(0xFF4070F4),
        ),
      ),
    );
  }
}