import 'package:flutter/material.dart';
import 'package:final_thriving_together/pages/home_page.dart';
import 'package:final_thriving_together/registration/login.dart';
import 'package:final_thriving_together/registration/User_credentials.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../pages/loading_screen.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> with SingleTickerProviderStateMixin {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final GlobalKey<FormState> formState = GlobalKey();
  bool _isSecurePassword = true;

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    // Fade animation
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    // Slide animation
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    // Start the animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _navigateWithLoading(BuildContext context, Widget targetPage) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoadingScreen()),
    );

    await Future.delayed(Duration(seconds: 2));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => targetPage),
    );
  }

  void _submit() {
    final appLocalizations = AppLocalizations.of(context)!;
    if (formState.currentState?.validate() ?? false) {
      // Save user credentials
      UserCredentials.addUser(
        _usernameController.text,
        _passwordController.text,
        email: emailController.text
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(appLocalizations.accountSuccess)),
      );

      _navigateWithLoading(context, HomePage(
        username: _usernameController.text,
        password: _passwordController.text,
      ));
    }
  }

  String? validateEmail(String? value) {
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    final appLocalizations = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) {
      return appLocalizations.emptyField;
    } else if (!emailRegex.hasMatch(value)) {
      return appLocalizations.validEmail;
    }
    return null;
  }

  Widget togglePassword() {
    return IconButton(
      onPressed: () {
        setState(() {
          _isSecurePassword = !_isSecurePassword;
        });
      },
      icon: _isSecurePassword
          ? const Icon(Icons.visibility)
          : const Icon(Icons.visibility_off),
      color: Colors.grey,
    );
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    final isRTL = Localizations.localeOf(context).languageCode == 'ar';
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.9),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 50),
                        Text(
                          appLocalizations.signupPageTitle,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 35,
                          ),
                        ),
                        const SizedBox(height: 50),
                        Directionality(
                          textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                          child: Form(
                            key: formState,
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: _usernameController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return appLocalizations.emptyUser;
                                    }
                                    if (value.length > 10) {
                                      return appLocalizations.userChar;
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    labelText: appLocalizations.userTextfield,
                                    labelStyle: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(200),
                                      borderSide: const BorderSide(
                                          width: 5, color: Color(0xFF4070F4)),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(200),
                                      borderSide: const BorderSide(
                                          color: Color(0xFF4070F4), width: 5.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(200),
                                      borderSide: const BorderSide(
                                          color: Colors.yellow, width: 5.0),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                TextFormField(
                                  controller: emailController,
                                  validator: validateEmail,
                                  decoration: InputDecoration(
                                    labelText: appLocalizations.email,
                                    labelStyle: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(200),
                                      borderSide: const BorderSide(
                                          width: 5, color: Color(0xFF4070F4)),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(200),
                                      borderSide: const BorderSide(
                                          color: Color(0xFF4070F4), width: 5.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(50),
                                      borderSide: const BorderSide(
                                          color: Colors.yellow, width: 5.0),
                                    ),
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                const SizedBox(height: 20),
                                TextFormField(
                                  controller: _passwordController,
                                  obscureText: _isSecurePassword,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return appLocalizations.emptyPass;
                                    }
                                    if (value.length > 10) {
                                      return appLocalizations.passwordChar;
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    labelText: appLocalizations.passwordTextfield,
                                    labelStyle: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    suffixIcon: togglePassword(),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(200),
                                      borderSide: const BorderSide(
                                          width: 5, color: Color(0xFF4070F4)),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(200),
                                      borderSide: const BorderSide(
                                          color: Color(0xFF4070F4), width: 5.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(200),
                                      borderSide: const BorderSide(
                                          color: Colors.yellow, width: 5.0),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                TextFormField(
                                  controller: phoneController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return appLocalizations.emptyPhone;
                                    }
                                    if (!RegExp(r'^\d+$').hasMatch(value)) {
                                      return appLocalizations.phoneMust;
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    labelText: appLocalizations.phoneNumber,
                                    labelStyle: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(200),
                                      borderSide: const BorderSide(
                                          width: 5, color: Color(0xFF4070F4)),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(200),
                                      borderSide: const BorderSide(
                                          color: Color(0xFF4070F4), width: 5.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(200),
                                      borderSide: const BorderSide(
                                          color: Colors.yellow, width: 5.0),
                                    ),
                                  ),
                                  keyboardType: TextInputType.phone,
                                ),
                                const SizedBox(height: 30),
                                ElevatedButton(
                                  onPressed: _submit,
                                  style: ElevatedButton.styleFrom(backgroundColor:Color(0xFF4070F4)),
                                  child: Text(
                                    appLocalizations.signUp,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  appLocalizations.haveAccount,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: () {
                                    _navigateWithLoading(context, LoginForm());
                                  },
                                  style: ElevatedButton.styleFrom(backgroundColor:Color(0xFF4070F4)),
                                  child: Text(
                                    appLocalizations.login,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}