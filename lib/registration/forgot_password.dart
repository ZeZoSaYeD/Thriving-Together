import 'package:final_thriving_together/registration/User_credentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool _showPasswordFields = false;
  bool _isSecurePassword = true;

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

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
    _emailController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
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

  Future<void> _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;

      if (!_showPasswordFields) {
        // First check if any user has this email
        final username = UserCredentials.getUsernameByEmail(email);
        if (username != null && username.isNotEmpty) {
          setState(() {
            _showPasswordFields = true;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.emailNotFound),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        if (_newPasswordController.text == _confirmPasswordController.text) {
          final success = await UserCredentials.resetPassword(
            email,
            _newPasswordController.text,
          );

          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppLocalizations.of(context)!.passwordResetSuccess),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppLocalizations.of(context)!.passwordResetFailed),
                backgroundColor: Colors.red,
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.passwordsDontMatch),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    final isRTL = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.9),
      appBar: AppBar(
        title: Text(appLocalizations.forgotPassword),
        backgroundColor: const Color(0xFF4070F4),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
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
                          appLocalizations.resetPassword,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 35,
                          ),
                        ),
                        const SizedBox(height: 50),
                        Directionality(
                          textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                    controller: _emailController,
                                    textAlign: isRTL ? TextAlign.right : TextAlign.left,
                                    decoration: InputDecoration(
                                      labelText: appLocalizations.email,
                                      labelStyle: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      border:
                                      OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(200),
                                        borderSide: const BorderSide(
                                          width: 5,
                                          color: Color(0xFF4070F4),
                                        ),
                                      ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(200),
                                          borderSide: const BorderSide(
                                            color: Color(0xFF4070F4),
                                            width: 5.0,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(200),
                                          borderSide: const BorderSide(
                                            color: Colors.yellow,
                                            width: 5.0,
                                          ),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return appLocalizations.emailRequired;
                                        }
                                        return null;
                                      },
                                      enabled: !_showPasswordFields,
                                    ),
                                if (_showPasswordFields) ...[
                                  const SizedBox(height: 20),
                                  TextFormField(
                                      controller: _newPasswordController,
                                      textAlign: isRTL ? TextAlign.right : TextAlign.left,
                                      decoration: InputDecoration(
                                          labelText: appLocalizations.newPassword,
                                          labelStyle: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          suffixIcon: togglePassword(),
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(200),
                                              borderSide: const BorderSide(
                                                width: 5,
                                                color: Color(0xFF4070F4),
                                              ),
                                          ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(200),
                                                borderSide: const BorderSide(
                                                  color: Color(0xFF4070F4),
                                                  width: 5.0,
                                                ),
                                              ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(200),
                                                  borderSide: const BorderSide(
                                                    color: Colors.yellow,
                                                    width: 5.0,
                                                  ),
                                                ),
                                      ),
                                                obscureText: _isSecurePassword,
                                                validator: (value) {
                                                  if (value == null || value.isEmpty) {
                                                    return appLocalizations.passwordRequired;
                                                  }
                                                  if (value.length > 10) {
                                                    return appLocalizations.passwordChar;
                                                  }
                                                  return null;
                                                },
                                              ),
                                              const SizedBox(height: 20),
                                              TextFormField(
                                                controller: _confirmPasswordController,
                                                textAlign: isRTL ? TextAlign.right : TextAlign.left,
                                                decoration: InputDecoration(
                                                  labelText: appLocalizations.confirmPassword,
                                                  labelStyle: const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  suffixIcon: togglePassword(),
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(200),
                                                    borderSide: const BorderSide(
                                                      width: 5,
                                                      color: Color(0xFF4070F4),
                                                    ),
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(200),
                                                    borderSide: const BorderSide(
                                                      color: Color(0xFF4070F4),
                                                      width: 5.0,
                                                    ),
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(200),
                                                    borderSide: const BorderSide(
                                                      color: Colors.yellow,
                                                      width: 5.0,
                                                    ),
                                                  ),
                                                ),
                                                obscureText: _isSecurePassword,
                                                validator: (value) {
                                                  if (value == null || value.isEmpty) {
                                                    return appLocalizations.passwordRequired;
                                                  }
                                                  if (value != _newPasswordController.text) {
                                                    return appLocalizations.passwordsDontMatch;
                                                  }
                                                  return null;
                                                },
                                              ),
                                              ],
                                              const SizedBox(height: 30),
                                          ElevatedButton(
                                            onPressed: _resetPassword,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(0xFF4070F4),
                                              foregroundColor: Colors.white,
                                            ),
                                            child: Text(
                                              _showPasswordFields
                                                  ? appLocalizations.resetPassword
                                                  : appLocalizations.verifyEmail,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          if (_showPasswordFields) ...[
                                      const SizedBox(height: 20),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _showPasswordFields = false;
                                      });
                                    },
                                    child: Text(
                                      appLocalizations.back,
                                      style: const TextStyle(
                                        color: Color(0xFF4070F4),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
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