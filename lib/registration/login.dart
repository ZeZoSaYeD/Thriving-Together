import 'package:final_thriving_together/registration/forgot_password.dart';
import 'package:flutter/material.dart';
import 'package:final_thriving_together/registration/sign_up.dart';
import '../pages/home_page.dart';
import 'package:final_thriving_together/registration/User_credentials.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../pages/loading_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> with SingleTickerProviderStateMixin {
  bool status = false;
  bool _isSecurePassword = true;
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;
  final _storage = const FlutterSecureStorage();
  GlobalKey<FormState> formState = GlobalKey();

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _loadSavedCredentials();

    // Animation initialization
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadSavedCredentials() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final rememberMe = prefs.getBool('rememberMe') ?? false;

      if (rememberMe && mounted) {
        final username = prefs.getString('username') ?? '';
        final password = await _storage.read(key: 'password') ?? '';

        setState(() {
          _usernameController.text = username;
          _passwordController.text = password;
          status = rememberMe;
        });


       // UserCredentials.addUser(username, password);
      }
    } catch (e) {
      debugPrint('Error loading credentials: $e');
    }
  }

  Future<void> _saveCredentials(bool remember) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('rememberMe', remember);

    if (remember) {
      await prefs.setString('username', _usernameController.text);
      await _storage.write(key: 'password', value: _passwordController.text);
      final email = await _storage.read(key: 'email_${_usernameController.text}');
      // Add to validation map
      UserCredentials.addUser(_usernameController.text, _passwordController.text, email: email);
    } else {
      await prefs.remove('username');
      await _storage.delete(key: 'password');
    }
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

  Widget togglePassword() {
    return IconButton(
      onPressed: () {
        setState(() => _isSecurePassword = !_isSecurePassword);
      },
      icon: _isSecurePassword
          ? const Icon(Icons.visibility)
          : const Icon(Icons.visibility_off),
      color: Colors.grey,
    );
  }

  Future<void> _login() async {
    final appLocalizations = AppLocalizations.of(context)!;
    if (formState.currentState!.validate()) {
      String username = _usernameController.text;
      String password = _passwordController.text;

      try {
        // First validate the credentials
        if (UserCredentials.validateCredentials(username, password)) {
          // Only save credentials if validation succeeds
          await _saveCredentials(status);

          _navigateWithLoading(context, HomePage(
            username: username,
            password: password,
          ));
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(appLocalizations.wrongUserOrPass),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Login failed: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
        debugPrint('Login error: $e');
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isLargeScreen = screenSize.width > 600;
    final appLocalizations = AppLocalizations.of(context)!;
    final isRTL = Localizations.localeOf(context).languageCode == 'ar';
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.9),
      body: Stack(
        children: [
          // Background image with adjustments for visibility
          LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(), // Smooth scrolling
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight, // Fills the height
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
                        padding: const EdgeInsets.all(20.0),
                        constraints: BoxConstraints(
                          maxWidth: isLargeScreen ? 600 : double.infinity,
                        ),
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  appLocalizations.login,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 35,
                                  ),
                                  textAlign: TextAlign.center,
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
                                          textAlign: isRTL ? TextAlign.right : TextAlign.left,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return appLocalizations.emptyField;
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
                                                color: Colors.grey,
                                                width: 2.0,
                                              ),
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
                                        const SizedBox(height: 30),
                                        TextFormField(
                                          controller: _passwordController,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return appLocalizations.emptyField;
                                            } else if (value.length > 10) {
                                              return appLocalizations.passwordChar;
                                            }
                                            return null;
                                          },
                                          obscureText: _isSecurePassword,
                                          decoration: InputDecoration(
                                            labelText: appLocalizations.passwordTextfield,
                                            labelStyle: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(30.0),
                                              borderSide: const BorderSide(
                                                color: Colors.blue,
                                                width: 5.0,
                                              ),
                                            ),
                                            suffixIcon: togglePassword(),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(200),
                                              borderSide: const BorderSide(
                                                  color: Color(0xFF4070F4), width: 4.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(200),
                                              borderSide: const BorderSide(
                                                  color: Colors.yellow, width: 5.0),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 40),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      appLocalizations.rememberMe,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Checkbox(
                                      value: status,
                                      onChanged: (val) {
                                        setState(() {
                                          status = val!;
                                        });
                                      },
                                    ),
                                    Expanded(
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
                                          );
                                        },
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.green,
                                        ),
                                        child: Text(
                                          appLocalizations.forgotPassword,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 25.0),
                                Center(
                                  child: ElevatedButton(
                                    onPressed: _login,
                                    style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF4070F4),foregroundColor: Colors.white),// Use the _login method
                                    child: Text(
                                      appLocalizations.login,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  appLocalizations.account,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 20),
                                TextButton(
                                  onPressed: () {
                                    _navigateWithLoading(context, SignUpForm());
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.cyan,
                                  ),
                                  child:  Text(
                                    appLocalizations.newAccount,
                                    style: TextStyle(
                                        color: Color(0xFF4070F4),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}